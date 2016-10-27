//
//  HHSegementView.m
//  HHSegementView
//
//  Created by huanghe on 16/10/20.
//  Copyright © 2016年 huanghe. All rights reserved.
//

#import "HHSegementView.h"

#define FONT_14 [UIFont systemFontOfSize:14]

#define SCREEN_SCALE    (1.0f/[UIScreen mainScreen].scale)


@interface HHSegementView ()<CAAnimationDelegate>


@property(nonatomic, strong)UIView *selectLine;

@property(nonatomic, strong)UIView *bottomLine;

@property(nonatomic, assign)NSInteger selectTag;

@property(nonatomic, strong)NSMutableArray *buttonArray;

@property(nonatomic, strong)NSMutableArray *selectArray;

@end

@implementation HHSegementView


-(UIColor *)colorWithSritng:(NSString *)hex{
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0];

    

}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if(self){
        [self configureContentView];
        self.selectTag = 0;
        self.buttonArray = [[NSMutableArray alloc] init];
        self.selectArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)configureContentView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    
    self.selectLine = [[UIView alloc] init];
    self.selectLine.backgroundColor = [self colorWithSritng:@"4499ff"];
    [self addSubview:self.selectLine];
    
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = [self colorWithSritng:@"e0e0e0"];
    [self addSubview:self.bottomLine];
    

}


-(void)selectSegmentWithIndex:(NSInteger) index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    
    [self onButtonClick:button];
}



-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    
    [self loadData];
}

-(void)loadData{
    
    CGFloat width = self.frame.size.width/_titleArray.count;
    CGFloat height = self.frame.size.height;
    
    
    for(int i = 0 ; i < _titleArray.count ; i++){
        NSString *title = [_titleArray objectAtIndex:i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake( i * width, 0, width, height);
        button.titleLabel.font = FONT_14;
        [button setTitleColor:[self colorWithSritng:@"333333"] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake( i * width, 0, width, height)];
        label.backgroundColor = [UIColor whiteColor];
        label.font = FONT_14;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = title;
        label.textColor = [self colorWithSritng:@"4499ff"];
        [self addSubview:label];
        [self.selectArray addObject:label];
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = [UIColor redColor].CGColor;
        layer.frame = CGRectMake(- width *i, 0, width, height);
        label.layer.mask = layer;

        
    }
    
    self.selectLine.frame = CGRectMake(0, height-2, width, 2);
    [self bringSubviewToFront:self.selectLine];

}

-(void)onButtonClick:(UIButton *)sender{
    
    if(self.selectTag != sender.tag){
        self.selectTag = sender.tag;
    }
    
    if(self.delegate &&[self.delegate respondsToSelector:@selector(segementViewSelectIndex:)]){
        [self.delegate segementViewSelectIndex:self.selectTag];
    }
    
    CGFloat width = self.frame.size.width/_titleArray.count;

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.selectLine.layer.position = [[self.selectLine.layer presentationLayer] position];//得到当前动画的点
    [CATransaction commit];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.3; // 动画持续时间
    CGPoint point = self.selectLine.layer.position;
    point.x =   self.selectTag *width + width/2;
    animation.toValue = [NSValue valueWithCGPoint:point]; // 终了帧
    animation.delegate = self;
    [animation setValue:self.selectLine forKey:@"aaa"];
    [self.selectLine.layer addAnimation:animation forKey:@"animation"];
    
    
    for (int i = 0; i< self.selectArray.count; i++) {
        
        UILabel *label = [self.selectArray objectAtIndex:i];
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        label.layer.mask.position = [[label.layer.mask presentationLayer] position];//得到当前动画的点
        [CATransaction commit];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.duration = 0.3; // 动画持续时间
        CGPoint point = label.layer.mask.position;
        point.x =   (self.selectTag-i) *width + width/2;
        animation.toValue = [NSValue valueWithCGPoint:point]; // 终了帧
        animation.delegate = self;
        [animation setValue:label forKey:@"aaa"];
        [label.layer.mask addAnimation:animation forKey:@"animation"];

    }
//

}


- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag{
    
    
    UIView *view = [anim valueForKey:@"aaa"];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if(flag == YES){
        CGPoint point =  [anim.toValue CGPointValue];
        
        if(view == self.selectLine){
            view.layer.position = point;
        }
        else{
            view.layer.mask.position = point;
        }
        
    }
    else{
        
    }

    [CATransaction commit];
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
