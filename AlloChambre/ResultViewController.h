//
//  ResultViewController.h
//  AlloChambre
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import "AccomodationParser.h"
#import "IconDownloader.h"
#import "MyLocation.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#define METERS_PER_MILE 1609.344

@interface ResultViewController : UIViewController <AccomodationParserDelegate, IconDownloaderDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate> {
    MBProgressHUD *HUD;
    NSMutableArray *entries;
    AccomodationParser *_parser;
    IBOutlet UITextField *noResults;
}

@property (readwrite, assign) NSInteger timesFired;
@property (nonatomic, readwrite) BOOL searchedForAddress;
@property (nonatomic, retain) NSString *searchString;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *resultTableView;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *annotationsArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andSearchString:(NSString*)string;

@end
