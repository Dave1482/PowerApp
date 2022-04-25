//
//  ViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 4/24/2022.
//  Copyright © Since 2014 David Teddy, II (Dave1482). All rights reserved.
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

NSString *cydiaPath = @"/Applications/Cydia.app/Cydia";
NSString *sileoPath = @"/Applications/Sileo.app/Info.plist";
NSString *zebraPath = @"/Applications/Zebra.app/Info.plist";
NSString *installerPath = @"/Applications/Installer.app/Info.plist";

#define _POSIX_SPAWN_DISABLE_ASLR 0x0100
#define _POSIX_SPAWN_ALLOW_DATA_EXEC 0x2000

extern char **environ;
char *rebootChar;
char *shutdownChar;
char *ldRunChar;
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
  return UIBarPositionTopAttached;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  customRedBorderColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1];
  customGreenBorderColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1];
  customBlueBorderColor = [UIColor colorWithRed:0.0 green:123.0/256.0 blue:1.0 alpha:1];
  
  [self colorMe];
  
  rebootButton.layer.cornerRadius = 15;
  shutdownButton.layer.cornerRadius = 15;
  softRebootButton.layer.cornerRadius = 15;
  respringButton.layer.cornerRadius = 15;
  safeButton.layer.cornerRadius = 15;
  nonButton.layer.cornerRadius = 15;
  uicButton.layer.cornerRadius = 15;
  exitButton.layer.cornerRadius = 15;
  respringButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  safeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  nonButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  uicButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  softRebootButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  exitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  NSArray *jbCheck = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/etc" error:nil];
  NSString *etcItem;
  NSString *jbItem;
  for (etcItem in jbCheck)
  {
      if ([etcItem containsString:@".installed-chimera"]) {
        jbItem = etcItem;
        break;
      } else {
        jbItem = @"noChimera";
      }
  }
  if ([[NSFileManager defaultManager] fileExistsAtPath:@"/odyssey/jailbreakd.plist"] ||
      [[NSFileManager defaultManager] fileExistsAtPath:@"/taurine/jailbreakd.plist"] ||
      [[NSFileManager defaultManager] fileExistsAtPath:@"/chimera/jailbreakd.plist"]
      ){
    [softRebootButton setTitle:@"Soft\nReboot" forState:UIControlStateNormal];
  } else {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/.installed_odyssey"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"/etc/%@", jbItem]] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/.bootstrapped_electra"]
        ){
          [softRebootButton setTitle:@"ldRun" forState:UIControlStateNormal];
        } else {
          [softRebootButton setTitle:@"Soft\nReboot" forState:UIControlStateNormal];
        }
  }
  
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
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  if([prefs objectForKey:@"didFirstLaunch"] && [prefs boolForKey:@"didFirstLaunch"] == YES) {
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
  } else {
    [prefs setBool:YES forKey:@"didFirstLaunch"];
    [prefs synchronize];
    [self showInfo];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorMe) name:NSUserDefaultsDidChangeNotification object:nil];
}

