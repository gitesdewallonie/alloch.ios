//
//  SubScrollView.m
//  LazyLoading
//

#import "SubScrollView.h"

@interface SubScrollView (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation SubScrollView

@synthesize imageURLString = _imageURLString;
@synthesize isDataLoaded;
@synthesize urlConnection, appData;




#pragma mark - Private Methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the Self's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width  = [self frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // double tap zooms in
	
	if ([self zoomScale] == 1.0 ) {
		
        float zoom_step = 2.0;
        
		float newScale = [self zoomScale] * zoom_step;
		CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gestureRecognizer locationInView:gestureRecognizer.view]];
		[self zoomToRect:zoomRect animated:YES];
		zoomed = TRUE;
		//NSLog(@"ZoomScale %.2f", [self zoomScale]);
		
	} else {
		[self setZoomScale:1.0 animated:YES];
		zoomed = FALSE;		
	}
	
}



#pragma mark - Class Methods

-(void)layoutSubviews {
    
    //UIInterfaceOrientation orientation = [self 
    //NSLog(@"SubView==== W:%f -- H:%f", self.frame.size.width, self.frame.size.height);
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        // Initialization UIScrollView Properties.        
        [self setBackgroundColor:[UIColor blackColor]];
		[self setDelegate:self];
		[self setClipsToBounds:YES];
		[self setBouncesZoom:NO];
		//[self setBounces:NO];
		self.clipsToBounds = YES;
		[self setCanCancelContentTouches:YES];
		[self setMinimumZoomScale:1.0];
		
		[self setMaximumZoomScale:4.0];
		      
		
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
        
        // Setting Tap Gesture to Handle Double Tap
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
		[doubleTap setNumberOfTapsRequired:2];
		[self addGestureRecognizer:doubleTap];		
		[doubleTap release];
        doubleTap = nil;
        
        
        
        //_imageView = [[uiimagevi
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
        //[_imageView setBackgroundColor:[UIColor blueColor]];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_imageView];
        
        _activityView = [[UIActivityIndicatorView alloc] 
                         initWithFrame:CGRectMake(frame.size.width/2-15, frame.size.height/2-15, 30, 30)];
        //[_activityView setCenter:self.center];
        [_activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [_activityView startAnimating];
        [self addSubview:_activityView];
        
        
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

-(void)dealloc{
    
    //NSLog(@"Dealloc Called For SubscrollView : %d", self.tag);
    
    self.imageURLString = nil;
    
    [_imageView release];
    _imageView = nil;
    
    [_activityView release];
    _activityView = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

// -------------------------------------------------------------------------------
//	connection:didReceiveResponse:response
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.appData = [NSMutableData data];    // start off with new data
    connectionStarted = TRUE;
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.appData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.urlConnection = nil;
    self.appData = nil;
    connectionStarted = FALSE;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.appData];
    [_imageView setImage:image];
       
    [image release];
    image = nil;
    
    [_activityView stopAnimating];
    // Release the connection now that it's finished
    self.urlConnection = nil;
    self.appData = nil;
    self.isDataLoaded = YES;
        
}

#pragma mark - UIScrollViewDelegate Methods

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	
	return _imageView;
}

#pragma mark - Public Methods

- (void)startDownloadingImages{
        
    if (!connectionStarted) {
        //NSLog(@"Image URL String: %@", self.imageURLString);
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL 
                                                                 URLWithString:self.imageURLString]];
        
        self.urlConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
        
        NSAssert(self.urlConnection != nil, @"Failure to create URL connection.");
        
        // show in the status bar that network activity is starting
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        connectionStarted = TRUE;
    }
    
}

-(void)cancelDownloading{
    if (self.urlConnection) {
        [self.urlConnection cancel];
        self.urlConnection = nil;
    }
    connectionStarted = FALSE;
}

@end
