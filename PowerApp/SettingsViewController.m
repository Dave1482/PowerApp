//
//  SettingsViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 8/12/2018.
//  Copyright © 2014-2019 David Teddy, II. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize navBar;
@synthesize alertSwitch;
@synthesize lightSwitch;
@synthesize lockSwitch;
@synthesize alertLabel;
@synthesize lightLabel;
@synthesize lockLabel;

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [alertSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"]];
    [lockSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"lockSwitch.enabled"]];
    [lightSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"]];
    if(lightSwitch.on){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        navBar.barTintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        lightLabel.textColor = [UIColor blackColor];
        alertLabel.textColor = [UIColor blackColor];
        lockLabel.textColor = [UIColor blackColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        navBar.barTintColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        lightLabel.textColor = [UIColor whiteColor];
        alertLabel.textColor = [UIColor whiteColor];
        lockLabel.textColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    navBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    lightLabel.textColor = [UIColor blackColor];
    alertLabel.textColor = [UIColor blackColor];
    lockLabel.textColor = [UIColor blackColor];
    //[navBar setBarStyle:UIBarStyleDefault];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:YES forKey:@"lightSwitch"];
    [preferences synchronize];
} else {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    navBar.barTintColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor blackColor];
    lightLabel.textColor = [UIColor whiteColor];
    alertLabel.textColor = [UIColor whiteColor];
    lockLabel.textColor = [UIColor whiteColor];
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

- (IBAction)showDevInfo{
    [[[UIAlertView alloc] initWithTitle:@"Developer Information" message:@"Dave1482\nWebsite: http://dave1482.com/\nProject Page: http://dave1482.com/projects/powerapp/\nRepo: http://repo.dave1482.com/\nEmail: dave1482@dave1482.com\n\nCopyright © 2014-2019" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
}

- (IBAction)dismissSettingsViewController {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
