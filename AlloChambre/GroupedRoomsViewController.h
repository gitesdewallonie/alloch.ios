//
//  GroupedRoomsViewController.h
//  AlloChambre
//

#import <UIKit/UIKit.h>
#import "Accomodation.h"
#import "IconDownloader.h"

@interface GroupedRoomsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, IconDownloaderDelegate> {

    NSMutableArray *entries;
	UILabel *_labelTitle;
}

@property (nonatomic, retain) NSString *name;
@property (retain, nonatomic) IBOutlet UITableView *groupedTableView;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle; 
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andRooms:(NSArray*)rooms andName:(NSString*)roomName;

@end