void run_cmd(char *cmd)
{
  rebootChar = "kill 1";
  shutdownChar = "halt";
  ldRunChar = "ldRun";
  
  // UNTESTED BEGIN
  if (strcmp(cmd, rebootChar) || strcmp(cmd, shutdownChar) || strcmp(cmd, ldRunChar)) {
    setgid(0);
    setuid(0);
  } else {
    setgid(501);
    setuid(501);
  }
  // UNTESTED END
  /* ORIGINAL BEGIN
  if (cmd != rebootChar && cmd != shutdownChar && cmd != ldRunChar) {
    setgid(501);
    setuid(501);
  }
     ORIGINAL END */
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

- (void)showInfo {
    NSString *info;
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/odyssey/jailbreakd.plist"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/taurine/jailbreakd.plist"] ||
        [[NSFileManager defaultManager] fileExistsAtPath:@"/chimera/jailbreakd.plist"]
        ){
          info = @"\nPLEASE READ!!\n\nTo show this information again, press the top right button in either Settings or Changelog\n\nReboot:\nFully reboots your device\n\nShutdown:\nFully powers off your device\n\nSoft Reboot (not available on old\nversions of Chimera or Odyssey):\nReboots everything but the kernel and should preserve the jailbreak\n\nldRun (only on old versions of Chimera and Odyssey):\nResprings with \"ldrestart\"\n\nSafe Mode:\nResprings into safe mode if MobileSubstrate is installed\n\nNon-Substrate Mode (Only for MobileSubstrate):\nIf not in safe mode, your device will respring into safe mode.\nIf the device is already in safe mode, it will respring into Non-MobileSubstrate Mode.\n\nRefresh Cache:\nReloads the home screen with \"uicache\"\n\nMore information in the Developer section of the Settings page";
    } else {
      if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"]){
        info = @"\nPLEASE READ!!\n\nTo show this information again, press the top right button in either Settings or Changelog\n\nReboot:\nFully reboots your device\n\nShutdown:\nFully powers off your device\n\nSoft Reboot (not available on old\nversions of Chimera or Odyssey):\nReboots everything but the kernel and should preserve the jailbreak\n\nldRun (only on old versions of Chimera and Odyssey):\nResprings with \"ldrestart\"\n\nSafe Mode:\nResprings into safe mode if MobileSubstrate is installed\n\nNon-Substrate Mode (Only for MobileSubstrate):\nIf not in safe mode, your device will respring into safe mode.\nIf the device is already in safe mode, it will respring into Non-MobileSubstrate Mode.\n\nRefresh Cache:\nReloads the home screen with \"uicache\"\n\nMore information in the Developer section of the Settings page";
      } else {
        info = @"\nPLEASE READ!!\n\nTo show this again, press the top right button in Settings or Changelog\n\nReboot:\nFully reboots your device\n\nShutdown:\nFully powers off your device\n\nSoft Reboot (not available on old\nversions of Chimera or Odyssey):\nReboots everything but the kernel and should preserve the jailbreak\n\nldRun (only on Chimera and Odyssey):\nResprings with \"ldrestart\"\n\nSubstrate Safe Mode:\nResprings into safe mode if MobileSubstrate is installed, or the device will just respring.\n\nSubstitute Safe Mode: Resprings into Safe Mode\n\nRefresh Cache:\nReloads the home screen with \"uicache\"\n\nExit PowerApp:\nCloses PowerApp\n\nMore information in the Developer section in Settings";
      }
    }
    UIAlertController *infoAlert = [UIAlertController alertControllerWithTitle:@"Thank You For Using\nPowerApp!" message:info preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneDevBtn = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
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
      }];
    [infoAlert addAction:doneDevBtn];
  dispatch_async(dispatch_get_main_queue(), ^{
    [self presentViewController:infoAlert animated:YES completion:nil];
  });
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
  if ([softRebootButton.titleLabel.text isEqualToString:@"ldRun"]){
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
      if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/ldRun"]){
        UIAlertController *alertRespringBtn1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will run ldRun to ldrestart your device. This will stop all apps!\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noRespringBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        UIAlertAction *yesRespringBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
          setuid(0);
          setgid(0);
          run_cmd("ldRun");
        }];
        [alertRespringBtn1 addAction:noRespringBtn1];
        [alertRespringBtn1 addAction:yesRespringBtn1];
        [self presentViewController:alertRespringBtn1 animated:YES completion:nil];
      } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        UIAlertController *alertMissingLD = [UIAlertController alertControllerWithTitle:@"Unable to ldrestart" message:@"Your device is missing the \"ldRun\" package (com.midnightchips.ldrun) to run \"ldrestart\" successfully.\n\nRespring with \"killall\" or open a package manager?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yesCydiaPkgBtn = [UIAlertAction actionWithTitle:@"Cydia" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"cydia://url/https://cydia.saurik.com/api/share#?source=https://repo.packix.com/&package=com.midnightchips.ldrun"] options:@{} completionHandler:nil];
        }];
        UIAlertAction *yesSileoPkgBtn = [UIAlertAction actionWithTitle:@"Sileo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"sileo://package/com.midnightchips.ldrun"] options:@{} completionHandler:nil];
        }];
        UIAlertAction *yesZebraPkgBtn = [UIAlertAction actionWithTitle:@"Zebra" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"zbra://packages/com.midnightchips.ldrun"] options:@{} completionHandler:nil];
        }];
        UIAlertAction *yesInstallerPkgBtn = [UIAlertAction actionWithTitle:@"Installer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"installer://show/bundleid=com.midnightchips.ldrun"] options:@{} completionHandler:nil];
        }];
        UIAlertAction *yesLDBtn1 = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
          run_cmd("killall -9 SpringBoard");
        }];
        UIAlertAction *noLDBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        if ([fileManager fileExistsAtPath:cydiaPath]) {
          [alertMissingLD addAction:yesCydiaPkgBtn];
        }
        if ([fileManager fileExistsAtPath:sileoPath]) {
          [alertMissingLD addAction:yesSileoPkgBtn];
        }
        if ([fileManager fileExistsAtPath:zebraPath]) {
          [alertMissingLD addAction:yesZebraPkgBtn];
        }
        if ([fileManager fileExistsAtPath:installerPath]) {
          [alertMissingLD addAction:yesInstallerPkgBtn];
        }
        [alertMissingLD addAction:yesLDBtn1];
        [alertMissingLD addAction:noLDBtn1];
        [self presentViewController:alertMissingLD animated:YES completion:nil];
      }
    } else {
      [self ldRunButtonCheck];
    }
  } else {
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
  // UNTESTED BEGIN
  long btnControlValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"];
  switch (btnControlValue)
    {
      case 0:
        [respringButton setTitle:@"Respring\n(\"killall\")" forState:UIControlStateNormal];
        break;
      case 1:
        [respringButton setTitle:@"Respring\n(\"sbreload\")" forState:UIControlStateNormal];
        break;
      case 2:
        [respringButton setTitle:@"Respring\n(\"ldrestart\")" forState:UIControlStateNormal];
        break;
      default:
        [respringButton setTitle:@"Respring" forState:UIControlStateNormal];
        break;
    }
  // UNTESTED END
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
  NSString *deviceType = [UIDevice currentDevice].model;
  UIAlertController *alertCheckForUpdate;
  NSString *alertMessage;
  
  if (![receivedDataString isEqual:leInfo] && ![receivedDataString isEqual: @""])
  {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    UIAlertAction *yesCydiaUpdateBtn = [UIAlertAction actionWithTitle:@"Cydia" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"cydia://sources"] options:@{} completionHandler:nil];
    }];
    UIAlertAction *yesSileoUpdateBtn = [UIAlertAction actionWithTitle:@"Sileo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"sileo:///"] options:@{} completionHandler:nil];
    }];
    UIAlertAction *yesZebraUpdateBtn = [UIAlertAction actionWithTitle:@"Zebra" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"zbra:///"] options:@{} completionHandler:nil];
    }];
    UIAlertAction *yesInstallerUpdateBtn = [UIAlertAction actionWithTitle:@"Installer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"installer:///"] options:@{} completionHandler:nil];
    }];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    if ([fileManager fileExistsAtPath:sileoPath] || [fileManager fileExistsAtPath:cydiaPath] || [fileManager fileExistsAtPath:zebraPath] || [fileManager fileExistsAtPath:installerPath]) {
      alertMessage = [NSString stringWithFormat:@"PowerApp v%@\nAvailable!", receivedDataString];
    } else {
      alertMessage = [NSString stringWithFormat:@"PowerApp v%@\nis available but for some reason you don't have Sileo or Cydia.", receivedDataString];
    }
    if([deviceType isEqualToString:@"iPad"]) {
    alertCheckForUpdate = [UIAlertController alertControllerWithTitle:@"New Update Available" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    } else {
      alertCheckForUpdate = [UIAlertController alertControllerWithTitle:@"New Update Available" message:alertMessage preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    if ([fileManager fileExistsAtPath:cydiaPath]) {
      [alertCheckForUpdate addAction:yesCydiaUpdateBtn];
    }
    if ([fileManager fileExistsAtPath:sileoPath]) {
      [alertCheckForUpdate addAction:yesSileoUpdateBtn];
    }
    if ([fileManager fileExistsAtPath:zebraPath]) {
      [alertCheckForUpdate addAction:yesZebraUpdateBtn];
    }
    if ([fileManager fileExistsAtPath:installerPath]) {
      [alertCheckForUpdate addAction:yesInstallerUpdateBtn];
    }
    [alertCheckForUpdate addAction:cancelBtn];

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

- (void) ldRunButtonCheck {
  if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/ldRun"]){
    setuid(0);
    setgid(0);
    run_cmd("ldRun");
  } else {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    UIAlertController *alertMissingLD = [UIAlertController alertControllerWithTitle:@"Unable to ldrestart" message:@"Your device is missing the \"ldRun\" package (com.midnightchips.ldrun) to run \"ldrestart\" successfully.\n\nRespring with \"killall\" or open a package manager?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesCydiaPkgBtn = [UIAlertAction actionWithTitle:@"Cydia" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"cydia://url/https://cydia.saurik.com/api/share#?source=https://repo.packix.com/&package=com.midnightchips.ldrun"] options:@{} completionHandler:nil];
    }];
    UIAlertAction *yesSileoPkgBtn = [UIAlertAction actionWithTitle:@"Sileo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"sileo://package/com.midnightchips.ldrun"] options:@{} completionHandler:nil];
    }];
    UIAlertAction *yesZebraPkgBtn = [UIAlertAction actionWithTitle:@"Zebra" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"zbra://packages/com.midnightchips.ldrun"] options:@{} completionHandler:nil];
    }];
    UIAlertAction *yesInstallerPkgBtn = [UIAlertAction actionWithTitle:@"Installer" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"installer://show/bundleid=com.midnightchips.ldrun"] options:@{} completionHandler:nil];
    }];
    UIAlertAction *yesLDBtn1 = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
      run_cmd("killall -9 SpringBoard");
    }];
    UIAlertAction *noLDBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    if ([fileManager fileExistsAtPath:cydiaPath]) {
      [alertMissingLD addAction:yesCydiaPkgBtn];
    }
    if ([fileManager fileExistsAtPath:sileoPath]) {
      [alertMissingLD addAction:yesSileoPkgBtn];
    }
    if ([fileManager fileExistsAtPath:zebraPath]) {
      [alertMissingLD addAction:yesZebraPkgBtn];
    }
    if ([fileManager fileExistsAtPath:installerPath]) {
      [alertMissingLD addAction:yesInstallerPkgBtn];
    }
    [alertMissingLD addAction:yesLDBtn1];
    [alertMissingLD addAction:noLDBtn1];
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
