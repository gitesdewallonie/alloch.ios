//
//  DetailViewController.h
//  AlloChambre
//

#import <UIKit/UIKit.h>
#import "MainScrollView.h"
#import "Accomodation.h"
#import <MapKit/Mapkit.h>

@interface DetailViewController : UIViewController <UIAlertViewDelegate> {
    MainScrollView *_photoScroller;
    UILabel *_labelMinMax;
    UILabel *_labelOwnerName;
    UILabel *_labelAddress;
    UILabel *_labelZipAndCiy;
    UILabel *_labelDescription;
    
    UILabel *_labelNumberOfBeds1;
    UIImageView *_imageViewBeds1;
    UILabel *_labelNumberOfBeds2;
    UIImageView *_imageViewBeds2;

    UIImageView *_coq;
    UIImageView *_coq_reversed;
}

@property (nonatomic, retain) Accomodation *currentAccomodation;
@property (nonatomic, retain) IBOutlet UIView *photoView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *labelMinMax;
@property (nonatomic, retain) IBOutlet UILabel *labelOwnerName;
@property (nonatomic, retain) IBOutlet UILabel *labelAddress;
@property (nonatomic, retain) IBOutlet UILabel *labelZipAndCity;
@property (nonatomic, retain) IBOutlet UILabel *labelDescription;
@property (nonatomic, retain) IBOutlet UILabel *labelPrice;
@property (nonatomic, retain) IBOutlet UILabel *labelNumberOfBeds1;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewBeds1;
@property (nonatomic, retain) IBOutlet UILabel *labelNumberOfBeds2;
@property (nonatomic, retain) IBOutlet UIImageView *imageViewBeds2;
@property (nonatomic, retain) IBOutlet UIImageView *coq;
@property (nonatomic, retain) IBOutlet UIImageView *coq_reversed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andAccomodation:(Accomodation*)accomodation;

- (IBAction)makeCall:(id)sender;
- (IBAction)drawRoute:(id)sender;


@end
