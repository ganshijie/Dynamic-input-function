//
//  MainViewController.m
//  动态输入@功能
//
//  Created by 甘世杰 on 16/10/28.
//  Copyright © 2016年 Gsj. All rights reserved.
//
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import "MainViewController.h"
#import "YYText.h"
#import "InputViewController.h"
@interface MainViewController ()<YYTextViewDelegate,passToViewControllerDelegate>
@property (nonatomic) YYTextView *inputTextView;
@property (nonatomic,strong) NSMutableArray *atUserModelArray;
@property (nonatomic,strong) NSMutableArray *totalUserModelArray;
@property (nonatomic,assign) NSInteger location;
@property (nonatomic,strong) NSMutableArray   *remeberArrays;
@end

@implementation MainViewController
-(NSMutableArray *)remeberArrays
{
    if (!_remeberArrays) {
        _remeberArrays = [NSMutableArray array];
    }
    return _remeberArrays;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"动态输入@功能";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}
#pragma mark -初始化-
-(void)initUI
{
    _location = 0;
    _inputTextView = [[YYTextView alloc] init];
    [self.view addSubview:_inputTextView];
    _inputTextView.frame = CGRectMake(10, 100, ScreenWidth - 20, 200);
    _inputTextView.delegate = self;
    _inputTextView.backgroundColor = [UIColor greenColor];
    _inputTextView.font = [UIFont systemFontOfSize:16];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 100, 300, 200, 100)];
    [button setTitle:@"清空" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor blueColor];
    [self.view addSubview:button];

}
-(void)clear
{
    _inputTextView.text = @"";
    _location = 0;
    [self.view endEditing:YES];
}
-(BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"@"])
    {
        NSUInteger location = _inputTextView.selectedRange.location;
        InputViewController *inputVc = [[InputViewController alloc]init];
        inputVc.location = location;
        _location = location;
        inputVc.delegate = self;
        [self.navigationController pushViewController:inputVc animated:YES];
        return YES;
    }
    return YES;
}
-(void)passToViewControllerWithuserModelArray:(NSMutableArray *)userModelArray
{
    NSLog(@"%@",userModelArray);
        NSMutableAttributedString *deleteText = [[NSMutableAttributedString alloc] initWithString: _inputTextView.text];
        deleteText.yy_font = [UIFont systemFontOfSize:16];
        if (userModelArray.count != 0) {
            _totalUserModelArray = userModelArray;
            if (deleteText.length == _location) {
                _location=_location-1;
            }
            [deleteText deleteCharactersInRange:NSMakeRange(_location,1)];
        }
    
        _totalUserModelArray = userModelArray;
        if (userModelArray.count == 0) {
            [_inputTextView setSelectedRange:NSMakeRange(deleteText.length, 0)];
        }else
        {
            NSMutableArray *nameArrays = [NSMutableArray array];
            for (int i = 0; i< userModelArray.count; i++) {
                [_atUserModelArray addObject:userModelArray[i]];
                NSString *FollowName;
                FollowName = [NSString stringWithFormat:@"@%@ ",userModelArray[i]];
                [nameArrays addObject:FollowName];
                [self.remeberArrays addObject:FollowName];
            }
            NSMutableAttributedString *remberRext =[[NSMutableAttributedString alloc]init];
            [remberRext appendAttributedString:deleteText];
            UIFont *font = [UIFont systemFontOfSize:16];
            for (int i = 0; i < nameArrays.count; i++) {
                NSString *tag = nameArrays[nameArrays.count-i-1];
                NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
                tagText.yy_font = font;
                [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.yy_rangeOfAll];
                [remberRext insertAttributedString:tagText atIndex:_location];
            }
            remberRext.yy_lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributeDict = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]};
            _inputTextView.attributedText = remberRext;
            _inputTextView.attributedText = [[NSMutableAttributedString alloc]initWithString:_inputTextView.text attributes:attributeDict];
            NSMutableAttributedString *attributedStr = [NSMutableAttributedString new];
            [attributedStr appendAttributedString:remberRext];
            for (int i = 0; i < _remeberArrays.count; i++) {
                NSString *tag = _remeberArrays[i];
                NSString *temp = nil;
                NSInteger Z =0;
                NSInteger T = 0;
                if ([_inputTextView.text length]+1>[tag length]) {
                    for(int j =0; j < [_inputTextView.text length]+1-[tag length]; j++)
                    {
                        temp = [_inputTextView.text substringWithRange:NSMakeRange(j, [tag length])];
                        if ([temp isEqualToString:tag]) {
                            if (j> Z+[tag length]-1 || T == 0) {
                                NSLog(@"项目号第%d个字是:%@", j, temp);
                                Z =j;
                                T++;
                                NSDictionary *attributeDict = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]};
                                NSMutableAttributedString *attributedTag = [[NSMutableAttributedString alloc]initWithString:tag attributes:attributeDict];
                                [attributedTag yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:attributedTag.yy_rangeOfAll];
                                [attributedStr insertAttributedString:attributedTag atIndex:j];
                                [attributedStr deleteCharactersInRange:NSMakeRange(j+tag.length, tag.length)];
                            }
                        }
                    }
                    _inputTextView.attributedText = attributedStr;
                    [_inputTextView setSelectedRange:NSMakeRange(_inputTextView.attributedText.length, 0)];
                }
            }
        }
}
@end
