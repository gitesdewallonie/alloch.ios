//
//  MainScrollView.m
//  LazyLoading
//

#import "MainScrollView.h"

@implementation MainScrollView



#pragma mark - Private Methods

-(void)removeTempViews{
	
	NSArray *subViewsArray = [self subviews];
	
	for ( int i = 0; i < [subViewsArray count] ; i++ ){
		
		if ([[subViewsArray objectAtIndex:i] isKindOfClass:[SubScrollView class]]   ) {
			SubScrollView *tempView = (SubScrollView*)[subViewsArray objectAtIndex:i];
			
			//int newTag = [currentPage tag];
			//NSLog(@"newTag: %d", newTag);
									
			//					5 6 7 8 9
            //		4 > 4+2     4 < 4-2
			if ( [tempView tag] > currentTag+2 || [tempView tag] < currentTag-2 ) {
				
				[tempView removeFromSuperview];
				//[tempView release];
				tempView = nil;
			}
		}
	}
}

-(SubScrollView*)getExistingSubScrollViewForPageNo:(int)pageNo{
    
    NSArray *subView = [self subviews];
    
    for (int i = 0; i < [subView count] ; i++) {
        if ([[subView objectAtIndex:i] isKindOfClass:[SubScrollView class]]) {
         
            SubScrollView *existingPage = [subView objectAtIndex:i];
            if ([existingPage tag] == pageNo) {
                return existingPage;
            } else {
                continue;
            }
        }
    }
    
    return nil;
    
    
}

-(BOOL)isSubScrollViewExistsForPageNo:(int)pageNo{
    
    NSArray *subView = [self subviews];
    
    for (int i = 0; i < [subView count] ; i++) {
        if ([[subView objectAtIndex:i] isKindOfClass:[SubScrollView class]]) {
            SubScrollView *existingView = (SubScrollView*)[subView objectAtIndex:i];
            if ([existingView tag] == pageNo) {
                return TRUE;
            }            
        }
    }
    
    return FALSE;
    
}


-(SubScrollView*)getNewSubScrollViewForPageNo:(int)pageNo{
    
    if (pageNo >= 1 && pageNo <= maxPageNo) {

        SubScrollView *newView;
        
        if (![self isSubScrollViewExistsForPageNo:pageNo]) {
            // Setting the X Position for New SubScrollView
            //NSLog(@"Creating new VIew for Tag: %d", pageNo);
            float newX = (pageNo-1)*self.frame.size.width;
            
            // Creating a new object of SubScrollView
            newView = [[[SubScrollView alloc] initWithFrame:CGRectMake(newX, 0, self.frame.size.width, self.frame.size.height)] autorelease];
            [newView setTag:pageNo];
            [newView setImageURLString:[imagesArray objectAtIndex:pageNo-1]];
            return newView;
            
        } else {
            newView = [self getExistingSubScrollViewForPageNo:pageNo];
        }
        
        return newView;
    } 
    
    return nil;
    
}

-(void)createPageWithNo:(int)_no{
	//NSLog(@"called for No: %d", _no);
	if (_no > 0 && _no <= maxPageNo ) {
		
		if (_no == [currentPage tag]) {
			//NSLog(@"Do Nothing");
		} else {
			
			//SubScrollView *tempView;
			
			if ( _no > currentTag ) {
				
				//NSLog(@"forward");
				
				prePage = currentPage;	
				currentPage = [self getNewSubScrollViewForPageNo:_no]; //nextPage;
				
				if (_no < maxPageNo) {
					//NSLog(@"value: %d", _no);
					nextPage = [self getNewSubScrollViewForPageNo:_no+1];
					[self addSubview:nextPage];			
				} else {
					nextPage = nil;
				}
				
				if (_no == 1) {
					prePage = nil;
				}
				
			} else {
                //	NSLog(@"backward");
                
				nextPage = currentPage;	
				currentPage = [self getNewSubScrollViewForPageNo:_no]; 
				
				if (_no>0) {
					if (_no == 1) {
						_no = 2;
					}
					prePage = [self getNewSubScrollViewForPageNo:_no-1];
					[self addSubview:prePage];
				}	
				
				if (_no == maxPageNo) {
					nextPage = nil;
				}
                
				//NSLog(@"Next Page Removed");				
			}
			
			if ([currentPage tag] == 1) {
				prePage = nil;
			}
			
			if ([currentPage tag] == maxPageNo) {
				nextPage = nil;
			}
            
		}	
	}
}

