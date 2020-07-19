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
@synthesize borderSwitchControl;
@synthesize rebootSwitchControl;
@synthesize iconControl;

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
    payIcon = [UIImage imageNamed:@"paypal"];
    twtIcon = [UIImage imageNamed:@"twitter"];
    devArray = [[NSMutableArray alloc] initWithObjects:@"https://paypal.me/DaveT1482", @"https://twitter.com/realDave1482", @"https://github.com/Dave1482/PowerApp/", @"https://powerapp.dave1482.com/", @"https://repo.dave1482.com/", nil];
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
        gitIcon = [UIImage imageNamed:@"githubBlack"];
    } else {
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
        }
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        gitIcon = [UIImage imageNamed:@"githubWhite"];
    }
    [btnSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"]];
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    if ([preferences integerForKey:@"iconSelect"]){
        selectedCell = (int)[preferences integerForKey:@"iconSelect"];
    } else {
        selectedCell = 0;
        [preferences setInteger:selectedCell forKey:@"iconSelect"];
        [preferences synchronize];
    }
    [borderSwitchControl setSelectedSegmentIndex:selectedCell];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (@available(iOS 10.3, *)) {
        return 4;
    } else {
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 3;
            break;
        case 2:
            if (@available(iOS 10.3, *)) {
            return 3;
            }
            return 6;
            break;
        case 3:
            if (@available (iOS 10.3, *)) {
                return 6;
            }
            return 0;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Settings";
            break;
        case 1:
            return @"Information";
            break;
        case 2:
            if (@available(iOS 10.3, *)) {
            return @"App Icon";
            }
            return @"Developer";
            break;
        case 3:
            if (@available(iOS 10.3, *)) {
                return @"Developer";
            }
            return nil;
        default:
            return nil;
            break;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (@available (iOS 10.3, *)){
        if([indexPath section] == 2){
            dispatch_async(dispatch_get_main_queue(), ^{
                self->selectedCell = (int)indexPath.row;
                [self->settingsTable reloadData];
                NSArray *nameArray = [NSArray arrayWithObjects:@"", @"outsetIcon", @"originalIcon", nil];
                if ([[UIApplication sharedApplication] supportsAlternateIcons]){
                    if (indexPath.row > 0){
                        [[UIApplication sharedApplication] setAlternateIconName:nameArray[indexPath.row] completionHandler:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog (@"Error changing icon: %@",error);
                            }
                        }];
                    } else {
                        [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog (@"Error changing icon: %@",error);
                            }
                        }];
                    }
                }
                
                NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
                [preferences setInteger:self->selectedCell forKey:@"iconSelect"];
                [preferences synchronize];
                NSMutableArray *projectIcon = [NSMutableArray arrayWithObjects:@"projInIcon", @"projOutIcon", @"projOrigIcon", nil];
                self->webIcon = [UIImage imageNamed:projectIcon[self->selectedCell]];
            });
        } else if ([indexPath section] == 3){
            NSString *devURLString = [NSString stringWithFormat:@"%@",[devArray objectAtIndex:indexPath.row]];
            NSLog(@"URLString: %@",devURLString.description);
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:devURLString] options:@{} completionHandler:nil];
        }
    } else if ([indexPath section] == 2){
        NSString *devURLString = [NSString stringWithFormat:@"%@",[devArray objectAtIndex:indexPath.row]];
        NSLog(@"URLString: %@",devURLString.description);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:devURLString] options:@{} completionHandler:nil];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 2){
        if (@available(iOS 10.3, *)){
            [settingsTable cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        } else {
            [settingsTable deselectRowAtIndexPath:indexPath animated:YES];
        }
    } else if ([indexPath section] == 3){
        [settingsTable deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (@available(iOS 10.3, *)) {
        if ( [indexPath section] == 2 ){
            return 84.0f;
        } else {
        return UITableViewAutomaticDimension;
        }
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"SwitchCell";
    static NSString *iconCellID = @"IconCell";
    [settingsTable registerClass:UITableViewCell.self forCellReuseIdentifier:cellID];
    [settingsTable registerClass:UITableViewCell.self forCellReuseIdentifier:iconCellID];
    cell = [settingsTable dequeueReusableCellWithIdentifier:cellID];
    iconCell = [settingsTable dequeueReusableCellWithIdentifier:iconCellID];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    iconCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iconCellID];
    iconCell.imageView.layer.cornerRadius = 12.0;
    iconCell.imageView.layer.masksToBounds = YES;
    
    iconCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    if ([indexPath section] == 0) {
        if ( [indexPath row] == 0 ){
            rebootSwitchControl = [[UISegmentedControl alloc] initWithItems:@[@"Full", @"Soft"]];
            cell.textLabel.text = @"Quick Action Reboot:";
            cell.accessoryView = rebootSwitchControl;
            [rebootSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"rebootControl"]];
            [rebootSwitchControl addTarget:self action:@selector(rebootSwitchControlSelected) forControlEvents:UIControlEventValueChanged];
            return cell;
        } else if ( [indexPath row] == 1 ){
            btnSwitchControl = [[UISegmentedControl alloc] initWithItems:@[@"killall", @"sbreload", @"ldrestart"]];
            cell.textLabel.text = @"Respring:";
            cell.accessoryView = btnSwitchControl;
            [btnSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"]];
            [btnSwitchControl addTarget:self action:@selector(btnSwitchControlSelected) forControlEvents:UIControlEventValueChanged];
            return cell;
        } else if ( [indexPath row] == 2 ){
            borderSwitchControl = [[UISegmentedControl alloc] initWithItems:@[@"None", @"Thin", @"Thick", @"THICC"]];
            cell.textLabel.text = @"Button Border:";
            cell.accessoryView = borderSwitchControl;
            [borderSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"borderControl"]];
            [borderSwitchControl addTarget:self action:@selector(borderSwitchControlSelected) forControlEvents:UIControlEventValueChanged];
            return cell;
        } else if ( [indexPath row] == 3) {
            cell.textLabel.text = @"Light Theme";
            cell.accessoryView = lightSwitch;
            [lightSwitch addTarget:self action:@selector(lightSwitchSwitched) forControlEvents:UIControlEventValueChanged];
            return cell;
        } else if ( [indexPath row] == 4) {
            cell.textLabel.text = @"Alerts";
            cell.accessoryView = alertSwitch;
            [alertSwitch addTarget:self action:@selector(alertSwitchSwitched) forControlEvents:UIControlEventValueChanged];
            return cell;
        }
    } else if ([indexPath section] == 1) {
        if ( [indexPath row] == 0 ){
            label = [[UILabel alloc] init];
            label.text = [self informationOf:@"app"];
            [label sizeToFit];
            cell.textLabel.text = @"App Version:";
            cell.accessoryView = label;
            return cell;
        } else if ( [indexPath row] == 1) {
            label = [[UILabel alloc] init];
            label.text = [self informationOf:@"ios"];
            [label sizeToFit];
            cell.textLabel.text = @"iOS Version:";
            cell.accessoryView = label;
            return cell;
        } else if ( [indexPath row] == 2) {
            label = [[UILabel alloc] init];
            label.text = [self informationOf:@"dev"];
            [label sizeToFit];
            cell.textLabel.text = @"Device Model:";
            cell.accessoryView = label;
            return cell;
        }
    } else if ([indexPath section] == 2){
        if ( @available(iOS 10.3, *)){
            if ( [indexPath row] == 0 ){
                iconCell.imageView.image = [UIImage imageNamed:@"insetIcon60x60"];
                iconCell.textLabel.text = @"Default";
                if([indexPath row] == selectedCell) {
                    iconCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    iconCell.selected = YES;
                } else {
                    iconCell.accessoryType = UITableViewCellAccessoryNone;
                    iconCell.selected = NO;
                }
                return iconCell;
            } else if ( [indexPath row] == 1 ){
                iconCell.imageView.image = [UIImage imageNamed:@"AltIcons/outsetIcon-60"];
                iconCell.textLabel.text = @"Light";
                if([indexPath row] == selectedCell) {
                    iconCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    iconCell.selected = YES;
                } else {
                    iconCell.accessoryType = UITableViewCellAccessoryNone;
                    iconCell.selected = NO;
                }
                return iconCell;
            } else if ( [indexPath row] == 2 ){
                iconCell.imageView.image = [UIImage imageNamed:@"AltIcons/originalIcon-60"];
                iconCell.textLabel.text = @"Original";
                if([indexPath row] == selectedCell) {
                    iconCell.accessoryType = UITableViewCellAccessoryCheckmark;
                    iconCell.selected = YES;
                } else {
                    iconCell.accessoryType = UITableViewCellAccessoryNone;
                    iconCell.selected = NO;
                }
                return iconCell;
            }
        } else {
            if ( [indexPath row] == 0) {
                cell.imageView.image = payIcon;
                cell.textLabel.text = @"PayPal";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 1) {
                cell.imageView.image = twtIcon;
                cell.textLabel.text = @"Twitter";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 2) {
                cell.imageView.image = gitIcon;
                cell.textLabel.text = @"GitHub";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 3) {
                cell.imageView.image = webIcon;
                cell.textLabel.text = @"Project Page";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 4) {
                cell.imageView.image = repoIcon;
                cell.textLabel.text = @"Repo";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 5) {
                cell.textLabel.text = @"Copyright \u00A9 Dave1482";
                cell.userInteractionEnabled = NO;
                return cell;
            }
        }
    } else if ( @available(iOS 10.3, *)){
        if ([indexPath section] == 3) {
            if ( [indexPath row] == 0) {
                cell.imageView.image = payIcon;
                cell.textLabel.text = @"PayPal";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 1) {
                cell.imageView.image = twtIcon;
                cell.textLabel.text = @"Twitter";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 2) {
                cell.imageView.image = gitIcon;
                cell.textLabel.text = @"GitHub";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 3) {
                cell.imageView.image = webIcon;
                cell.textLabel.text = @"Project Page";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 4) {
                cell.imageView.image = repoIcon;
                cell.textLabel.text = @"Repo";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            } else if ( [indexPath row] == 5) {
                cell.textLabel.text = @"Copyright \u00A9 Dave1482";
                cell.userInteractionEnabled = NO;
                return cell;
            }
        }
        
    }
    return cell;
}


- (void)alertSwitchSwitched{
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

- (void)lightSwitchSwitched{
    if(lightSwitch.on){
        if (@available(iOS 13, *)) {
            [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        }
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        gitIcon = [UIImage imageNamed:@"githubBlack"];
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
        gitIcon = [UIImage imageNamed:@"githubWhite"];
        NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
        [preferences setBool:NO forKey:@"lightSwitch"];
        [preferences synchronize];
    }
    if(@available(iOS 10.3,*)){
        [settingsTable reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [settingsTable reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)btnSwitchControlSelected {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:btnSwitchControl.selectedSegmentIndex forKey:@"btnControl"];
    [preferences synchronize];
}

- (void)borderSwitchControlSelected {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:(int)borderSwitchControl.selectedSegmentIndex forKey:@"borderControl"];
    [preferences synchronize];
}

- (void)rebootSwitchControlSelected {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:rebootSwitchControl.selectedSegmentIndex forKey:@"rebootControl"];
    [preferences synchronize];
}

- (void)iconSwitchControlSelected {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setInteger:iconControl.selectedSegmentIndex forKey:@"iconControl"];
    [preferences synchronize];
}

- (IBAction)showDevInfo{
    UIAlertController *devAlert = [UIAlertController alertControllerWithTitle:@"Developer Information" message:@"Dave1482\nWebsite: https://dave1482.com/\nProject Page: https://powerapp.dave1482.com/\nRepo: https://repo.dave1482.com/\nEmail: dave1482@dave1482.com\n\nCopyright © 2014-2020" preferredStyle:UIAlertControllerStyleAlert];
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
