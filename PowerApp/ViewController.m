
//
//  ViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 8/12/2018.
//  Copyright © 2014-2018 David Teddy, II. All rights reserved.
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
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        navBar.barTintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
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
        UIAlertView *alertRebootButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will REBOOT your system.\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertRebootButton1 setTag:1];
        [alertRebootButton1 show];
    } else {
        setuid(0);
        setgid(0);
        run_cmd("kill 1");
        
    }

}

- (IBAction)shutdownButtonPressed {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
        UIAlertView *alertShutdownButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will SHUTDOWN your system.\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertShutdownButton1 setTag:2];
        [alertShutdownButton1 show];
    } else {
        setuid(0);
        setgid(0);
        run_cmd("halt");
    }

}

- (IBAction)respringButtonPressed {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
        UIAlertView *alertRespringButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will Respring your system. This will stop all apps!\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertRespringButton1 setTag:3];
        [alertRespringButton1 show];
    } else {
        run_cmd("killall -9 SpringBoard");
    }
}

- (IBAction)safeModeButtonPressed {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
        UIAlertView *alertSafemodeButton1;
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"]){
            alertSafemodeButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will only respring your device since you have substrate. This will stop all apps!\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        } else {
            alertSafemodeButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will put your system into Safemode. This will stop all apps!\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        }
        [alertSafemodeButton1 setTag:4];
        [alertSafemodeButton1 show];
    } else {
        run_cmd("touch /var/mobile/Library/Preferences/com.saurik.mobilesubstrate.dat; killall SpringBoard");
    }
}

- (IBAction)nonMobileSubstrateModeButtonPressed {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
        UIAlertView *alertNoSubstrateButton1;
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/lib/libsubstitute.dylib"]){
            alertNoSubstrateButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Using this will put it into Non-Substitute Mode (aka Safe Mode)!\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        } else {
            alertNoSubstrateButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"Using this in Safemode will put it into Non-MobileSubstrate Mode. Any other mode will put it into Safemode This will kill all processes!\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        }
        [alertNoSubstrateButton1 setTag:5];
        [alertNoSubstrateButton1 show];
    } else {
        run_cmd("killall -SEGV SpringBoard");
    }
}

- (IBAction)refreshCacheButtonPressed {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
        UIAlertView *alertMinispringButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This refreshes the SpringBoard so you can see your new apps without respringing. This will temporarily freeze your Home Screen (Exit this app after this is complete)!\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertMinispringButton1 setTag:6];
        [alertMinispringButton1 show];
    } else {

        run_cmd("uicache");
        
    }
}

- (IBAction)lockButtonPressed {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"] == YES){
        UIAlertView *alertLockButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This only locks your device. Great if you want to save your power button.\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertLockButton1 setTag:7];
        [alertLockButton1 show];
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
        UIAlertView *alertExitButton1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This only kills PowerApp. Great if you want to save your home button.\n\nContinue?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertExitButton1 setTag:8];
        [alertExitButton1 show];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1){
        if(buttonIndex == 1){
            setuid(0);
            setgid(0);
            run_cmd("kill 1");
        }
    }
    if(alertView.tag == 2){
        if(buttonIndex == 1){
            setuid(0);
            setgid(0);
            run_cmd("halt");
        }
    }
    if(alertView.tag == 3){
        if(buttonIndex == 1){
            run_cmd("killall -9 SpringBoard");
        }
    }
    if(alertView.tag == 4){
        if(buttonIndex == 1){
            run_cmd("touch /var/mobile/Library/Preferences/com.saurik.mobilesubstrate.dat; killall SpringBoard");
        }
    }
    if(alertView.tag == 5){
        if(buttonIndex == 1){
            run_cmd("killall -SEGV SpringBoard");
        }
    }
    if(alertView.tag == 6){
        if(buttonIndex == 1){
            run_cmd("uicache");
        }
    }
    if(alertView.tag == 7){
        if(buttonIndex == 1){
            char *gsDylib = "/System/Library/PrivateFrameworks/GraphicsServices.framework/GraphicsServices";
            void *handle = dlopen(gsDylib, RTLD_NOW);
            if (handle) {
                
                void (*_GSEventLockDevice)(void) = dlsym(handle, "GSEventLockDevice");
                if (_GSEventLockDevice)  {
                    _GSEventLockDevice();
                    
                }
                dlclose(handle);
                
            }
            run_cmd("/Applications/PowerApp.app/PowerAppLock64");
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch.enabled"] == YES){
                abort();
            }
        }
    }
    if(alertView.tag == 8){
        if(buttonIndex == 1){
            abort();
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
