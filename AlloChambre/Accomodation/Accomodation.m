//
//  Accomodation.m
//  AlloChambre
//

#import "Accomodation.h"

@implementation Accomodation

@synthesize twoPersonBed , name, classification, childBed, price, capacityMax, capacityMin, roomNo, thumbURL;

@synthesize latitude, longitude;

@synthesize animalAllowed, smokerAllowed;
@synthesize owner, address;

@synthesize distribution;
@synthesize photosArray;

@synthesize type, additionalBed, onePersonBed, description;

@synthesize image;

@synthesize searchLocation;

#pragma mark - Private Methods



#pragma mark - Class Methods

- (id)init {
    self = [super init];
    if (self) {
        self.photosArray = [NSMutableArray arrayWithCapacity:5];
        self.owner = [[[Owner alloc] init] autorelease];
        self.address = [[[Address alloc] init] autorelease];
        self.searchLocation = [[[SearchLocation alloc] init] autorelease];
    }
    return self;
}

- (void)dealloc {
    
    self.photosArray = nil;
    self.owner = nil;
    self.address = nil;
    self.image = nil;
    self.searchLocation = nil;
    
    [super dealloc];
}



#pragma mark - Public Methods




@end
