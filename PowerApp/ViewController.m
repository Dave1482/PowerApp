
//
//  ViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 8/12/2018.
//  Copyright © 2014-2019 David Teddy, II. All rights reserved.
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
@synthesize safeButton;
@synthesize nonButton;

#define _POSIX_SPAWN_DISABLE_ASLR 0x0100
#define _POSIX_SPAWN_ALLOW_DATA_EXEC 0x2000
extern char **environ;
- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"]){
        [safeButton setTitle:@"MobileSubstrate Safe Mode" forState:UIControlStateNormal];
        [nonButton setTitle:@"Substitute Safe Mode" forState:UIControlStateNormal];
    }
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    } else {
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorMe) name:NSUserDefaultsDidChangeNotification object:nil];
}

void run_cmd(char *cmd)
{
    
    pid_t pid;
    char *argv[] = {"sh", "-c", cmd, NULL};
    int status;
    printf("Run command: %s\n", cmd);
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

- (IBAction)respringButtonPressed {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
        UIAlertController *alertRespringBtn1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will Respring your device. This will stop all apps!\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noRespringBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        UIAlertAction *yesRespringBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            run_cmd("killall -9 SpringBoard");
        }];
        [alertRespringBtn1 addAction:noRespringBtn1];
        [alertRespringBtn1 addAction:yesRespringBtn1];
        [self presentViewController:alertRespringBtn1 animated:YES completion:nil];
    } else {
        run_cmd("killall -9 SpringBoard");
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
            run_cmd("uicache");
        }];
        [alertRefreshButton1 addAction:noRefreshBtn1];
        [alertRefreshButton1 addAction:yesRefreshBtn1];
        [self presentViewController:alertRefreshButton1 animated:YES completion:nil];
    } else {

        run_cmd("uicache");
        
    }
}

- (IBAction)lockButtonPressed {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
        UIAlertController *alertLockButton1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This only locks your device. Great if you want to save your power button.\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noLockBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        UIAlertAction *yesLockBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            char *gsDylib = "/System/Library/PrivateFrameworks/GraphicsServices.framework/GraphicsServices";
            void *handle = dlopen(gsDylib, RTLD_NOW);
            if (handle) {
                
                void (*_GSEventLockDevice)(void) = dlsym(handle, "GSEventLockDevice");
                if (_GSEventLockDevice)  {
                    _GSEventLockDevice();
                    
                }
                dlclose(handle);
                
            }
            run_cmd("/Applications/PowerApp.app/PowerAppLock");
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch.enabled"] == YES){
                abort();
            }
        }];
        [alertLockButton1 addAction:noLockBtn1];
        [alertLockButton1 addAction:yesLockBtn1];
        [self presentViewController:alertLockButton1 animated:YES completion:nil];
    } else {
        char *gsDylib = "/System/Library/PrivateFrameworks/GraphicsServices.framework/GraphicsServices";
        void *handle = dlopen(gsDylib, RTLD_NOW);
        if (handle) {
            
            void (*_GSEventLockDevice)(void) = dlsym(handle, "GSEventLockDevice");
            if (_GSEventLockDevice)  {
                _GSEventLockDevice();
                
            }
            dlclose(handle);
            
        }
        run_cmd("/Applications/PowerApp.app/PowerAppLock");
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch.enabled"] == YES){
            abort();
        }

    }
}

- (IBAction)exitButtonPressed {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
        UIAlertController *alertExitButton1 = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This only kills PowerApp. Great if you want to save your home button.\n\nContinue?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noExitBtn1 = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        UIAlertAction *yesExitBtn1 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            abort();
        }];
        [alertExitButton1 addAction:noExitBtn1];
        [alertExitButton1 addAction:yesExitBtn1];
        [self presentViewController:alertExitButton1 animated:YES completion:nil];

    } else {
        abort();
    }
}

- (void)colorMe {
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
