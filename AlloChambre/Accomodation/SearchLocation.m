//
//  SearchLocation.m
//  AlloChambre
//

#import "SearchLocation.h"

@implementation SearchLocation

@synthesize latitude, longitude;
@synthesize title;


#pragma mark - Private Methods



#pragma mark - Class Methods

- (void)dealloc {
    
    self.latitude = nil;
    self.longitude = nil;
    self.title = nil;
    
    [super dealloc];
}


#pragma mark - Public Methods

- (CLLocationCoordinate2D)getSearchLocationCoords {
    CLLocationCoordinate2D coords = {self.longitude.doubleValue, self.latitude.doubleValue};
    return coords;
}


@end
