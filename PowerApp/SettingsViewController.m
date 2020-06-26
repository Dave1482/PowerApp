//
//  SettingsViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 6/25/2020.
//  Copyright © 2014-2020 David Teddy, II (Dave1482). All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize navBar;
@synthesize settingsTable;
@synthesize alertSwitch;
@synthesize lightSwitch;
@synthesize btnSwitchControl;

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (NSString *)informationOf:(NSString *) req{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *devicesPlistPath = [[NSBundle mainBundle] pathForResource:@"devices" ofType:@"plist"];
    NSString *amIBeta = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    NSString *keyString;
    if ([amIBeta containsString:@"beta"]){
        keyString = @"CFBundleVersion";
    } else {
        keyString = @"CFBundleShortVersionString";
    }
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:keyString];
    NSDictionary *iOSDevices = [NSDictionary dictionaryWithContentsOfFile:devicesPlistPath];
    NSString* deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString* deviceModelKey = [iOSDevices valueForKey:deviceModel];
    if (deviceModelKey == nil){
        deviceModelKey = deviceModel;
    }
    NSString* iOSVersion = [[UIDevice currentDevice] systemVersion];
    NSString *info = [NSString stringWithFormat:@"%@, iOS %@\n PowerApp %@", deviceModelKey, iOSVersion, appVersion];
    NSString *appVersionString = [NSString stringWithFormat:@"%@", appVersion];
    NSString *versionString = [NSString stringWithFormat:@"%@", iOSVersion];
    NSString *deviceString = [NSString stringWithFormat:@"%@", deviceModelKey];
    if ([req isEqualToString:@"all"]) {
        return info;
    } else if ([req isEqualToString:@"app"]){
        return appVersionString;
    } else if ([req isEqualToString:@"ios"]) {
        return versionString;
    } else if ([req isEqualToString:@"dev"]) {
        return deviceString;
    } else {
        return @"Nice try buddy";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    lightSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    alertSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [lightSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"]];
    [alertSwitch setOn:[[NSUserDefaults standardUserDefaults] boolForKey:@"alertSwitch.enabled"]];
    settingsTable.delegate = self;
    settingsTable.dataSource = self;

    if(lightSwitch.on){
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        }
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    } else {
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
        }
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    [btnSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Settings";
            break;
        case 1:
            return @"Information";
            break;
        default:
            return nil;
            break;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SwitchCell";
    [settingsTable registerClass:UITableViewCell.self forCellReuseIdentifier:cellID];
        
    if ([indexPath section] == 0) {
        if ( [indexPath row] == 0 ){
            respringCell = [settingsTable dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            respringCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            btnSwitchControl = [[UISegmentedControl alloc] initWithItems:@[@"killall", @"sbreload", @"ldrestart"]];
            respringCell.selectionStyle = UITableViewCellSelectionStyleNone;
            respringCell.textLabel.text = @"Respring:";
            respringCell.accessoryView = btnSwitchControl;
            [btnSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"]];
            [btnSwitchControl addTarget:self action:@selector(btnSwitchControlSelected) forControlEvents:UIControlEventValueChanged];
            return respringCell;
        } else if ( [indexPath row] == 1) {
            lightCell = [settingsTable dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            lightCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            lightCell.textLabel.text = @"Light Theme";
            lightCell.selectionStyle = UITableViewCellSelectionStyleNone;
            lightCell.accessoryView = lightSwitch;
            [lightSwitch addTarget:self action:@selector(lightSwitchSwitched) forControlEvents:UIControlEventValueChanged];
            return lightCell;
        } else if ( [indexPath row] == 2) {
            alertCell = [settingsTable dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            alertCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            alertCell.textLabel.text = @"Alerts";
            alertCell.selectionStyle = UITableViewCellSelectionStyleNone;
            alertCell.accessoryView = alertSwitch;
            [alertSwitch addTarget:self action:@selector(alertSwitchSwitched) forControlEvents:UIControlEventValueChanged];
            return alertCell;
        }
    } else if ([indexPath section] == 1) {
        if ( [indexPath row] == 0 ){
            appVersionCell = [settingsTable dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            appVersionLabel = [[UILabel alloc] init];
            appVersionLabel.text = [self informationOf:@"app"];
            [appVersionLabel sizeToFit];
            appVersionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            appVersionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            appVersionCell.textLabel.text = @"App Version:";
            appVersionCell.accessoryView = appVersionLabel;
            return appVersionCell;
        } else if ( [indexPath row] == 1) {
            versionCell = [settingsTable dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            versionLabel = [[UILabel alloc] init];
            versionLabel.text = [self informationOf:@"ios"];
            [versionLabel sizeToFit];
            versionCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            versionCell.textLabel.text = @"iOS Version:";
            versionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            versionCell.accessoryView = versionLabel;
            return versionCell;
        } else if ( [indexPath row] == 2) {
            deviceCell = [settingsTable dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
            deviceLabel = [[UILabel alloc] init];
            deviceLabel.text = [self informationOf:@"dev"];
            [deviceLabel sizeToFit];
            deviceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            deviceCell.textLabel.text = @"Device Model:";
            deviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
            deviceCell.accessoryView = deviceLabel;
            return deviceCell;
        }
    }
    return nil;
}


- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
    NSLog( @"The switch is %@", switchControl.on ? @"ON" : @"OFF" );
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
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:NO forKey:@"lightSwitch"];
        [preferences synchronize];
    }
}

- (IBAction)btnSwitchControlSelected {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    NSLog(@"%li", (long)btnSwitchControl.selectedSegmentIndex);
    [preferences setInteger:btnSwitchControl.selectedSegmentIndex forKey:@"btnControl"];
    [preferences synchronize];
}

- (IBAction)showDevInfo{
    UIAlertController *devAlert = [UIAlertController alertControllerWithTitle:@"Developer Information" message:@"Dave1482\nWebsite: https://dave1482.com/\nProject Page: https://dave1482.com/projects/powerapp/\nRepo: https://repo.dave1482.com/\nEmail: dave1482@dave1482.com\n\nCopyright © 2014-2020" preferredStyle:UIAlertControllerStyleAlert];
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
}
    

@end
