//
//  AppDelegate.m
//  PowerApp
//
//  Modified by David Teddy, II on 6/25/2020.
//  Copyright © 2014-2020 David Teddy, II (Dave1482). All rights reserved.
//

#import "AppDelegate.h"
#include <stdio.h>
#include <stdlib.h>
#include <spawn.h>
#include <dlfcn.h>

#define _POSIX_SPAWN_DISABLE_ASLR 0x0100
#define _POSIX_SPAWN_ALLOW_DATA_EXEC 0x2000
extern char **environ;

@interface AppDelegate ()

@end

@implementation AppDelegate

void run_action(char *cmd)
{
    
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

- (void)rebootActionPressed {
    long rebootControlValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"rebootControl"];
    switch (rebootControlValue) {
        case 0:
            setuid(0);
            setgid(0);
            run_action("kill 1");
            break;
        case 1:
            run_action("launchctl reboot userspace");
            break;
        default:
            run_action("launchctl reboot userspace");
        break;
    }
}

- (void)shutdownActionPressed {
    setuid(0);
    setgid(0);
    run_action("halt");
}

- (void)respringActionPressed {
    long btnControlValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"];
    switch (btnControlValue) {
        case 0:
            run_action("killall -9 SpringBoard");
            break;
        case 1:
            [self sbreloadCheck];
            break;
        case 2:
            [self ldRunCheck];
            break;
        default:
            run_action("killall -9 SpringBoard");
        break;
    }
}

- (void)safeModeActionPressed {
    run_action("killall -SEGV SpringBoard");
}

- (void) ldRunCheck {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/ldRun"]){
        setuid(0);
        setgid(0);
        run_action("ldRun");
    } else {
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setInteger:0 forKey:@"btnControl"];
        [preferences synchronize];
        run_action("killall -9 SpringBoard");
    }
    return;
}

- (void) sbreloadCheck {
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/usr/bin/sbreload"]){
        run_action("sbreload");
    } else {
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setInteger:0 forKey:@"btnControl"];
        [preferences synchronize];
        run_action("killall -9 SpringBoard");
    }
    return;
}


- (BOOL)handleShortCutItem:(UIApplicationShortcutItem *)shortcutItem {
    BOOL nahhh = NO;
    NSString *shortcutString = shortcutItem.type;
    if (shortcutItem == nil) {
        return nahhh;
    }
    if ([shortcutString isEqualToString:@"com.dave1482.powerapp.Reboot"]) {
        [self rebootActionPressed];
        nahhh = YES;
    }
    if ([shortcutString isEqualToString:@"com.dave1482.powerapp.Shutdown"]) {
        [self shutdownActionPressed];
        nahhh = YES;
    }
    if ([shortcutString isEqualToString:@"com.dave1482.powerapp.Respring"]) {
        [self respringActionPressed];
        nahhh = YES;
    }
    if ([shortcutString isEqualToString:@"com.dave1482.powerapp.SafeMode"]) {
        [self safeModeActionPressed];
        nahhh = YES;
    }
    return nahhh;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL succeeded))completionHandler {
    [self handleShortCutItem:shortcutItem];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
