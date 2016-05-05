//
//  SelectAreaView.h
//  RaiseLeTang
//
//  Created by zhang on 16/3/9.
//  Copyright © 2016年 Messcat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AreaType) {
    AreaTypeProvince,//省
    AreaTypeCity,//市
    AreaTypeArea //区
};
@interface SelectAreaView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(AreaType)type;

@property (nonatomic,strong) void(^leftClickAction)();
@property (nonatomic,strong) void(^rightClickAction)(NSString *areaString);

@end
