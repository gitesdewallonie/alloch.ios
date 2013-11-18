//
//  AccomodationContainer.m
//  AlloChambre
//

#import "AccomodationContainer.h"

@implementation AccomodationContainer

@synthesize accomodationArray = _accomodationArray;

#pragma mark - Private Methods



#pragma mark - Class Methods

- (id)init {
    self = [super init];
    if (self) {
        self.accomodationArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)dealloc {
    
    self.accomodationArray = nil;
    
    [super dealloc];
}



#pragma mark - Public Methods

- (NSInteger)getCount {
    return [self.accomodationArray count];
}

- (void)addAccomodationWithDictionary:(NSDictionary*)dict andSearchLocation:(NSDictionary*)searchDic {
    //NSLog(@"Accomo Dict: %@", dict);
    
    Accomodation *newAccomodation = [[Accomodation alloc] init];
    
    newAccomodation.name = [dict valueForKey:@"name"];
    newAccomodation.type = [dict valueForKey:@"type"];
    newAccomodation.latitude = [dict valueForKey:@"latitude"];
    newAccomodation.longitude = [dict valueForKey:@"longitude"];
    newAccomodation.distribution = [dict valueForKey:@"distribution"];
    newAccomodation.capacityMax = [[dict valueForKey:@"capacity_max"] intValue];
    newAccomodation.capacityMin = [[dict valueForKey:@"capacity_min"] intValue];
    newAccomodation.description = [dict valueForKey:@"description"];
    newAccomodation.price = [dict valueForKey:@"price"];
    newAccomodation.roomNo = [[dict valueForKey:@"room_number"] intValue];
    newAccomodation.onePersonBed = [[dict valueForKey:@"one_person_bed"] intValue];
    newAccomodation.twoPersonBed = [[dict valueForKey:@"two_person_bed"] intValue];
    newAccomodation.additionalBed = [[dict valueForKey:@"additionnal_bed"] intValue];
    newAccomodation.childBed = [[dict valueForKey:@"child_bed"] intValue];
    newAccomodation.smokerAllowed = [[dict valueForKey:@"smokers_allowed"] boolValue];
    newAccomodation.animalAllowed = [[dict valueForKey:@"animal_allowed"] boolValue];
    newAccomodation.thumbURL = [dict valueForKey:@"thumb"];
    
    // Setting up Classification
    NSArray *classfArray = [dict valueForKey:@"classification"];
    if (classfArray) {
        if ([classfArray count] > 0) {
            newAccomodation.classification = [[classfArray objectAtIndex:0] intValue];
        } else{
            newAccomodation.classification = 0;
        }
        //NSLog(@"Class: %d", newAccomodation.classification);
    }
    
    // Setting Up Photos
    NSArray *photosArray = [dict valueForKey:@"photos"];
    if (photosArray) {
        for (int i = 0; i < [photosArray count]; i++) {
            [newAccomodation.photosArray addObject:[photosArray objectAtIndex:i]];
        }
        //NSLog(@"PhotosArray: %@", newAccomodation.photosArray);
    }
    
    // Setting Up Owner
    NSDictionary *ownerDict = [dict valueForKey:@"owner"];
    if (ownerDict) {
        
        newAccomodation.owner.title = [ownerDict valueForKey:@"title"];
        newAccomodation.owner.firstName = [ownerDict valueForKey:@"firstname"];
        newAccomodation.owner.name = [ownerDict valueForKey:@"name"];
        newAccomodation.owner.language = [ownerDict valueForKey:@"language"];
        newAccomodation.owner.phone = [ownerDict valueForKey:@"phone"];
        newAccomodation.owner.fax = [ownerDict valueForKey:@"fax"];
        newAccomodation.owner.mobile = [ownerDict valueForKey:@"mobile"];
        newAccomodation.owner.email = [ownerDict valueForKey:@"email"];
        newAccomodation.owner.webSite = [ownerDict valueForKey:@"website"];
    }
    
    
    // Setting Up Address
    NSDictionary *addressDict = [dict valueForKey:@"address"];
    if (addressDict) {
        newAccomodation.address.town = [addressDict valueForKey:@"town"];
        newAccomodation.address.city = [addressDict valueForKey:@"city"];
        newAccomodation.address.zip = [addressDict valueForKey:@"zip"];
        newAccomodation.address.address = [addressDict valueForKey:@"address"];
    }
    
    
    
    // Setting Up Search Location
    if (searchDic) {
        NSArray *coordsArray = [searchDic valueForKey:@"coordinates"];
        if ([coordsArray count] == 2) {
            //NSLog(@"Longitude:%@", [coordsArray objectAtIndex:0]);
            //NSLog(@"Latitude:%@", [coordsArray objectAtIndex:1]);
            
            newAccomodation.searchLocation.longitude = [coordsArray objectAtIndex:0];
            newAccomodation.searchLocation.latitude = [coordsArray objectAtIndex:1];
        }
        
        newAccomodation.searchLocation.title = [searchDic valueForKey:@"title"];
    }
    
    [self.accomodationArray addObject:newAccomodation];
    [newAccomodation release];
    newAccomodation = nil;
    
}

- (void)displayCount{
    Accomodation *accomod = [self.accomodationArray objectAtIndex:0];
    NSLog(@"Lat: %f - Log: %f", accomod.latitude.doubleValue, accomod.longitude.doubleValue);
}

- (NSString*)getName {
    Accomodation *accomod = [self.accomodationArray objectAtIndex:0];
    return accomod.name;
}

- (NSString*)getThumbURL{
    Accomodation *accomod = [self.accomodationArray objectAtIndex:0];
    return accomod.thumbURL;
}

- (CLLocationCoordinate2D)getCoord {
    Accomodation *accomod = [self.accomodationArray objectAtIndex:0];
    CLLocationCoordinate2D coords = {accomod.longitude.doubleValue, accomod.latitude.doubleValue};
    return coords;
}

- (Accomodation*)getAccomodation {
    Accomodation *accomod = [self.accomodationArray objectAtIndex:0];
    return accomod;
}


@end
