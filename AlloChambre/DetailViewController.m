//
//  DetailViewController.m
//  AlloChambre
//

#import "DetailViewController.h"
#import "Constants.h"
#import "RouteViewController.h"

@implementation DetailViewController

@synthesize currentAccomodation;
@synthesize scrollView = _scrollView;
@synthesize labelMinMax = _labelMinMax;
@synthesize labelOwnerName = _labelOwnerName;
@synthesize labelAddress = _labelAddress;
@synthesize labelZipAndCity = _labelZipAndCiy;
@synthesize labelDescription = _labelDescription;
@synthesize labelPrice;
@synthesize labelNumberOfBeds1 = _labelNumberOfBeds1;
@synthesize labelNumberOfBeds2 = _labelNumberOfBeds2;
@synthesize imageViewBeds1 = _imageViewBeds1;
@synthesize imageViewBeds2 = _imageViewBeds2;
@synthesize coq = _coq;
@synthesize coq_reversed = _coq_reversed;


#pragma mark - Private Methods

- (void)setUPNumberOfBeds {
    
    if (self.currentAccomodation.twoPersonBed > 0) {
        [self.imageViewBeds1 setImage:[UIImage imageNamed:@"lit.png"]];
        [self.labelNumberOfBeds1 setText:[NSString stringWithFormat:@"%ld", (long)self.currentAccomodation.twoPersonBed]];
        [self.imageViewBeds1 setHidden:NO];
        [self.labelNumberOfBeds1 setHidden:NO];
		if (self.currentAccomodation.onePersonBed > 0) {
	        [self.imageViewBeds2 setImage:[UIImage imageNamed:@"lit1p.png"]];
	        [self.labelNumberOfBeds2 setText:[NSString stringWithFormat:@"%ld", (long)self.currentAccomodation.onePersonBed]];
	        [self.imageViewBeds2 setHidden:NO];
	        [self.labelNumberOfBeds2 setHidden:NO];
	    }
    }
	else if (self.currentAccomodation.onePersonBed > 0) {
        [self.imageViewBeds1 setImage:[UIImage imageNamed:@"lit1p.png"]];
        [self.labelNumberOfBeds1 setText:[NSString stringWithFormat:@"%ld", (long)self.currentAccomodation.onePersonBed]];
        [self.imageViewBeds1 setHidden:NO];
        [self.labelNumberOfBeds1 setHidden:NO];
    }
    
}

- (void)setupLabels {
    [self.labelMinMax setText:[NSString stringWithFormat:@"%ld/%ld"
                               , (long)self.currentAccomodation.capacityMin
                               , (long)self.currentAccomodation.capacityMax ]];
    [self.labelOwnerName setText:[NSString stringWithFormat:@"%@ %@"
                                   , self.currentAccomodation.owner.title
                                   , self.currentAccomodation.owner.name]];
    [self.labelAddress setText:self.currentAccomodation.address.address];
    [self.labelZipAndCity setText:[NSString stringWithFormat:@"%@, %@"
                                   , self.currentAccomodation.address.zip
                                   , self.currentAccomodation.address.city]];
    [self.labelPrice setText:[NSString stringWithFormat:@"%@ €", 
                              [self.currentAccomodation.price stringByReplacingOccurrencesOfString:@".00" withString:@""]]];
    
    [self.labelDescription setText:self.currentAccomodation.description];

	self.labelDescription.numberOfLines = 0;
	[self.labelDescription sizeToFit];
	}


#pragma mark - Class Methods


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andAccomodation:(Accomodation*)accomodation
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentAccomodation = accomodation;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)addPhotoScroller {
    _photoScroller = [[MainScrollView alloc] initWithFrame:self.photoView.frame
                                            andImagesArray:self.currentAccomodation.photosArray];
    [self.photoView addSubview:_photoScroller];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // [self.view setBackgroundColor:kDetailBGColor];
//    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    self.title = NSLocalizedString(@"DetailViewTitle", nil);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addPhotoScroller];
    });
    
    [self setupLabels];
    [self setUPNumberOfBeds];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
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
    
    //NSLog(@"DetailView Dealloc Called");
    self.labelOwnerName = nil;
    self.labelAddress = nil;
    self.labelZipAndCity = nil;
    self.labelPrice = nil;
    self.labelAddress = nil;
    self.labelDescription = nil;
    self.labelNumberOfBeds1 = nil;
    self.labelNumberOfBeds2 = nil;
    self.imageViewBeds1 = nil;
    self.imageViewBeds2 = nil;
    self.coq = nil;
    self.coq_reversed = nil;

	[currentAccomodation release];

    [_photoScroller release];
    _photoScroller = nil;

    [_scrollView release];

    [super dealloc];
}

#pragma mark - UIAlertViewDelegate Methods
- (void)call {
    NSMutableString *phoneStr = [[NSMutableString alloc] initWithFormat:@"tel:%@",self.currentAccomodation.owner.phone];
    [phoneStr replaceOccurrencesOfString:@" " withString:@"-"
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange(0, [phoneStr length])];
    //NSLog(@"PhoneStr: %@", phoneStr);
    NSURL *phoneURL = [[NSURL alloc] initWithString:phoneStr];
    [[UIApplication sharedApplication] openURL:phoneURL];
    [phoneURL release];
    phoneURL = nil;
    [phoneStr release];
    phoneStr = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
        {
            // Do something in case of cancel
        }
            break;
        case 1:
        {
            [self call];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Public Methods

- (IBAction)makeCall:(id)sender {
    
    if ([self.currentAccomodation.owner.phone length] > 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CCATitle", nil)
                                                        message:self.currentAccomodation.owner.phone
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"CCADismissButton", nil)
                                              otherButtonTitles:NSLocalizedString(@"CCAOkButtonTitle", nil)
                                                                , nil];
        [alert show];
        [alert release];
        alert = nil;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NPNTitle", nil)
                                                        message:NSLocalizedString(@"NPNessage", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"NPNDismissButton", nil)
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        alert = nil;
    }
}

- (IBAction)drawRoute:(id)sender {
    /*
    NSLog(@"LN:%f, LT:%f - Title:%@", [self.currentAccomodation.searchLocation.longitude doubleValue],
          [self.currentAccomodation.searchLocation.latitude doubleValue],
          self.currentAccomodation.searchLocation.title);
    */
    NSString *start = [NSString stringWithFormat:@"%f,%f", self.currentAccomodation.searchLocation.longitude.doubleValue,
                       self.currentAccomodation.searchLocation.latitude.doubleValue];
    NSString *destination = [NSString stringWithFormat:@"%f,%f", self.currentAccomodation.longitude.doubleValue,
                       self.currentAccomodation.latitude.doubleValue];
    NSString *directionURL = [NSString stringWithFormat:kDirectionURL, start, destination];
    
    
    
    
    RouteViewController *rView = [[RouteViewController alloc] initWithNibName:@"RouteViewController"
                                                                       bundle:nil
                                                                andURL:directionURL];
    [self.navigationController pushViewController:rView animated:YES];
    [rView release];
    rView = nil;
    
    
}



@end
