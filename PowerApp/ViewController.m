//
//  ViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 7/19/2020.
//  Copyright © 2014-2020 David Teddy, II (Dave1482). All rights reserved.
//

#import "ViewController.h"
#include <stdio.h>
#include <stdlib.h>
#include <spawn.h>
#include <dlfcn.h>

@interface ViewController () 

@end

@implementation ViewController
@synthesize navBar;
@synthesize rightButton;
@synthesize rebootButton;
@synthesize shutdownButton;
@synthesize softRebootButton;
@synthesize respringButton;
@synthesize safeButton;
@synthesize nonButton;
@synthesize uicButton;
@synthesize exitButton;

NSString *sileoPath = @"/Applications/Sileo.app/Info.plist";
NSString *cydiaPath = @"/Applications/Cydia.app/Cydia";

#define _POSIX_SPAWN_DISABLE_ASLR 0x0100
#define _POSIX_SPAWN_ALLOW_DATA_EXEC 0x2000
extern char **environ;
char *rebootChar;
char *shutdownChar;
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
  return UIBarPositionTopAttached;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  customRedBorderColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];
  customGreenBorderColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1];
  customBlueBorderColor = [UIColor colorWithRed:0.0 green:123.0/256.0 blue:1.0 alpha:1];
  
  [self colorMe];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorMe) name:NSUserDefaultsDidChangeNotification object:nil];
  
  rebootButton.layer.cornerRadius = 15;
  shutdownButton.layer.cornerRadius = 15;
  softRebootButton.layer.cornerRadius = 15;
  respringButton.layer.cornerRadius = 15;
  safeButton.layer.cornerRadius = 15;
  nonButton.layer.cornerRadius = 15;
  uicButton.layer.cornerRadius = 15;
  exitButton.layer.cornerRadius = 15;
  safeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  nonButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  uicButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  softRebootButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  exitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [softRebootButton setTitle:@"Soft\nReboot" forState:UIControlStateNormal];
  [nonButton setTitle:@"Non-Substrate\nMode" forState:UIControlStateNormal];
  [uicButton setTitle:@"Refresh\nCache" forState:UIControlStateNormal];
  [exitButton setTitle:@"Exit\nPowerApp" forState:UIControlStateNormal];
  if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"]){
    [safeButton setTitle:@"Substrate\nSafe Mode" forState:UIControlStateNormal];
    [nonButton setTitle:@"Substitute\nSafe Mode" forState:UIControlStateNormal];
  }
  NSString *amIBeta = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
  NSString *versionURL;
  NSString *keyString;
  if ([amIBeta containsString:@"beta"]){
    versionURL = @"https://github.dave1482.com/PowerApp/betaVersion";
    keyString = @"CFBundleVersion";
  } else {
    versionURL = @"https://github.dave1482.com/PowerApp/version";
    keyString = @"CFBundleShortVersionString";
  }
  NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:versionURL]
                        cachePolicy:NSURLRequestReloadIgnoringCacheData
                      timeoutInterval:10.0];
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:theRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    self->receivedDataString =  [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    self->keyInfo = [[[[NSBundle mainBundle] infoDictionary] objectForKey:keyString] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    [self updateCheckWithKeyInfo:self->keyInfo];
  }];
  [dataTask resume];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorMe) name:NSUserDefaultsDidChangeNotification object:nil];
  
}

void run_cmd(char *cmd)
{
  rebootChar = "kill 1";
  shutdownChar = "halt";
  if (cmd != rebootChar && cmd != shutdownChar) {
    setgid(501);
    setuid(501);
  }
  pid_t pid;
  char *argv[] = {"sh", "-c", cmd, NULL};
  int status;
  status = posix_spawn(&pid, "/bin/sh", NULL, NULL, (char* const*)argv, environ);
  if (status == 0) {
    printf("Child pid: %i\n", pid);
    if (waitpid(pid, &status, 0) != -1) {
      printf("Child exited with status %i\n", status);
    } else {
      perror("waitpid");
    }
  } else {
    printf("posix_spawn: %s\n", strerror(status));
  }
}

