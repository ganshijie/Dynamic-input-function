//
//  InputViewController.h
//  动态输入@功能
//
//  Created by 甘世杰 on 16/10/28.
//  Copyright © 2016年 Gsj. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol passToViewControllerDelegate <NSObject>

- (void) passToViewControllerWithuserModelArray:(NSMutableArray *)userModelArray;

@end
@interface InputViewController : UIViewController
@property(nonatomic,assign) NSInteger location;
@property (nonatomic,retain) id <passToViewControllerDelegate> delegate;
@end
