//
//  MainViewController.h
//  AlloChambre
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITextFieldDelegate> {
    
    IBOutlet UITextField *searchTF;
    IBOutlet UIImageView *loupe;
    IBOutlet UIView *contentView;
    IBOutlet UIScrollView *scrollView;;
    IBOutlet UILabel *CrWallonie;
    IBOutlet UILabel *CrEurope;
    IBOutlet UILabel *CrWallonieBruxelles;
}
@property (retain, nonatomic) IBOutlet UIButton *btnGeolocateMe;
@property (retain, nonatomic) IBOutlet UIButton *btnLookup;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnCredits;
@property (retain, nonatomic) IBOutlet UITextField *searchTF;
@property (retain, nonatomic) IBOutlet UIImageView *loupe;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)openCredits:(id)sender;
- (IBAction)geolocateMe:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)inputText:(id)sender;
- (IBAction)openWallonie:(id)sender;
- (IBAction)openEurope:(id)sender;
- (IBAction)openWallonieBruxelles:(id)sender;

@end
