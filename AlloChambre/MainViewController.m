//
//  MainViewController.m
//  AlloChambre
//

#import "MainViewController.h"
#import "CreditsViewController.h"
#import "Constants.h"
#import "ResultViewController.h"

@implementation MainViewController
@synthesize btnGeolocateMe;
@synthesize btnLookup;
@synthesize btnCredits;
@synthesize loupe;
@synthesize contentView;
@synthesize scrollView;
@synthesize searchTF;


#pragma mark reachability

- (BOOL)isNetworkReachableViaWWAN
{
	return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN ||
            [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi);	
}

- (void)registerForNetworkReachabilityNotifications
{
	[[Reachability reachabilityForInternetConnection] startNotifier];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
}


- (void)unsubscribeFromNetworkReachabilityNotifications
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}



- (void)reachabilityChanged:(NSNotification *)note
{
	//BOOL isAvailable = [self isNetworkReachableViaWWAN];    
}

#pragma mark - Private Methods

- (void)showAlertWithTitle:(NSString*)title message:(NSString*)message cancelButton:(NSString*)cancel{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    alert = nil;
}


- (BOOL)validateTextField{
    
    if ([searchTF.text length] > 0) {
        return TRUE;
    }
    
    return FALSE;
    
}

- (void)doSearchForString:(NSString*)searchString{
    
    if ([self isNetworkReachableViaWWAN]) {
        if (searchString) {
            if ([self validateTextField]) {
                
                // Creating Instance of ResultView with the String entered in SearchBox
                NSString *nibName = @"ResultViewController";
                if ([UIDeviceHardware IsDeviceHas4InchDisplay]) {
                    nibName = @"ResultViewController_iPhone5";
                }
                ResultViewController *resultView = [[ResultViewController alloc] 
                                                    initWithNibName:nibName//@"ResultViewController"
                                                    bundle:nil andSearchString:searchTF.text];
                
                
				if ([searchTF isFirstResponder]) {
					[searchTF resignFirstResponder];
				}
    
                // Pushing ResultView on the Stack
                [self.navigationController pushViewController:resultView animated:YES];
                [resultView release];
                resultView = nil;
                
            } else {
                
				[searchTF becomeFirstResponder];
                
                // Displaying Alert that user must input sometext in the TextField
                [self showAlertWithTitle:NSLocalizedString(@"VATitle", nil) 
                                 message:NSLocalizedString(@"VAMessage", nil) 
                            cancelButton:NSLocalizedString(@"VADismissButton", nil)];
            }
        } else {
            
            // Creating Instance of ResultView with the String entered in SearchBox
            NSString *nibName = @"ResultViewController";
            if ([UIDeviceHardware IsDeviceHas4InchDisplay]) {
                nibName = @"ResultViewController_iPhone5";
            }
            ResultViewController *resultView = [[ResultViewController alloc] 
                                                initWithNibName:nibName//@"ResultViewController"
                                                bundle:nil andSearchString:nil];        
            
			if ([searchTF isFirstResponder]) {
				[searchTF resignFirstResponder];
			}

            // Pushing ResultView on the Stack
            [self.navigationController pushViewController:resultView animated:YES];
            [resultView release];
            resultView = nil;
        }
    } else {
        // Display Connection Error Alert
        [self showAlertWithTitle:NSLocalizedString(@"CETitle", nil) 
                         message:NSLocalizedString(@"CEMessage", nil) 
                    cancelButton:NSLocalizedString(@"CEDismissButton", nil)];
    }
    
    
    
       
}


#pragma mark - Class Methods

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

