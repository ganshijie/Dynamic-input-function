//
//  InputViewController.m
//  动态输入@功能
//
//  Created by 甘世杰 on 16/10/28.
//  Copyright © 2016年 Gsj. All rights reserved.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#import "InputViewController.h"

@interface InputViewController ()
@property (nonatomic,strong) UITextView *inputTextView;
@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态输入界面";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}
-(void)initUI
{
    UILabel *adviceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, ScreenWidth, 20)];
    adviceLabel.text = @"输入任意联系人名字，多选的情况以/为间隔";
    adviceLabel.textAlignment = NSTextAlignmentCenter;
    adviceLabel.textColor = [UIColor redColor];
    [self.view addSubview:adviceLabel];
    
    _inputTextView =[[UITextView alloc]initWithFrame:CGRectMake(10, 100, ScreenWidth, 200)];
    _inputTextView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_inputTextView];
    
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2-100, 310, 200, 100)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor blueColor];
    [sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}
-(void)sureAction
{
    NSArray *array = [_inputTextView.text componentsSeparatedByString:@"/"];
    NSMutableArray *modelArray = [[NSMutableArray alloc]initWithArray:array];
    if (_delegate && [_delegate respondsToSelector:@selector(passToViewControllerWithuserModelArray:)]) {
        [_delegate passToViewControllerWithuserModelArray:modelArray];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
