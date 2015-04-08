//
//  CreditsViewController.m
//  AlloChambre
//

#import "CreditsViewController.h"
#import "UIDeviceHardware.h"

@implementation CreditsViewController
@synthesize scrollView;
@synthesize imageView;

#pragma mark - Private Methods

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"Loaded Image : %f, %f", self.imageView.image.size.width, self.imageView.image.size.height);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // this check is for iphone 4 (3.5 inch) only : for other devices,
    // image sizes will be adjusted using image asset catalog
    if ([UIDeviceHardware isDeviceiPhone4]) {
        [self.imageView setImage:[UIImage imageNamed:@"Credits-iPhone3.png"]];
    }

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
    [scrollView release];
    [super dealloc];
}
@end
