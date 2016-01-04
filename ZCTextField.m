//
//  ZMTextField.m
//
//  Created by Crius on 15/12/7.
//  Copyright © 2015年 Self. All rights reserved.
//

#import "ZCTextField.h"

@interface NSString (Extensions)

- (BOOL)isBlank;
- (BOOL)authWithRegexString:(NSString *)regexString;

@end

@implementation NSString (Extensions)

- (BOOL)isBlank {
    return self == nil || [self isEmptyOrWhitespace];
}

- (BOOL)isEmptyOrWhitespace {
    return 0 == self.length ||
    ![self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
}

- (BOOL)authWithRegexString:(NSString *)regexString {
    NSString *limit = regexString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",limit];
    return  [predicate evaluateWithObject:self];
}

@end

@interface ZCTextField ()

@property (nonatomic, assign ,readwrite) BOOL authResult;

@end

@implementation ZCTextField

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.z_right = 0.0f;
        self.z_left = 0.0f;
        self.z_distance = 0.0f;
        self.font = [UIFont systemFontOfSize:15.0f];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.maxTextLength = 10000;
        
        [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textFieldDidChange:self];
}

- (void)textFieldDidChange:(UITextField *)field {
    if (self.text.length > self.maxTextLength) {
        self.text = [self.text substringToIndex:self.maxTextLength];
        if (self.beyondBlock) {
            self.beyondBlock();
        }
    }
    
    if ([self.regexString isBlank]) {
        return;
    }
    
    self.authResult = [self.text authWithRegexString:self.regexString];
    
    if (self.textChangeBlock) {
         self.textChangeBlock(self.authResult);
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGRect keyBoardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    if (self.keyBoardChangeBlock) {
        self.keyBoardChangeBlock(CGRectGetMinY(keyBoardRect));
    }
}

- (void)setZ_left:(CGFloat)z_left {
    _z_left = z_left;
    [self setNeedsDisplay];
}

- (void)setZ_right:(CGFloat)z_right {
    _z_right = z_right;
    [self setNeedsDisplay];
}

- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.size.width - CGRectGetWidth(self.rightView.frame) - self.z_right,
                      (bounds.size.height - CGRectGetHeight(self.rightView.frame))/2.0f ,
                      CGRectGetWidth(self.rightView.frame),
                      CGRectGetHeight(self.rightView.frame));
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    return CGRectMake(self.z_left,
                      (bounds.size.height - CGRectGetHeight(self.leftView.frame))/2.0f ,
                      CGRectGetWidth(self.leftView.frame),
                      CGRectGetHeight(self.leftView.frame));
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    CGFloat left = CGRectGetMaxX(self.leftView.frame) + self.z_distance;
    CGFloat right = CGRectGetWidth(self.rightView.frame) + self.z_right;
    return CGRectMake(left, bounds.origin.y, bounds.size.width - left - right, bounds.size.height);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    if (self.enabled && self.userInteractionEnabled) {
        if (self.regexResultBlock) {
            self.regexResultBlock(self.authResult);
        }
    }
    
    return YES;
}

- (void)setUnderlLineColor:(UIColor *)underlLineColor {
    _underlLineColor = underlLineColor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_underlLineColor) {
        CGContextSetFillColorWithColor(context, _underlLineColor.CGColor);
        CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1));
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

@end