- (IBAction)rebootButtonPressed {
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
    UIAlertController *alertRebootBtn1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will REBOOT your device.\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noRebootBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesRebootBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      setuid(0);
      setgid(0);
      run_cmd("kill 1");
    }];
    [alertRebootBtn1 addAction:noRebootBtn1];
    [alertRebootBtn1 addAction:yesRebootBtn1];
    [self presentViewController:alertRebootBtn1 animated:YES completion:nil];
  } else {
    setuid(0);
    setgid(0);
    run_cmd("kill 1");
    
  }

}

- (IBAction)shutdownButtonPressed {
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
    UIAlertController *alertShutdownBtn1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will SHUTDOWN your device.\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noShutdownBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesShutdownBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      setuid(0);
      setgid(0);
      run_cmd("halt");
    }];
    [alertShutdownBtn1 addAction:noShutdownBtn1];
    [alertShutdownBtn1 addAction:yesShutdownBtn1];
    [self presentViewController:alertShutdownBtn1 animated:YES completion:nil];
  } else {
    setuid(0);
    setgid(0);
    run_cmd("halt");
  }

}

- (IBAction)softRebootButtonPressed {
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
    UIAlertController *alertSoftRebootButton1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will REBOOT your device, but you should still retain your jailbreak.\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noSoftRebootBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesSoftRebootBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        run_cmd("launchctl reboot userspace");
    }];
    [alertSoftRebootButton1 addAction:noSoftRebootBtn1];
    [alertSoftRebootButton1 addAction:yesSoftRebootBtn1];
    [self presentViewController:alertSoftRebootButton1 animated:YES completion:nil];
  } else {
      run_cmd("launchctl reboot userspace");
  }
}

- (IBAction)respringButtonPressed {
  long btnControlValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"];
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
    UIAlertController *alertRespringBtn1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will Respring your device. This will stop all apps!\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noRespringBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesRespringBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      switch (btnControlValue)
      {
         case 0:
          run_cmd("killall -9 SpringBoard");
          break;
         case 1:
          [self sbreloadCheck];
          break;
        case 2:
          [self ldRunCheck];
          break;
         default:
          run_cmd("killall -9 SpringBoard");
         break;
      }
    }];
    [alertRespringBtn1 addAction:noRespringBtn1];
    [alertRespringBtn1 addAction:yesRespringBtn1];
    [self presentViewController:alertRespringBtn1 animated:YES completion:nil];
  } else {
    switch (btnControlValue)
    {
       case 0:
        run_cmd("killall -9 SpringBoard");
        break;
       case 1:
        [self sbreloadCheck];
        break;
       case 2:
        [self ldRunCheck];
        break;
       default:
        run_cmd("killall -9 SpringBoard");
       break;
    }
  }
}

- (IBAction)safeModeButtonPressed {
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
    UIAlertController *alertSafemodeBtn1;
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"]){
      alertSafemodeBtn1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will only respring your device since you have substrate. This will stop all apps!\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    } else {
      alertSafemodeBtn1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will put your system into Safemode. This will stop all apps!\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    }
    UIAlertAction *noSafeBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesSafeBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      run_cmd("touch /var/mobile/Library/Preferences/com.saurik.mobilesubstrate.dat; killall SpringBoard");
    }];
    [alertSafemodeBtn1 addAction:noSafeBtn1];
    [alertSafemodeBtn1 addAction:yesSafeBtn1];
    [self presentViewController:alertSafemodeBtn1 animated:YES completion:nil];
  } else {
    run_cmd("touch /var/mobile/Library/Preferences/com.saurik.mobilesubstrate.dat; killall SpringBoard");
  }
}

- (IBAction)nonMobileSubstrateModeButtonPressed {
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
    UIAlertController *alertNonTweakBtn1;
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"]){
      alertNonTweakBtn1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Using this will put it into Non-Substitute Mode (aka Safe Mode)!\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    } else {
      alertNonTweakBtn1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"Using this in Safemode will put it into Non-MobileSubstrate Mode. Any other mode will put it into Safemode This will kill all processes!\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    }
    UIAlertAction *noTweakBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesTweakBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      run_cmd("killall -SEGV SpringBoard");
    }];
    [alertNonTweakBtn1 addAction:noTweakBtn1];
    [alertNonTweakBtn1 addAction:yesTweakBtn1];
    [self presentViewController:alertNonTweakBtn1 animated:YES completion:nil];
  } else {
    run_cmd("killall -SEGV SpringBoard");
  }
}

