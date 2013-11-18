//
//  CreditsViewController.m
//  AlloChambre
//

#import "CreditsViewController.h"

@implementation CreditsViewController
@synthesize scrollView;

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
    
    // ====================================================================================
    // Setting Back Button
    // UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
    //                                                                style:UIBarButtonItemStyleBordered
    //                                                               target:self 
    //                                                               action:@selector(goBack)];
    // [self.navigationItem setLeftBarButtonItem:backButton];
    // [backButton release];
    // backButton = nil;
    // ====================================================================================
    
    // Do any additional setup after loading the view from its nib.
    [self.scrollView setContentSize:CGSizeMake(320, 480)];
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
