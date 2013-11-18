//
//  TableViewCell.h
//  PDFDownloader
//

#import <UIKit/UIKit.h>


@interface TableViewCell : UITableViewCell {
	 
    UILabel *_countLabel;
    UIImageView *_circleImageView;
}

- (void)setCount:(int)count;




@end
