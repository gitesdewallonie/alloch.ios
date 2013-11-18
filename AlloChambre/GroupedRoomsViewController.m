//
//  GroupedRoomsViewController.m
//  AlloChambre
//

#import "GroupedRoomsViewController.h"
#import "TableViewCell.h"
#import "DetailViewController.h"


@implementation GroupedRoomsViewController
@synthesize name;
@synthesize groupedTableView;
@synthesize imageDownloadsInProgress;
@synthesize labelTitle = _labelTitle; 

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
    
    [self removeDelegateForIconDownloader];    
    [self.navigationController popViewControllerAnimated:YES];
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
        NSArray *visiblePaths = [self.groupedTableView indexPathsForVisibleRows];
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

#pragma mark - Class Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRooms:(NSArray*)rooms andName:(NSString*)roomName;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        entries = [[NSMutableArray alloc] initWithArray:rooms];
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    }
	self.name = roomName;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // ====================================================================================
    // Setting Back Button
    // UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
    //                                                                style:UIBarButtonItemStyleBordered
    //                                                               target:self 
    //                                                               action:@selector(goBack)];
    // [self.navigationItem setLeftBarButtonItem:backButton];
    // [backButton release];
    // backButton = nil;
    // ====================================================================================

	// Create image from the desired pattern
	// UIImage *pattern = [UIImage imageNamed:@"background.gif"];
	// Set the image as a background pattern
	// [[self view] setBackgroundColor:[UIColor colorWithPatternImage:pattern]];

    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    self.groupedTableView.backgroundColor = [UIColor clearColor];
    
    self.title = NSLocalizedString(@"GroupedRoomViewTitle", nil);

	[self.labelTitle setText:[NSString stringWithFormat:@"%@", self.name]]; 

	// Resize label to its content as there is no top vertical alignment 
	CGSize maximumSize = CGSizeMake(280, 9999); 
	CGSize stringSize = [self.name sizeWithFont:self.labelTitle.font  
	                               constrainedToSize:maximumSize  
	                               lineBreakMode:self.labelTitle.lineBreakMode]; 
	CGRect nameFrame = CGRectMake(20, 20, 280, stringSize.height); 
	self.labelTitle.frame = nameFrame; 
}

- (void)viewDidUnload
{
    [self setGroupedTableView:nil];
    [super viewDidUnload];
	_labelTitle = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    self.imageDownloadsInProgress = nil;
    [entries release];
    entries = nil;
    
    [groupedTableView release];
	[name release];
	[_labelTitle release];
    [super dealloc];
}

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
        Accomodation *accomodation = [entries objectAtIndex:indexPath.row];
        cell.textLabel.text = accomodation.name;
        
        // Only load cached images; defer new downloads until scrolling ends
        if (!accomodation.image)
        {
            if (self.groupedTableView.dragging == NO && self.groupedTableView.decelerating == NO)
            {
                if (accomodation.thumbURL) {
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
    
    Accomodation *accomodation = [entries objectAtIndex:indexPath.row];
    DetailViewController *dView = [[DetailViewController alloc] initWithNibName:@"DetailViewController"
                                                                         bundle:nil
                                                                andAccomodation:accomodation];
    [self.navigationController pushViewController:dView animated:YES];
    [dView release];
    dView = nil;
}

#pragma mark - IconDownloaderDelegate Methods

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell = [self.groupedTableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imageView.image = iconDownloader.appRecord.image;
    }
}

@end
