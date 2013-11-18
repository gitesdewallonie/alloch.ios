//
//  Accomodation.h
//  AlloChambre
//

#import <Foundation/Foundation.h>
#import "Owner.h"
#import "Address.h"
#import "SearchLocation.h"

@interface Accomodation : NSObject

@property (readwrite, assign) NSInteger twoPersonBed;
@property (readwrite, assign) NSInteger onePersonBed;
@property (nonatomic, retain) NSString *name;
@property (readwrite, assign) NSInteger classification;
@property (readwrite, assign) NSInteger childBed;
@property (nonatomic, retain) NSString *price;
@property (readwrite, assign) NSInteger capacityMax;
@property (readwrite, assign) NSInteger capacityMin;
@property (readwrite, assign) NSInteger roomNo;
@property (nonatomic, retain) NSString *thumbURL;

@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@property (readwrite, assign) BOOL animalAllowed;
@property (readwrite, assign) BOOL smokerAllowed;

@property (nonatomic, retain) Owner *owner;
@property (nonatomic, retain) Address *address;


@property (nonatomic, retain) NSString *distribution;

@property (nonatomic, retain) NSMutableArray *photosArray;

@property (nonatomic, retain) NSString *type;
@property (readwrite, assign) NSInteger additionalBed;
@property (nonatomic, retain) NSString *description;

@property (nonatomic, retain) UIImage *image;

@property (nonatomic, retain) SearchLocation *searchLocation;

@end
