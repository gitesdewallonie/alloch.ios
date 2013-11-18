//
//  AccomodationContainer.h
//  AlloChambre
//

#import <Foundation/Foundation.h>
#import "Accomodation.h"
#import <MapKit/Mapkit.h>

@interface AccomodationContainer : NSObject {
    NSMutableArray *_accomodationArray;
}

@property (nonatomic, retain) NSMutableArray *accomodationArray;

- (NSInteger)getCount;
- (NSString*)getName;
- (void)addAccomodationWithDictionary:(NSDictionary*)dict andSearchLocation:(NSDictionary*)searchDic;
- (void)displayCount;
- (NSString*)getThumbURL;
- (CLLocationCoordinate2D)getCoord;
- (Accomodation*)getAccomodation;

@end
