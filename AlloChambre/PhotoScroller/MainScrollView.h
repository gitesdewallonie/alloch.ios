//
//  MainScrollView.h
//  LazyLoading
//

#import <UIKit/UIKit.h>

#import "SubScrollView.h"

@interface MainScrollView : UIScrollView <UIScrollViewDelegate> {
    
    
    SubScrollView *currentPage;
    SubScrollView *prePage;
    SubScrollView *nextPage;
    
    int maxPageNo;
    int currentTag;

    NSArray *imagesArray;

}


- (id)initWithFrame:(CGRect)frame andImagesArray:(NSArray*)array;
- (void)gotoCurrentPage;

@end
