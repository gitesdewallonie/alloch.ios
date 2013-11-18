//
//  RouteViewController.m
//  AlloChambre
//

#import "RouteViewController.h"

@implementation RouteViewController

@synthesize webView;
@synthesize directionURL;

#pragma mark - Private Methods

#pragma mark - Class Methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andURL:(NSString*)mapURL
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.directionURL = mapURL;
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
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"RouteViewTitle", nil);

	// [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.directionURL]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.directionURL]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[directionURL release];
	[webView release];
    directionURL = nil;
    webView = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //NSLog(@"URL:%@", self.webView.request.URL);
    
}

#pragma mark - Public Methods

@end
