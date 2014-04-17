//
//  CreditsViewController.m
//  AlloChambre
//

#import "CreditsViewController.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([UIDeviceHardware IsDeviceHas4InchDisplay]) {
        NSLog(@"Device has 4 inch display");
        imageView.image = [UIImage imageNamed:@"Credits@4inch.png"];
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
