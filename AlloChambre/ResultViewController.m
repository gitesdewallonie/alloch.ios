//
//  ResultViewController.m
//  AlloChambre
//

#import "ResultViewController.h"
#import "Constants.h"
#import "TableViewCell.h"
#import "GroupedRoomsViewController.h"
#import "DetailViewController.h"
#import "MyAnnotationView.h"

@implementation ResultViewController

#define kSpan 0.027

@synthesize timesFired;
@synthesize searchedForAddress;
@synthesize searchString;
@synthesize mapView;
@synthesize resultTableView;
@synthesize imageDownloadsInProgress;
@synthesize locationManager;


@synthesize annotationsArray;

#pragma mark - Private Methods

- (void)removeDelegateForIconDownloader {
    NSArray *allKeys = [self.imageDownloadsInProgress allKeys];
    for (int i = 0; i < [allKeys count]; i++) {
        NSIndexPath *indexPath = [allKeys objectAtIndex:i];
        IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
        [iconDownloader cancelDownload];
        [iconDownloader setDelegate:nil];
    }
}

- (void)goBack {
    [_parser cancelParsing];
    [self removeDelegateForIconDownloader];
    [_parser setDelegate:nil];
    [_parser release];
    _parser = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goToAccomodation:(NSInteger)number {
    AccomodationContainer *container = [entries objectAtIndex:number];
    NSLog(@"Name:%@", [container getName]);
    NSString *name = [NSString stringWithFormat:@"%@", [container getName]];
    
    if ([container getCount] > 1) {
        GroupedRoomsViewController *gView = [[GroupedRoomsViewController alloc] 
                                             initWithNibName:@"GroupedRoomsViewController"                                                                                         bundle:nil
                                             andRooms:container.accomodationArray
											 andName:name];
        [self.navigationController pushViewController:gView animated:YES];
        [gView release];
        gView = nil;
    } else {
        DetailViewController *dView = [[DetailViewController alloc] initWithNibName:@"DetailViewController"
                                            bundle:nil
                                                                    andAccomodation:[container getAccomodation]];
        [self.navigationController pushViewController:dView animated:YES];
        [dView release];
        dView = nil;
    }
}

- (void)startIconDownload:(Accomodation *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
        iconDownloader = nil;
    }
}

- (void)loadImagesForOnscreenRows
{
    if ([entries count] > 0)
    {
        NSArray *visiblePaths = [self.resultTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Accomodation *appRecord = [entries objectAtIndex:indexPath.row];
            
            // avoid the app icon download if the app already has an icon
            if (!appRecord.image) {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView { 
    if ([self.mapView.annotations count] == 0) return; 
    
    CLLocationCoordinate2D topLeftCoord; 
    topLeftCoord.latitude = -90; 
    topLeftCoord.longitude = 180; 
    
    CLLocationCoordinate2D bottomRightCoord; 
    bottomRightCoord.latitude = 90; 
    bottomRightCoord.longitude = -180; 
    
    for(MyLocation *annotation in self.mapView.annotations) { 
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude); 
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude); 
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude); 
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude); 
    } 
    
    MKCoordinateRegion region; 
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5; 
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;      
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.7; // 1.1
    
    // Add a little extra space on the sides 
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.7; // 1.1
    
    // Add a little extra space on the sides 
    region = [self.mapView regionThatFits:region]; 
    [self.mapView setRegion:region animated:YES]; 
}


/* this simply adds a single pin and zooms in on it nicely */
- (void) zoomToAnnotation:(MyLocation*)annotation {
    MKCoordinateSpan span = {kSpan, kSpan};
    MKCoordinateRegion region = {[annotation coordinate], span};
    [self.mapView setRegion:region animated:YES];
}

/* This returns a rectangle bounding all of the pins within the supplied
 array */
- (MKMapRect) getMapRectUsingAnnotations:(NSArray*)theAnnotations {
    MKMapPoint points[[theAnnotations count]];
    
    for (int i = 0; i < [theAnnotations count]; i++) {
        MyLocation *annotation = [theAnnotations objectAtIndex:i];
        points[i] = MKMapPointForCoordinate(annotation.coordinate);
    }
    
    MKPolygon *poly = [MKPolygon polygonWithPoints:points count:[theAnnotations count]];
    
    return [poly boundingMapRect];
}

/* this adds the provided annotation to the mapview object, zooming 
 as appropriate */
- (void) addMapAnnotationToMapView:(MyLocation*)annotation {
    if ([entries count] == 1) {
        // If there is only one annotation then zoom into it.
        [self zoomToAnnotation:annotation];
    } else {
        // If there are several, then the default behaviour is to show all of them
        //
        MKCoordinateRegion region = MKCoordinateRegionForMapRect([self getMapRectUsingAnnotations:self.annotationsArray]);
        
        if (region.span.latitudeDelta < kSpan) {
            region.span.latitudeDelta = kSpan;
        }
        
        if (region.span.longitudeDelta < kSpan) {
            region.span.longitudeDelta = kSpan;
        }
        [self.mapView setRegion:region];
    }
    
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}


