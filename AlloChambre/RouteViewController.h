//
//  RouteViewController.h
//  AlloChambre
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>


@interface RouteViewController : UIViewController <UIWebViewDelegate>


@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, retain) NSString *directionURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andURL:(NSString*)mapURL;

@end