-(void)checkExistingSubviews{
    NSArray *subviewsArray = [self subviews];
    
    for (int i = 0; i < [subviewsArray count]; i++) {
        if ([[subviewsArray objectAtIndex:i] isKindOfClass:[SubScrollView class]]) {
            //NSLog(@"Subview Exists for Tag: %d",[[subviewsArray objectAtIndex:i] tag]);
        }
    }
}

-(void)checkForMissingViews{
	
	int newTag = currentTag-2;
    
	for (int j = 0; j < 5; j++ ) {
		
		if (newTag>0 && newTag <= maxPageNo) {
			
			if (![self isSubScrollViewExistsForPageNo:newTag]) {
				
				SubScrollView *newSV = [self getNewSubScrollViewForPageNo:newTag];
				if (newSV) {
					[self addSubview:newSV];
					if (newSV.tag == currentTag) {
						
					}
				}
			}
		}
		
		newTag++;
	}
}


#pragma mark - Class Methods

- (void)layoutSubviews{
    
    [self setContentSize:CGSizeMake(self.frame.size.width*maxPageNo, self.frame.size.height)];
    
}

- (id)initWithFrame:(CGRect)frame andImagesArray:(NSArray*)array
{
    self = [super initWithFrame:frame];
    if (self) {
        imagesArray = [[NSArray alloc] initWithArray:array];
        //NSLog(@"Images Array: %@", imagesArray);
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setScrollEnabled:YES];
        [self setPagingEnabled:YES];
        [self setClipsToBounds:YES];
        [self setDelegate:self];
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight]; /* | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |
         UIViewAutoresizingFlexibleRightMargin];*/
        
        maxPageNo = [imagesArray count];;
        currentTag = 1;
        
        //prePage = [self getNewSubScrollViewForPageNo:1];
        currentPage = [self getNewSubScrollViewForPageNo:1];
        nextPage = [self getNewSubScrollViewForPageNo:2];
        
        [self addSubview:currentPage];
        [self addSubview:nextPage];
        //[self addSubview:prePage];
        
        [self setContentSize:CGSizeMake(self.frame.size.width*maxPageNo, self.frame.size.height)];
        
        [currentPage startDownloadingImages];
        //[self downloadJSONDataForPageNo:1];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    
    
    [imagesArray release];
    imagesArray = nil;
    
    [super dealloc];
}


#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // This function is called at the end when scrolling stops
    //NSLog(@"scrollViewDidEndDecelerating called");
    
    if (![currentPage isDataLoaded]) {
        [currentPage startDownloadingImages];
    }      
    
    [self checkForMissingViews];
    //[self checkExistingSubviews];
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    //NSLog(@"---scrollViewDidEndDragging called");

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [currentPage cancelDownloading];
    
    int newTag = (int) (self.contentOffset.x/self.frame.size.width +1);
    
    //NSLog(@"newTag: %d", newTag);
    if (newTag != currentTag) {	
                
        [self createPageWithNo:newTag];
        currentTag = [currentPage tag];        
        [self removeTempViews]; 
		
	}
}

#pragma mark - Public Methods

- (void)gotoCurrentPage{
    //[self zoomToRect:currentPage.frame animated:YES];
    [self setContentOffset:currentPage.frame.origin animated:YES];
}

@end