- (IBAction)refreshCacheButtonPressed {
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
    UIAlertController *alertRefreshButton1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This refreshes the SpringBoard so you can see your new apps without respringing. This will temporarily freeze your Home Screen (Exit this app after this is complete)!\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noRefreshBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesRefreshBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        run_cmd("uicache --all");
    }];
    [alertRefreshButton1 addAction:noRefreshBtn1];
    [alertRefreshButton1 addAction:yesRefreshBtn1];
    [self presentViewController:alertRefreshButton1 animated:YES completion:nil];
  } else {
      run_cmd("uicache --all");
  }
}

- (IBAction)exitButtonPressed {
  if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
    UIAlertController *alertExitButton1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This only kills PowerApp. Great if you want to save your home button.\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noExitBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesExitBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      exit(0);
    }];
    [alertExitButton1 addAction:noExitBtn1];
    [alertExitButton1 addAction:yesExitBtn1];
    [self presentViewController:alertExitButton1 animated:YES completion:nil];

  } else {
    exit(0);
  }
}

- (void)colorMe {
  int borderW = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"borderControl"];
  if (borderW == 3){
    borderW = borderW * 3;
  } else if (borderW == 2){
    borderW = borderW + 1;
  }
  rebootButton.layer.borderWidth = borderW;
  shutdownButton.layer.borderWidth = borderW;
  softRebootButton.layer.borderWidth = borderW;
  respringButton.layer.borderWidth = borderW;
  safeButton.layer.borderWidth = borderW;
  nonButton.layer.borderWidth = borderW;
  uicButton.layer.borderWidth = borderW;
  exitButton.layer.borderWidth = borderW;
  if (borderW > 0) {
    rebootButton.layer.borderColor = customRedBorderColor.CGColor;
    shutdownButton.layer.borderColor = customRedBorderColor.CGColor;
    softRebootButton.layer.borderColor = customBlueBorderColor.CGColor;
    respringButton.layer.borderColor = customBlueBorderColor.CGColor;
    safeButton.layer.borderColor = customBlueBorderColor.CGColor;
    nonButton.layer.borderColor = customBlueBorderColor.CGColor;
    uicButton.layer.borderColor = customGreenBorderColor.CGColor;
    exitButton.layer.borderColor = customGreenBorderColor.CGColor;
  } else {
    rebootButton.layer.borderColor = nil;
    shutdownButton.layer.borderColor = nil;
    softRebootButton.layer.borderColor = nil;
    respringButton.layer.borderColor = nil;
    safeButton.layer.borderColor = nil;
    nonButton.layer.borderColor = nil;
    uicButton.layer.borderColor = nil;
    exitButton.layer.borderColor = nil;
  }
  if (@available(iOS 13, *)){
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"lightControl"]){
      case 0:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        self.view.backgroundColor = [UIColor whiteColor];
        navBar.barTintColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        break;
      case 1:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
        self.view.backgroundColor = [UIColor blackColor];
        navBar.barTintColor = [UIColor blackColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        break;
      case 2:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleUnspecified];
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
          [self setNeedsStatusBarAppearanceUpdate];
          self.view.backgroundColor = [UIColor blackColor];
          navBar.barTintColor = [UIColor blackColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        } else {
          self.view.backgroundColor = [UIColor whiteColor];
          navBar.barTintColor = [UIColor whiteColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        }
        break;
      default:
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
          self.view.backgroundColor = [UIColor whiteColor];
          navBar.barTintColor = [UIColor whiteColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        } else {
          self.view.backgroundColor = [UIColor blackColor];
          navBar.barTintColor = [UIColor blackColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        }
        break;
    }
  } else {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
      self.view.backgroundColor = [UIColor whiteColor];
      navBar.barTintColor = [UIColor whiteColor];
      [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    } else {
      self.view.backgroundColor = [UIColor blackColor];
      navBar.barTintColor = [UIColor blackColor];
      [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
  }
}

- (void) updateCheckWithKeyInfo:(NSString *)leInfo   {
  UIAlertController *alertCheckForUpdate;
  NSString *alertMessage;
  if (![receivedDataString isEqual:leInfo] && ![receivedDataString isEqual: @""])
  {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    UIAlertAction *noUpdateBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesCydiaUpdateBtn = [UIAlertAction actionWithTitle:@"Cydia" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"cydia://sources"] options:@{} completionHandler:nil];
    }];
    UIAlertAction *yesSileoUpdateBtn = [UIAlertAction actionWithTitle:@"Sileo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"sileo://package/com.dave1482.powerapp"] options:@{} completionHandler:nil];
    }];
    
    if ([fileManager fileExistsAtPath:sileoPath] && ![fileManager fileExistsAtPath:cydiaPath]) {
      alertMessage = [NSString stringWithFormat:@"Open Sileo to update PowerApp to v%@?", receivedDataString];
    } else if (![fileManager fileExistsAtPath:sileoPath] && [fileManager fileExistsAtPath:cydiaPath]) {
      alertMessage = [NSString stringWithFormat:@"Open Cydia to update PowerApp to v%@?", receivedDataString];
    } else if ([fileManager fileExistsAtPath:sileoPath] && [fileManager fileExistsAtPath:cydiaPath]) {
      alertMessage = [NSString stringWithFormat:@"Open Cydia/Sileo to update PowerApp to v%@?", receivedDataString];
    } else {
      alertMessage = [NSString stringWithFormat:@"PowerApp v%@ is available but for some reason you don't have Sileo or Cydia.", receivedDataString];
    }
    alertCheckForUpdate = [UIAlertController alertControllerWithTitle:@"New Update Available" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    if ([fileManager fileExistsAtPath:sileoPath] && ![fileManager fileExistsAtPath:cydiaPath]) {
      [alertCheckForUpdate addAction:yesSileoUpdateBtn];
      [alertCheckForUpdate addAction:noUpdateBtn];
     } else if (![fileManager fileExistsAtPath:sileoPath] && [fileManager fileExistsAtPath:cydiaPath]) {
      [alertCheckForUpdate addAction:yesCydiaUpdateBtn];
      [alertCheckForUpdate addAction:noUpdateBtn];
     } else if ([fileManager fileExistsAtPath:sileoPath] && [fileManager fileExistsAtPath:cydiaPath]) {
      [alertCheckForUpdate addAction:yesCydiaUpdateBtn];
      [alertCheckForUpdate addAction:yesSileoUpdateBtn];
      [alertCheckForUpdate addAction:noUpdateBtn];
     } else {
      [alertCheckForUpdate addAction:noUpdateBtn];
     }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self presentViewController:alertCheckForUpdate animated:YES completion:nil];
    });
  }
}

