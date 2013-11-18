//
//  Address.m
//  AlloChambre
//

#import "Address.h"

@implementation Address

@synthesize town, city, zip, address;


#pragma mark - Private Methods



#pragma mark - Class Methods

- (void)dealloc {
    
    self.town = nil;
    self.city = nil;
    self.zip = nil;
    self.address = nil;
    
    [super dealloc];
}


#pragma mark - Public Methods



@end
