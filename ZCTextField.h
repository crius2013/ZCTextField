//
//  ZMTextField.h
//  ZMZX
//
//  Created by Crius on 15/12/7.
//  Copyright © 2015年 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TextBeyondBlock)();
typedef void (^KeyBoardChangeBlock)(CGFloat keyBoardPositionY);
typedef void (^AuthRegexBlock)(BOOL result);
typedef void (^TextChangeAuthBlock)(BOOL result);

@interface ZCTextField : UITextField

@property (nonatomic, assign) CGFloat z_left;    //左边间距
@property (nonatomic, assign) CGFloat z_right;   //右边间距
@property (nonatomic, assign) CGFloat z_distance;   //光标间距
//默认10000的长度
@property (nonatomic, assign) NSInteger maxTextLength;
// 正则表达式验证串
@property (nonatomic, copy) NSString *regexString;
// 设置下划线
@property (nonatomic, strong) UIColor *underlLineColor;
// 验证结果
@property (nonatomic, assign, readonly) BOOL authResult;
// 监听字符串改变时候回调
@property (nonatomic, copy) TextChangeAuthBlock textChangeBlock;
// 监听键盘高度变化
@property (nonatomic, copy) KeyBoardChangeBlock keyBoardChangeBlock;
// 正则验证结果 返回结果 (前提设置过验证串)
@property (nonatomic, copy) AuthRegexBlock regexResultBlock;

@property (nonatomic, copy) TextBeyondBlock beyondBlock;

@end