- (void) ldRunCheck {
  if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/ldRun"]){
    setuid(0);
    setgid(0);
    run_cmd("ldRun");
  } else {
    UIAlertController *alertMissingLD = [UIAlertController alertControllerWithTitle:@"Unable to ldrestart" message:@"Your device is missing the \"ldRun\" package (com.midnightchips.ldrun) to run \"ldrestart\" successfully.\n\nChange Respring setting to the \"killall\" option and respring?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *noLDBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    UIAlertAction *yesLDBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
      [preferences setInteger:0 forKey:@"btnControl"];
      [preferences synchronize];
      run_cmd("killall -9 SpringBoard");
    }];
    [alertMissingLD addAction:noLDBtn1];
    [alertMissingLD addAction:yesLDBtn1];
    [self presentViewController:alertMissingLD animated:YES completion:nil];
  }

}

- (void) sbreloadCheck {
  UIAlertController *alertMissingSBRELOAD;
  if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/sbreload"]){
    run_cmd("sbreload");
  } else {
    alertMissingSBRELOAD = [UIAlertController alertControllerWithTitle:@"Unable to sbreload" message:@"Your device is missing the \"sbreload\" command to run successfully.\n\nChange Respring setting to the \"killall\" option and respring?" preferredStyle:UIAlertControllerStyleAlert];
  }
  UIAlertAction *noSBBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
  UIAlertAction *yesSBBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:0 forKey:@"btnControl"];
    [preferences synchronize];
    run_cmd("killall -9 SpringBoard");
  }];
  [alertMissingSBRELOAD addAction:noSBBtn1];
  [alertMissingSBRELOAD addAction:yesSBBtn1];
  [self presentViewController:alertMissingSBRELOAD animated:YES completion:nil];
  return;
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}
@end
