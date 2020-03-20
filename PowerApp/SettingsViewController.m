//
//  SettingsViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 2/20/2020.
//  Copyright © 2014-2020 David Teddy, II (Dave1482). All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize navBar;
@synthesize alertSwitch;
@synthesize lightSwitch;
@synthesize lockSwitch;
@synthesize infoSwitch;
@synthesize btnSwitchControl;
@synthesize alertLabel;
@synthesize lightLabel;
@synthesize lockLabel;
@synthesize showInfoLabel;
@synthesize infoLabel;
@synthesize btnSwitchLabel;

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

NSString *deviceAndAppInfo()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *devicesPlistPath = [[NSBundle mainBundle] pathForResource:@"devices" ofType:@"plist"];
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *iOSDevices = [NSDictionary dictionaryWithContentsOfFile:devicesPlistPath];
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString* deviceModelKey = [iOSDevices valueForKey:deviceModel];
    if (deviceModelKey == nil){
        deviceModelKey = deviceModel;
    }
    NSString* iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *info = [NSString stringWithFormat:@"%@, iOS %@\n PowerApp %@", deviceModelKey, iOSVersion, appVersion];
    
    return info;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [alertSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"]];
    [lockSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch.enabled"]];
    [infoSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"infoSwitch.enabled"]];
    [lightSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"]];
    if(infoSwitch.on){
        infoLabel.hidden = NO;
        
    } else {
        infoLabel.hidden = YES;
    }
    infoLabel.text = deviceAndAppInfo();
    if(lightSwitch.on){
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        }
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        lightLabel.textColor = [UIColor blackColor];
        alertLabel.textColor = [UIColor blackColor];
        lockLabel.textColor = [UIColor blackColor];
        showInfoLabel.textColor = [UIColor blackColor];
        infoLabel.textColor = [UIColor blackColor];
        btnSwitchLabel.textColor = [UIColor blackColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    } else {
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
        }
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        lightLabel.textColor = [UIColor whiteColor];
        alertLabel.textColor = [UIColor whiteColor];
        lockLabel.textColor = [UIColor whiteColor];
        showInfoLabel.textColor = [UIColor whiteColor];
        infoLabel.textColor = [UIColor whiteColor];
        btnSwitchLabel.textColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    [btnSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"]];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)alertSwitchSwitched{
    if(alertSwitch.on){
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:YES forKey:@"alertSwitch.enabled"];
        [preferences synchronize];
    } else {
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:NO forKey:@"alertSwitch.enabled"];
        [preferences synchronize];
    }
}

- (IBAction)lightSwitchSwitched{
if(lightSwitch.on){
    if (@available(iOS 13, *)) {
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
    }
    [self setNeedsStatusBarAppearanceUpdate];
    navBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    lightLabel.textColor = [UIColor blackColor];
    alertLabel.textColor = [UIColor blackColor];
    lockLabel.textColor = [UIColor blackColor];
    showInfoLabel.textColor = [UIColor blackColor];
    infoLabel.textColor = [UIColor blackColor];
    btnSwitchLabel.textColor = [UIColor blackColor];
    //[navBar setBarStyle:UIBarStyleDefault];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:YES forKey:@"lightSwitch"];
    [preferences synchronize];
} else {
    if (@available(iOS 13, *)) {
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
    }
    [self setNeedsStatusBarAppearanceUpdate];
    navBar.barTintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    lightLabel.textColor = [UIColor whiteColor];
    alertLabel.textColor = [UIColor whiteColor];
    lockLabel.textColor = [UIColor whiteColor];
    showInfoLabel.textColor = [UIColor whiteColor];
    infoLabel.textColor = [UIColor whiteColor];
    btnSwitchLabel.textColor = [UIColor whiteColor];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:NO forKey:@"lightSwitch"];
    [preferences synchronize];
}
}

- (IBAction)lockSwitchSwitched{
    if(lockSwitch.on){
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:YES forKey:@"lockSwitch.enabled"];
        [preferences synchronize];
    } else {
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:NO forKey:@"lockSwitch.enabled"];
        [preferences synchronize];
    }
}

- (IBAction)infoSwitchSwitched{
    if(infoSwitch.on){
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:YES forKey:@"infoSwitch.enabled"];
        [preferences synchronize];
        infoLabel.hidden = NO;
    } else {
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:NO forKey:@"infoSwitch.enabled"];
        [preferences synchronize];
        infoLabel.hidden = YES;
    }
}

- (IBAction)btnSwitchControlSelected {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSLog(@"%li", (long)btnSwitchControl.selectedSegmentIndex);
    [preferences setInteger:btnSwitchControl.selectedSegmentIndex forKey:@"btnControl"];
    [preferences synchronize];
}

- (IBAction)showDevInfo{
    UIAlertController *devAlert = [UIAlertController alertControllerWithTitle:@"Developer Information" message:@"Dave1482\nWebsite: http://dave1482.com/\nProject Page: http://dave1482.com/projects/powerapp/\nRepo: https://repo.dave1482.com/\nEmail: dave1482@dave1482.com\n\nCopyright © 2014-2020" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneDevBtn = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [devAlert addAction:doneDevBtn];
    [self presentViewController:devAlert animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if(lightSwitch.on){
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

- (IBAction)dismissSettingsViewController {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
