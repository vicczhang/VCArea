//
//  SelectAreaView.m
//  RaiseLeTang
//
//  Created by zhang on 16/3/9.
//  Copyright © 2016年 Messcat. All rights reserved.
//

#import "SelectAreaView.h"
#define defaultWhiteColor [UIColor whiteColor]
#define getColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
@interface SelectAreaView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    NSDictionary* areaDic;
    NSArray* sortedArray;
    
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;

    NSDictionary* cityDict;
    
}
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign) AreaType type;

@property (nonatomic, strong) NSArray *province;
@property (nonatomic, strong) NSArray *city;
@property (nonatomic, strong) NSArray *area;

@end
@implementation SelectAreaView

- (instancetype)initWithFrame:(CGRect)frame type:(AreaType)type
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = defaultWhiteColor;
        self.type = type;
        [self getAddressData];
        if (_type != AreaTypeProvince) {
            [self getCityData:0];
            if (_type == AreaTypeArea) {
                [self getAreaData:0];
            }
        }
        
        UIButton *leftbtn =  [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [leftbtn setTitle:@"取消" forState:UIControlStateNormal];
        [leftbtn setTitleColor:getColor(123, 163, 219, 1) forState:UIControlStateNormal];
        [leftbtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftbtn];
        UIButton *righttbtn =  [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 50, 0, 50, 30)];
        [righttbtn setTitle:@"确定" forState:UIControlStateNormal];
        [righttbtn setTitleColor:getColor(123, 163, 219, 1) forState:UIControlStateNormal];
        [righttbtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:righttbtn];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, CGRectGetHeight(self.frame) - 30)];
        // 显示选中框
        self.pickerView.showsSelectionIndicator=YES;
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [self addSubview:self.pickerView];
    }
    return self;
}
- (void)getAddressData{
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *components = [areaDic allKeys];
    sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    self.province = [NSArray arrayWithArray:provinceTmp];
    
}

- (void)getCityData:(NSInteger)provinceIndex{
    selectedProvince = [_province objectAtIndex:provinceIndex];
    NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", provinceIndex]]];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
    NSArray *cityArray = [dic allKeys];
    NSArray *sorted = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i=0; i<[sorted count]; i++) {
        NSString *index = [sorted objectAtIndex:i];
        NSArray *temp = [[dic objectForKey: index] allKeys];
        [array addObject: [temp objectAtIndex:0]];
    }
    self.city = [NSArray arrayWithArray:array];

    selectedCity = self.city[0];
    cityDict = dic;
}

- (void)getAreaData:(NSInteger)cityIndex{

    NSArray *cityArray = [cityDict allKeys];
    NSArray *sorted = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [cityDict objectForKey: [sorted objectAtIndex:cityIndex]]];
    
    selectedCity =  self.city[cityIndex];
    
    self.area = cityDic[selectedCity];
    selectedArea = self.area[0];
}

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (_type == AreaTypeProvince) {
        return 1;
    }else if (_type == AreaTypeCity){
        return 2;
    }else{
        return 3;
    }
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.province.count;
    }else if (component == 1){
        return self.city.count;
    }else{
        return self.area.count;
    }
//    return 1;
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (_type == AreaTypeProvince) {
        return CGRectGetWidth(self.frame);
    }else if (_type == AreaTypeCity){
        return CGRectGetWidth(self.frame)/2;
    }else{
        return CGRectGetWidth(self.frame)/3;
    }
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        if (_type  != AreaTypeProvince) {
            [self getCityData:row];
            [self.pickerView reloadComponent:component+1];
            if(_type == AreaTypeArea){
                [self getAreaData:0];
                [self.pickerView reloadComponent:component+2];
            }
            ;
        }
        selectedProvince = self.province[row];
    }
    if (component == 1) {
        if(_type == AreaTypeArea){
            [self getAreaData:row];
            [self.pickerView reloadComponent:component+1];
        }
        selectedCity = self.city[row];
    }
    if (component == 2) {
        selectedArea = self.area[row];
    }
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.province[row];
    }else if (component == 1){
        return self.city[row];
    }else{
        return self.area[row];
    }
}

- (void)cancelAction:(UIButton *)btn{
    _leftClickAction();
}

- (void)submitAction:(UIButton *)btn{
    
    if (_type == AreaTypeProvince) {
        _rightClickAction(selectedProvince);
    }else if (_type == AreaTypeCity){
        _rightClickAction([NSString stringWithFormat:@"%@%@",selectedProvince,selectedCity]);
    }else{
        _rightClickAction([NSString stringWithFormat:@"%@%@%@",selectedProvince,selectedCity,selectedArea]);
    }
    
}

#pragma mark initArray

-  (NSArray *)province{
    if (!_province) {
        _province = [NSArray array];
    }
    return _province;
}

- (NSArray *)city{
    if (!_city) {
        _city = [NSArray array];
    }
    return _city;
}

- (NSArray *)area{
    if (!_area) {
        _area = [NSArray array];
    }
    return _area;
}

@end