#pragma mark - View lifecycle

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
    	if ([searchTF isFirstResponder]) {
			[searchTF resignFirstResponder];
		}
	    if ([searchTF.text length] > 0) {
			[self.loupe setHidden:YES];
	    }
		else {
			[self.loupe setHidden:NO];
		}
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.contentView];
    ((UIScrollView *)self.view).contentSize = self.contentView.frame.size;

    [self registerForNetworkReachabilityNotifications];

    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"HomeButtonTitle",nil) style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    
	// Create image from the desired pattern
	// UIImage *pattern = [UIImage imageNamed:@"background.gif"];
	// Set the image as a background pattern
	// [[self view] setBackgroundColor:[UIColor colorWithPatternImage:pattern]];

    // [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"MainMenuTitle", nil);
    [self.btnGeolocateMe setTitle:NSLocalizedString(@"GeoLocate Me", nil) forState:UIControlStateNormal];
    [self.btnLookup setTitle:NSLocalizedString(@"Lookup", nil) forState:UIControlStateNormal];

	searchTF.placeholder = NSLocalizedString(@"Address", nil);	

    [self.btnCredits setTitle:NSLocalizedString(@"Credits", nil)];
    if ([searchTF.text length] > 0) {
		[self.loupe setHidden:YES];
    }
	else {
		[self.loupe setHidden:NO];
	}
	if ([searchTF isFirstResponder]) {
		[searchTF resignFirstResponder];
	}

	if (! ([CLLocationManager locationServicesEnabled])
		|| ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
			self.btnGeolocateMe.alpha = 0.4f;
	}
	else {
		self.btnGeolocateMe.alpha = 1.0f;
	}

    CrWallonie.text = NSLocalizedString(@"CrWallonie", nil);;
    CrEurope.text = NSLocalizedString(@"CrEurope", nil);;
    CrWallonieBruxelles.text = NSLocalizedString(@"CrWallonieBruxelles", nil);;
}

- (void)viewWillAppear:(BOOL)animated
{
	[self restoreViewPosition];
	if (! ([CLLocationManager locationServicesEnabled])
		|| ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
			self.btnGeolocateMe.alpha = 0.4f;
	}
	else {
		self.btnGeolocateMe.alpha = 1.0f;
	}
	if ([searchTF isFirstResponder]) {
		[searchTF resignFirstResponder];
	}
    if ([searchTF.text length] > 0) {
		[self.loupe setHidden:YES];
    }
	else {
		[self.loupe setHidden:NO];
	}
}

- (void)viewDidUnload
{
    [searchTF release];
    searchTF = nil;
    [self setBtnGeolocateMe:nil];
    [self setBtnLookup:nil];
    [self setBtnCredits:nil];
    [loupe release];
    loupe = nil;
    self.contentView = nil;
    self.scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [self unsubscribeFromNetworkReachabilityNotifications];
}

- (void)dealloc {
    
    [searchTF release];
    [loupe release];
    [btnGeolocateMe release];
    [btnLookup release];
    [btnCredits release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextFieldDelegate Methods

- (void) restoreViewPosition
{
    const float movementDuration = 0.25f; // tweak as needed
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: movementDuration];
	self.scrollView.contentOffset = CGPointZero;
    [UIView commitAnimations];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 175; // tweak as needed
    const float movementDuration = 0.25f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if ([searchTF isFirstResponder]) {
		[searchTF resignFirstResponder];
	}
    [self doSearchForString:searchTF.text];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[self restoreViewPosition];
    [self animateTextField:searchTF up:YES];
	[self.loupe setHidden:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self animateTextField:searchTF up:NO];
	[self.loupe setHidden:NO];
}


#pragma mark - Public Methods

- (IBAction)openCredits:(id)sender {
    CreditsViewController *cView = [[CreditsViewController alloc] initWithNibName:@"CreditsViewController"
                                                                           bundle:nil];
    cView.view.frame=CGRectMake(cView.view.frame.origin.x, cView.view.frame.origin.y, cView.view.frame.size.width, cView.view.frame.size.height);
    [self.navigationController pushViewController:cView animated:YES];
    [cView release];
    cView = nil;
}

- (IBAction)geolocateMe:(id)sender {
	if (! ([CLLocationManager locationServicesEnabled])
		|| ( [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)) {
		// Displaying Alert that user must allow / enable geolocation
		[self showAlertWithTitle:NSLocalizedString(@"GETitle", nil) 
		                 message:NSLocalizedString(@"GEMessage", nil) 
		            cancelButton:NSLocalizedString(@"GEDismissButton", nil)];
	}
	else {
    	[self doSearchForString:nil];
	}
}

- (IBAction)search:(id)sender {
	[self.loupe setHidden:YES];
    [self doSearchForString:searchTF.text];
}

- (IBAction)inputText:(id)sender {
	[searchTF becomeFirstResponder];
}

- (IBAction)openWallonie:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tourismewallonie.be"]];
}

- (IBAction)openEurope:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://ec.europa.eu/agriculture/rurdev/index_fr.htm"]];
}

- (IBAction)openWallonieBruxelles:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.wallonietourisme.be"]];
}


@end
