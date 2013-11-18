//
//  AccomodationParser.h
//  AlloChambre
//

#import <Foundation/Foundation.h>
#import "AccomodationContainer.h"

@protocol AccomodationParserDelegate;


@interface AccomodationParser : NSObject <NSURLConnectionDelegate> {
    
    NSURLConnection *_conn;
    NSMutableArray *_containerArray;
    
    id<AccomodationParserDelegate> _delegate;
    
}

@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSMutableArray *containerArray;
@property (nonatomic, retain) id<AccomodationParserDelegate> delegate;

- (void)requestAccomodationForSearchString:(NSString*)searchString;
- (void)cancelParsing;

@end

#pragma mark - AccomodationParserDelegate Declaration

@protocol AccomodationParserDelegate <NSObject>

@optional

- (void)accomodationParser:(AccomodationParser*)parser didFinishLoadingAccomodations:(NSArray*)accomodations;
- (void)accomodationParserDidNotFindData:(AccomodationParser*)parser;
- (void)accomodationParser:(AccomodationParser *)parser didFailWithError:(NSError*)error;

@end
