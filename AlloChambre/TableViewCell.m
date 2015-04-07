//
//  TableViewCell.m
//  PDFDownloader
//

#import "TableViewCell.h"

#define MARGIN 5



@implementation TableViewCell


- (void)hideCountLabel:(BOOL)val {
    [_countLabel setHidden:val];
    [_circleImageView setHidden:val];
}


- (void) layoutSubviews {
    [super layoutSubviews];
    CGRect cvf = self.contentView.frame;
    self.imageView.frame = CGRectMake(5.0,
                                      0.0,
                                      cvf.size.height-1,
                                      cvf.size.height-1);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	
    CGRect frame = CGRectMake(cvf.size.height + MARGIN + 3,
                              self.textLabel.frame.origin.y,
                              cvf.size.width - cvf.size.height - 30,
                              self.textLabel.frame.size.height);
    self.textLabel.frame = frame;
	
    frame = CGRectMake(cvf.size.height + MARGIN,
                       self.detailTextLabel.frame.origin.y,
                       cvf.size.width - cvf.size.height - 2*MARGIN,
                       self.detailTextLabel.frame.size.height);   
    self.detailTextLabel.frame = frame;
    
    frame = CGRectMake(cvf.size.width - 16, (cvf.size.height-20)/2 , 20, 20);
    [_countLabel setFrame:frame];
    [_circleImageView setFrame:frame];
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
		
		[self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self setBackgroundColor:[UIColor whiteColor]];
        //[self.textLabel setBackgroundColor:[UIColor blueColor]];
        
        
        _circleImageView = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"circle.png"]];
        [_circleImageView setBackgroundColor:[UIColor clearColor]];
        [self.contentView addSubview:_circleImageView];
        
        _countLabel = [[UILabel alloc] init];
        [_countLabel setBackgroundColor:[UIColor clearColor]];
        [_countLabel setTextAlignment:NSTextAlignmentCenter];
        [_countLabel setFont:[UIFont fontWithName:@"Arial" size:14]];
        [self.contentView addSubview:_countLabel];
        
        [self hideCountLabel:YES];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	
	[_countLabel release];
    _countLabel = nil;
    
    [_circleImageView release];
    _circleImageView = nil;
	
    [super dealloc];
}

- (void)setCount:(int)count {
    if (count > 1) {
        [_countLabel setText:[NSString stringWithFormat:@"%d", count]];
        [self hideCountLabel:NO];
    } else {
        [self hideCountLabel:YES];
    }
    
}


@end
