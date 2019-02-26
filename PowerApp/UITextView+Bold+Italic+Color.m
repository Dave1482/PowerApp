//
//  UITextView+Bold+Italic+Color.m
//  PowerApp
//
//  Modified by David Teddy, II on 7/26/2018.
//  Copyright © 2014-2018 David Teddy, II. All rights reserved.
//

#import "UITextView+Bold+Italic+Color.h"

@implementation UITextView (BoldItalicColor)

- (void)boldRange:(NSRange)range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0]} range:range];
    self.attributedText = attributedText;
}

- (void)boldRange:(NSRange)range ofSize:(CGFloat)size {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:size]} range:range];
    self.attributedText = attributedText;
}

- (void)boldRange:(NSRange)range colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16.0], NSForegroundColorAttributeName: color} range:range];
    self.attributedText = attributedText;
}

- (void)boldRange:(NSRange)range ofSize:(CGFloat)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:size], NSForegroundColorAttributeName: color} range:range];
    self.attributedText = attributedText;
}


- (void)boldSubstring:(NSString*)substring{
    if(!substring) return;
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}

- (void)boldSubstring:(NSString*)substring ofSize:(CGFloat)size{
    if(!substring) return;
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range ofSize:size];
}

- (void)boldSubstring:(NSString*)substring colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    if(!substring) return;
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)boldSubstring:(NSString*)substring ofSize:(CGFloat)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    if(!substring) return;
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range ofSize:size colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)italicRange:(NSRange)range {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:16.0]} range:range];
    self.attributedText = attributedText;
}

- (void)italicRange:(NSRange)range ofSize:(CGFloat)size {
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:size]} range:range];
    self.attributedText = attributedText;
}

- (void)italicRange:(NSRange)range colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:16.0], NSForegroundColorAttributeName: color} range:range];
    self.attributedText = attributedText;
}

- (void)italicRange:(NSRange)range ofSize:(CGFloat)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    NSMutableAttributedString *attributedText;
    if (!self.attributedText) {
        attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    } else {
        attributedText = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont italicSystemFontOfSize:size], NSForegroundColorAttributeName: color} range:range];
    self.attributedText = attributedText;
}


- (void)italicSubstring:(NSString*)substring{
    if(!substring) return;
    NSRange range = [self.text rangeOfString:substring];
    [self italicRange:range];
}

- (void)italicSubstring:(NSString*)substring ofSize:(CGFloat)size{
    if(!substring) return;
    NSRange range = [self.text rangeOfString:substring];
    [self italicRange:range ofSize:size];
}

- (void)italicSubstring:(NSString*)substring colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    if(!substring) return;
    NSRange range = [self.text rangeOfString:substring];
    [self italicRange:range colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)italicSubstring:(NSString*)substring ofSize:(CGFloat)size colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
    if(!substring) return;
    NSRange range = [self.text rangeOfString:substring];
    [self italicRange:range ofSize:size colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