- (void)drawPinsOnMap{
    [self.annotationsArray removeAllObjects];

	if (self.searchedForAddress == YES) {
		AccomodationContainer *searchedContainer = [entries objectAtIndex:0];
		Accomodation *searchedAnnotation = [searchedContainer getAccomodation];

	    CLLocationCoordinate2D coords = {searchedAnnotation.searchLocation.longitude.doubleValue,
										 searchedAnnotation.searchLocation.latitude.doubleValue};
		NSString *searchedTitle = searchedAnnotation.searchLocation.title;
		MyLocation *annotation = [[MyLocation alloc] initWithName:searchedTitle
		                                                  address:nil 
		                                               coordinate:coords];
		[annotation setTag:0];
		[self.annotationsArray addObject:annotation];
		[self.mapView addAnnotation:annotation];    
		[annotation release];
		annotation = nil;		
	}

    for (int i = 0; i < [entries count]; i++) {
        AccomodationContainer *container = [entries objectAtIndex:i];
        CLLocationCoordinate2D mapCoords = [container getCoord];
        //NSLog(@"L:%f, LN:%f", mapCoords.latitude, mapCoords.longitude);
        
        MyLocation *annotation = [[MyLocation alloc] initWithName:[container getName]
                                                          address:nil 
                                                       coordinate:mapCoords];
        [annotation setTag:i+1];
        [self.annotationsArray addObject:annotation];
        [self.mapView addAnnotation:annotation];    
        [annotation release];
        annotation = nil;
    }

    // USE THIS METHOD TO CENTER ZOOM THE ANOTATIONS
    [self zoomToFitMapAnnotations:self.mapView];
    // OR USE THE LOOP BELOW
    
    //for (int i = 0; i < [self.annotationsArray count]; i++) {
    //    [self addMapAnnotationToMapView:[self.annotationsArray objectAtIndex:i]];
    //}
}

#pragma mark - IconDownloaderDelegate Methods

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.resultTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.appRecord.image;
    }
}



#pragma mark - Class Methods

-(void) viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        [HUD hide:YES afterDelay:kHUDHideInterval];
        if (self.locationManager) {
            self.locationManager.delegate = nil;
            [self.locationManager stopUpdatingHeading];
            self.locationManager = nil;
        }
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.  
        
    }
    [super viewWillDisappear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSearchString:(NSString *)string {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
        self.annotationsArray = [NSMutableArray arrayWithCapacity:2];
        entries = [[NSMutableArray alloc] init];
        _parser = [[AccomodationParser alloc] init];
        [_parser setDelegate:self];
        
        self.searchString = string;
        
    }
    return self;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)showTableView {
    [HUD hide:YES afterDelay:kHUDHideInterval];
    [self.resultTableView setHidden:NO];
}

- (void)populateTableView {
	HUD.labelText = NSLocalizedString(@"Loading",nil);

    [self.resultTableView setHidden:YES];
    [entries removeAllObjects];
    [_parser requestAccomodationForSearchString:self.searchString];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"ResultViewTitle", nil);
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HUD setUserInteractionEnabled:NO];
    [noResults setHidden:YES];
    noResults.text = NSLocalizedString(@"NoResults", nil);;
    
    [self.mapView setMapType:MKMapTypeStandard];
	self.timesFired = 0;
    
    if (self.searchString) {
        //NSLog(@"Search with String");
		self.searchedForAddress = YES;
  		mapView.showsUserLocation = NO;
        [self populateTableView];        
        
    } else {
        //NSLog(@"Search with Coords");
		self.searchedForAddress = NO;
  		mapView.showsUserLocation = YES;
		HUD.labelText = NSLocalizedString(@"Locating",nil);
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
		self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // kCLLocationAccuracyNearestTenMeters - kCLLocationAccuracyHundredMeters - kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 10; // or whatever

        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }

        [self.locationManager startUpdatingLocation];

    }

}


