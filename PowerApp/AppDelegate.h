//
//  AppDelegate.h
//  PowerApp
//
//  Modified by David Teddy, II on 4/24/2022.
//  Copyright © Since 2014 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void) ldRunCheck;
- (void) rebootActionPressed;
- (void) shutdownActionPressed;
- (void) respringActionPressed;
- (void) safeModeActionPressed;
- (BOOL)handleShortCutItem:(UIApplicationShortcutItem *)shortcutItem;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

@end

