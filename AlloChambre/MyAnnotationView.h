//
//  MyAnnotationView.h
//  AlloChambre
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>

@interface MyAnnotationView : MKAnnotationView {
    UILabel *_labelNumber;
}

@property (readwrite, assign) NSInteger resultNumber;
@property (nonatomic, retain) UILabel *labelNumber;

- (void)setNumber:(NSInteger)number;

@end
