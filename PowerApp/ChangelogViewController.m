//
//  ChangelogViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 7/24/2020.
//  Copyright © 2014-2022 David Teddy, II (Dave1482). All rights reserved.
//

#import "ChangelogViewController.h"

@interface ChangelogViewController ()

@end
@implementation ChangelogViewController
@synthesize changes;
@synthesize navBar;

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
  return UIBarPositionTopAttached;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  
  [changes setFont:[UIFont systemFontOfSize:16]];
  
  cLog = [[NSBundle mainBundle] pathForResource:@"cLog" ofType:@"txt"];
  changes.text = [NSString stringWithContentsOfFile:cLog encoding:NSUTF8StringEncoding error:NULL];
  [changes setTextAlignment:NSTextAlignmentLeft];
  [self colorChanges];
  NSError *error = NULL;
  regex = [NSRegularExpression regularExpressionWithPattern:@"Version \\d?\\d?\\d\\.\\d\\.?\\d?:" options:0 error:&error];
  matches = [regex matchesInString:changes.text options:0 range:NSMakeRange(0, [changes.text length])];
  matchCount = [matches count];
  if (matchCount) {
    for (NSUInteger matchIdx = 0; matchIdx < matchCount; matchIdx++) {
      match = [matches objectAtIndex:matchIdx];
      matchRange = [match range];
      version = [changes.text substringWithRange:matchRange];
      [changes boldSubstring: version ofSize:16.0 colorWithRed:0.0 green:123.0/256.0 blue:1.0 alpha:1.0];
    }
  }
  // Yay, no more updating this for each new version!
  changes.editable = NO;
  [changes setUserInteractionEnabled:YES];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorChanges) name:NSUserDefaultsDidChangeNotification object:nil];
  
}
- (void)viewDidLayoutSubviews {
  [changes setContentOffset:CGPointZero animated:NO];
}

- (void)colorChanges {
  if (@available(iOS 13, *)){
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"lightControl"]){
      case 0:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        [self setNeedsStatusBarAppearanceUpdate];
        [changes setBackgroundColor:[UIColor whiteColor]];
        [changes setTextColor:[UIColor blackColor]];
        navBar.barTintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        break;
      case 1:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
        [self setNeedsStatusBarAppearanceUpdate];
        [changes setBackgroundColor:[UIColor blackColor]];
        [changes setTextColor:[UIColor whiteColor]];
        navBar.barTintColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        break;
      case 2:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleUnspecified];
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
          [self setNeedsStatusBarAppearanceUpdate];
          [changes setBackgroundColor:[UIColor blackColor]];
          [changes setTextColor:[UIColor whiteColor]];
          navBar.barTintColor = [UIColor blackColor];
          self.view.backgroundColor = [UIColor blackColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        } else {
          [self setNeedsStatusBarAppearanceUpdate];
          [changes setBackgroundColor:[UIColor whiteColor]];
          [changes setTextColor:[UIColor blackColor]];
          navBar.barTintColor = [UIColor whiteColor];
          self.view.backgroundColor = [UIColor whiteColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        }
        break;
      default:
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
          if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
          }
          [self setNeedsStatusBarAppearanceUpdate];
          [changes setBackgroundColor:[UIColor whiteColor]];
          [changes setTextColor:[UIColor blackColor]];
          navBar.barTintColor = [UIColor whiteColor];
          self.view.backgroundColor = [UIColor whiteColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        } else {
          if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
          }
          [self setNeedsStatusBarAppearanceUpdate];
          [changes setBackgroundColor:[UIColor blackColor]];
          [changes setTextColor:[UIColor whiteColor]];
          navBar.barTintColor = [UIColor blackColor];
          self.view.backgroundColor = [UIColor blackColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        }
        break;
    }
  } else {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
      if (@available(iOS 13, *)) {
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
      }
      [self setNeedsStatusBarAppearanceUpdate];
      [changes setBackgroundColor:[UIColor whiteColor]];
      [changes setTextColor:[UIColor blackColor]];
      navBar.barTintColor = [UIColor whiteColor];
      self.view.backgroundColor = [UIColor whiteColor];
      [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

    } else {
      if (@available(iOS 13, *)) {
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
      }
      [self setNeedsStatusBarAppearanceUpdate];
      [changes setBackgroundColor:[UIColor blackColor]];
      [changes setTextColor:[UIColor whiteColor]];
      navBar.barTintColor = [UIColor blackColor];
      self.view.backgroundColor = [UIColor blackColor];
      [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
  }
  if (matchCount) {
    for (NSUInteger matchIdx = 0; matchIdx < matchCount; matchIdx++) {
      match = [matches objectAtIndex:matchIdx];
      matchRange = [match range];
      version = [changes.text substringWithRange:matchRange];
      [changes boldSubstring: version ofSize:16.0 colorWithRed:0.0 green:123.0/256.0 blue:1.0 alpha:1.0];
    }
  }
}

- (IBAction)showDevInfo{
  UIAlertController *devAlert;
  NSString *info;
  if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"]){
    info = @"Thank you for using PowerApp!\n\nReboot:\nFully reboots your device\n\nShutdown:\nFully powers off your device\n\nSoft Reboot (not available on\nChimera or Odyssey):\nReboots everything but the kernel and should preserve the jailbreak\n\nldRun (only on Chimera and Odyssey):\nResprings with \"ldrestart\"\n\nSubstrate Safe Mode:\nResprings into safe mode if MobileSubstrate is installed, otherwise the device will just respring.\n\nSubstitute Safe Mode: Resprings into Safe Mode\n\nRefresh Cache:\nReloads the home screen with \"uicache\"\n\nMore information in the Developer section of the Settings page\n\nCopyright © Dave1482";
  } else {
    info = @"Thank you for using PowerApp!\n\nReboot:\nFully reboots your device\n\nShutdown:\nFully powers off your device\n\nSoft Reboot (not available on\nChimera or Odyssey):\nReboots everything but the kernel and should preserve the jailbreak\n\nldRun (only on Chimera and Odyssey):\nResprings with \"ldrestart\"\n\nSafe Mode:\nResprings into safe mode if MobileSubstrate is installed\n\nNon-Substrate Mode (Only for MobileSubstrate):\nIf not in safe mode, your device will respring into safe mode.\nIf the device is already in safe mode, it will respring into Non-MobileSubstrate Mode.\n\nRefresh Cache:\nReloads the home screen with \"uicache\"\n\nMore information in the Developer section of the Settings page\n\nCopyright © Dave1482";
  }
  devAlert = [UIAlertController alertControllerWithTitle:@"App Information" message:info preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *doneDevBtn = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
  [devAlert addAction:doneDevBtn];
  [self presentViewController:devAlert animated:YES completion:nil];
}
 
- (UIStatusBarStyle)preferredStatusBarStyle
{
  if(@available (iOS 13, *)){
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"lightControl"]) {
      case 0:
        return UIStatusBarStyleDefault;
        break;
      case 1:
        return UIStatusBarStyleLightContent;
        break;
      case 2:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleUnspecified];
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
          return UIStatusBarStyleLightContent;
        } else {
          return UIStatusBarStyleDefault;
        }
        break;
      default:
        if([[NSUserDefaults standardUserDefaults] integerForKey:@"lightSwitch"] == YES){
          return UIStatusBarStyleDefault;
        } else {
          return UIStatusBarStyleLightContent;
        }
        break;
    }
    
  } else {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
      return UIStatusBarStyleDefault;
    } else {
      return UIStatusBarStyleLightContent;
    }
  }
}

- (IBAction)dismissChangelogViewController {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
@end
