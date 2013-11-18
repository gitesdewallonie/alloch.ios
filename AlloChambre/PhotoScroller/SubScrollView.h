//
//  SubScrollView.h
//  LazyLoading
//

#import <UIKit/UIKit.h>

@interface SubScrollView : UIScrollView <UIScrollViewDelegate> {
    
    NSString *_imageURLString;
    BOOL isDataLoaded;
    BOOL connectionStarted;
    UIImageView *_imageView;
    
    UIActivityIndicatorView *_activityView;
    
    NSURLConnection *_urlConnection;
    NSMutableData *_appData;
    BOOL zoomed;
    
}

@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, readwrite) BOOL isDataLoaded;
@property (nonatomic, retain) NSURLConnection *urlConnection;
@property (nonatomic, retain) NSMutableData *appData;



- (void)startDownloadingImages;
- (void)cancelDownloading;

@end
