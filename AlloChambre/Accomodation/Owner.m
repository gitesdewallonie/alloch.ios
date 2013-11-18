//
//  Owner.m
//  AlloChambre
//

#import "Owner.h"

@implementation Owner

@synthesize webSite, language, fax, name, firstName, title, mobile, email, phone;

#pragma mark - Private Methods



#pragma mark - Class Methods

- (void)dealloc {
    
    self.webSite = nil;
    self.language = nil;
    self.fax = nil;
    self.name = nil;
    self.firstName = nil;
    self.title = nil;
    self.mobile = nil;
    self.email = nil;
    self.phone = nil;
        
    [super dealloc];
}



#pragma mark - Public Methods




@end