- (void)mapView:(MKMapView *)mapView annotationView:(MyAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self goToAccomodation:view.resultNumber-1];
  }

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
	if([annotation class] == MKUserLocation.class) {
		return nil;
	}
    static NSString *identifier = @"MyLocation";   
    if ([annotation isKindOfClass:[MyLocation class]]) {
        annotation = (MyLocation*)annotation;
        MyAnnotationView *annotationView = (MyAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[[MyAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier] autorelease];
            
        } else {
            annotationView.annotation = annotation;
            
        }
		NSInteger number = [self.annotationsArray indexOfObject:annotation];
		if (number > 0 || self.searchedForAddress == NO) {
			if (self.searchedForAddress == YES) {
				// We display the searched location on map, so there is one
				// more annotation
	        	[annotationView setNumber:number];
			}
			else {
				// Otherwise, only results annotation will display
	        	[annotationView setNumber:number+1];
			}
	        annotationView.enabled = YES;
	        annotationView.canShowCallout = YES;
	        annotationView.image=[UIImage imageNamed:@"pin.png"];
	        // instantiate a detail-disclosure button and set it to appear on right side of annotation
	        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	        annotationView.rightCalloutAccessoryView = infoButton;
			annotationView.centerOffset = CGPointMake(0, -19);
		} else {
	        annotationView.enabled = YES;
	        annotationView.canShowCallout = YES;
	        annotationView.image=[UIImage imageNamed:@"pin_current.png"];
			annotationView.centerOffset = CGPointMake(0, -18);
		}
        return annotationView;
    }
    
    return nil;    
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views { 
	MyAnnotationView *aV; 
	for (aV in views) {
        // Check if current annotation is inside visible map rect, else go to next one
        MKMapPoint point =  MKMapPointForCoordinate(aV.annotation.coordinate);
        if (!MKMapRectContainsPoint(self.mapView.visibleMapRect, point)) {
            continue;
        }
		if([aV.annotation class] == MKUserLocation.class) {
			continue;
		}

        CGRect endFrame = aV.frame;

        // Move annotation out of view
        aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y - self.view.frame.size.height, aV.frame.size.width, aV.frame.size.height);

        // Animate drop
        [UIView animateWithDuration:0.5 delay:0.1*[aV resultNumber] options:UIViewAnimationCurveLinear animations:^{

            aV.frame = endFrame;

        // Animate squash
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8);

                }completion:^(BOOL finished){
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            aV.transform = CGAffineTransformIdentity;
                        }];
                    }
                }];
            }
        }];

   }
}


#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	// Geolocation is too old (maybe cached)

    NSLog(@"Fired geolocation %d times", timesFired);

	if( abs(howRecent) > 5.0 ) return;
    // Test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;

	timesFired++;

    if (((newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy)
        && (newLocation.horizontalAccuracy > 0.0f)) || timesFired >= 15) {
	    [manager stopUpdatingLocation];
	    self.locationManager.delegate = nil;
	    [self.locationManager stopUpdatingHeading];
	    self.locationManager = nil;
	}

	if (timesFired == 1) {
	    NSLog(@"Current Location is : %f, %f", newLocation.coordinate.longitude, newLocation.coordinate.latitude);
	    self.searchString = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
	    [self populateTableView];
	}

    NSLog(@"Improved Location is : %f, %f", newLocation.coordinate.longitude, newLocation.coordinate.latitude);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusDenied:
        {
            [self goBack];
        }
            break;
        case kCLAuthorizationStatusAuthorized:
        {
            
        }
            break;
            
        default:
            break;
    }
}


- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setResultTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    NSLog(@"Dealloc Called for ResultView");
    
    self.locationManager = nil;
    
    [mapView release];
    [resultTableView release];
	[annotationsArray release];
	[searchString release];
    searchString = nil;
    
    [entries removeAllObjects];
    [entries release];
    entries = nil;

    [super dealloc];
}

#pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [entries count];
	return count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"Cell";
    
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:identifier] autorelease];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
    }
    if ([entries count] > 0) {
        
        AccomodationContainer *container = [entries objectAtIndex:indexPath.row];
        Accomodation *accomodation = [container getAccomodation];
        cell.textLabel.text = [NSString stringWithFormat:@"%d. %@", indexPath.row+1, accomodation.name];
        [cell setCount:[container getCount]];
        
        // Only load cached images; defer new downloads until scrolling ends
        if (!accomodation.image)
        {
            if (self.resultTableView.dragging == NO && self.resultTableView.decelerating == NO)
            {
                if ([container getThumbURL]) {
                    [self startIconDownload:accomodation forIndexPath:indexPath];
                }                
            }
            
            // if a download is deferred or in progress, return a placeholder image
            cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
        }
        else
        {
            cell.imageView.image = accomodation.image;
        }
        
    }
    
   	cell.textLabel.backgroundColor = [UIColor clearColor];
    return cell;
    
}

#pragma mark - UITableViewDelegate Mehtods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self goToAccomodation:indexPath.row];
}

/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.resultTableView) {    // self.tableview
            CGFloat cornerRadius = 5.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 5, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+5, bounds.size.height-lineHeight, bounds.size.width-5, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}
 */

#pragma mark - AccomodationParserDelegate Methods

- (void)accomodationParser:(AccomodationParser *)parser didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError Called");
    [HUD hide:YES afterDelay:kHUDHideInterval];
}

- (void)accomodationParser:(AccomodationParser *)parser didFinishLoadingAccomodations:(NSArray *)accomodations {
    [entries removeAllObjects];
    [entries setArray:accomodations];
    [self drawPinsOnMap];
    [self.resultTableView reloadData];
    [self showTableView];
}

- (void)accomodationParserDidNotFindData:(AccomodationParser *)parser {
    NSLog(@"didNotFindData Called");
    [HUD hide:YES];
    [noResults setHidden:NO];
}



#pragma mark - Public Methods



@end
