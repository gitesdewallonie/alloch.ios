//
//  AccomodationParser.m
//  AlloChambre
//

#import "AccomodationParser.h"
#import "Constants.h"
#import "SBJson.h"

@implementation AccomodationParser

@synthesize webData;
@synthesize containerArray;
@synthesize delegate = _delegate;

#pragma mark - Private Methods



#pragma mark - Class Methods

- (id)init {
    self = [super init];
    if (self) {
        self.containerArray = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
    self.webData = nil;
    self.containerArray = nil;
    
    [super dealloc];
}

#pragma mark - NSURLConnectionDelegate Methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.delegate) {
        [self.delegate accomodationParser:self didFailWithError:error];
    }
    _conn = nil;
    self.webData = nil;
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.webData setLength: 0];
}

-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection {
    
    [self.containerArray removeAllObjects];
    
    NSString *htmlData=[[NSString alloc] initWithData:self.webData encoding:NSUTF8StringEncoding];
    //NSLog(@"Data: %@", htmlData);
        
    NSDictionary *dict = [htmlData JSONValue];
    //NSLog(@"Dictionary: %@", dict);
    NSArray *mainArray = [dict valueForKey:@"results"];
    if (mainArray) {
        
        NSDictionary *searchDict = [dict valueForKey:@"search_location"];
        //NSLog(@"SearchDic: %@", searchDict);
        
        for (int i = 0 ; i < [mainArray count]; i++) {
            if ([[mainArray objectAtIndex:i] isKindOfClass:[NSArray class]]) {
                // NSLog(@"Array Found");
                NSArray *subArray = [mainArray objectAtIndex:i];
                AccomodationContainer *container = [[AccomodationContainer alloc] init];
                
                for (int i = 0; i < [subArray count]; i++) {
                    [container addAccomodationWithDictionary:[subArray objectAtIndex:i] 
                                           andSearchLocation:searchDict];
                }
                
                [self.containerArray addObject:container];
                [container release];
                container = nil;
                
            } else if ([[mainArray objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                //NSLog(@"Dictionary Found");
                
                AccomodationContainer *container = [[AccomodationContainer alloc] init];
                [container addAccomodationWithDictionary:[mainArray objectAtIndex:i] 
                                       andSearchLocation:searchDict];
                [self.containerArray addObject:container];
                [container release];
                container = nil;
                
            }
        }
        
        if (self.delegate) {
            [self.delegate accomodationParser:self didFinishLoadingAccomodations:self.containerArray];
        }
        
        //[self.containerArray makeObjectsPerformSelector:@selector(displayCount)];
        
    } else {
        if (self.delegate) {
            [self.delegate accomodationParserDidNotFindData:self];
        }
    }
    
    //NSLog(@"dict: %@", dict);
    
    [htmlData release];
    htmlData = nil;
    _conn = nil;
    self.webData = nil;
}

#pragma mark - Public Methods

- (void)requestAccomodationForSearchString:(NSString*)searchString {
    //NSLog(@"Search String:%@", searchString);
    NSString *urlString = [NSString stringWithFormat:kJSonURL
                           , NSLocalizedString(@"URLLang", nil)
                           , [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *jsonURL = [NSURL URLWithString:urlString];
    //NSLog(@"jsonURl: %@", jsonURL);
    NSURLRequest *request = [NSURLRequest requestWithURL:jsonURL];
    _conn = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if (_conn) {
        //NSLog(@"Conn Established");
        self.webData = [[[NSMutableData alloc] init] autorelease];
    } else {
        //NSLog(@"Conn Failed");
        if (self.delegate) {
            [self.delegate accomodationParserDidNotFindData:self];
        }
    }
    
}

- (void)cancelParsing {
    self.delegate = nil;
    if (_conn) {
        [_conn cancel];
        _conn = nil;
    }
}


@end
