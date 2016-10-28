//
//  HHSegementView.h
//  HHSegementView
//
//  Created by huanghe on 16/10/20.
//  Copyright © 2016年 huanghe. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol HHSegementViewDetegate <NSObject>

-(void)segementViewSelectIndex:(NSInteger) index;

@end

@interface HHSegementView : UIView

@property(nonatomic,assign)id<HHSegementViewDetegate> delegate;

@property(nonatomic,strong)NSArray *titleArray;

@property(nonatomic,assign)NSTimeInterval time;

-(void)selectSegmentWithIndex:(NSInteger) index;


@end
