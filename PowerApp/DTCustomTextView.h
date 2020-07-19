//
//  DTCustomTextView.h
//  libcustomtextview
//  PowerApp
//
//  Modified by David Teddy, II on 7/19/2020.
//  Copyright © 2014-2020 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTCustomTextView : UITextView

- (void) boldSubstring: (NSString *)substring;
- (void) boldSubstring: (NSString *)substring ofSize: (CGFloat)size;
- (void) boldSubstring: (NSString *)substring colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (void) boldSubstring: (NSString *)substring ofSize: (CGFloat)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (void) boldRange: (NSRange)range;
- (void) boldRange: (NSRange)range ofSize: (CGFloat)size;
- (void) boldRange: (NSRange)range colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (void) boldRange: (NSRange)range ofSize: (CGFloat)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (void) italicSubstring: (NSString *)substring;
- (void) italicSubstring: (NSString *)substring ofSize: (CGFloat)size;
- (void) italicSubstring: (NSString *)substring colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (void) italicSubstring: (NSString *)substring ofSize: (CGFloat)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (void) italicRange: (NSRange)range;
- (void) italicRange: (NSRange)range ofSize: (CGFloat)size;
- (void) italicRange: (NSRange)range colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (void) italicRange: (NSRange)range ofSize: (CGFloat)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

@end
