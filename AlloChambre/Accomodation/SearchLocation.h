//
//  SearchLocation.h
//  AlloChambre
//

#import <Foundation/Foundation.h>
#import <MapKit/Mapkit.h>


@interface SearchLocation : NSObject {
    
}

@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@property (nonatomic, retain) NSString *title;

- (CLLocationCoordinate2D)getSearchLocationCoords;

@end
