//
//  ViewController.m
//  VCArea
//
//  Created by zhang on 16/3/14.
//  Copyright © 2016年 Messcat. All rights reserved.
//

#import "ViewController.h"
#import "SelectAreaView.h"

#define getImageColor(n) [UIColor colorWithPatternImage:[UIImage imageNamed:n]]
#define AppBgImage getImageColor(@"appBg")
@interface ViewController ()

@property (nonatomic, strong)SelectAreaView* areaView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = AppBgImage;
    
    
    
    UIButton * openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    openBtn.frame = CGRectMake((self.view.frame.size.width - 100)/2.0, 300, 100, 40);
    [openBtn setTitle:@"选择地区" forState:UIControlStateNormal];
    [openBtn setTitleColor:[UIColor colorWithRed:217/255.0 green:110/255.0 blue:90/255.0 alpha:1] forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openBtn];
    
    self.areaView = [[SelectAreaView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 216) type:AreaTypeArea];
    __weak typeof(self) weakSelf = self;
    _areaView.leftClickAction = ^(){
        [weakSelf close];
    };
    _areaView.rightClickAction = ^(NSString *areaString){
        
        NSLog(@"area______ %@",areaString);
        [weakSelf close];
    };
    
}


- (void)show{
    
    [[UIApplication sharedApplication].windows[0] addSubview:_areaView];
    
    CGRect frame = _areaView.frame;
    frame.origin.y = self.view.bounds.size.height - _areaView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _areaView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}


- (void)close
{
    CGRect frame = _areaView.frame;
    frame.origin.y += _areaView.frame.size.height;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _areaView.frame = frame;
        
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //变为初始值
            [_areaView.layer setTransform:CATransform3DIdentity];
            
        } completion:^(BOOL finished) {
            
            //移除
            [_areaView removeFromSuperview];
        }];
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
