//
//  MyAnnotationView.m
//  AlloChambre
//

#import "MyAnnotationView.h"

@implementation MyAnnotationView

@synthesize resultNumber;
@synthesize labelNumber = _labelNumber;

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier 
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.labelNumber = [[[UILabel alloc] initWithFrame:CGRectMake(1, 3, 25,25)] autorelease];
        [self.labelNumber setBackgroundColor:[UIColor clearColor]];
        [self.labelNumber setFont:[UIFont fontWithName:@"Arial" size:15]];
        [self.labelNumber setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.labelNumber];
        
         
                                               
        
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
    
    self.labelNumber = nil;
    
    [super dealloc];
}
- (void)setNumber:(NSInteger)number {
    //NSLog(@"Number:%d", number);
	self.resultNumber = number;
    [self.labelNumber setText:[NSString stringWithFormat:@"%d", (int)number]]    ;
}

@end
