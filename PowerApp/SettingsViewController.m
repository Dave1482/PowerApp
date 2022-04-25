//
//  SettingsViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 4/24/2022.
//  Copyright © Since 2014 David Teddy, II (Dave1482). All rights reserved.
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
@synthesize lightControl;
@synthesize borderSwitchControl;
@synthesize rebootSwitchControl;

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
  repoIcon = [UIImage imageNamed:@"repoIcon"];
  devArray = [[NSMutableArray alloc] initWithObjects:@"https://paypal.me/DaveT1482", @"https://twitter.com/xDave1482", @"https://github.com/Dave1482/PowerApp/", @"https://powerapp.dave1482.com/", @"https://repo.dave1482.com/", nil];
  settingsTable.delegate = self;
  settingsTable.dataSource = self;
  projectIcon = [NSMutableArray arrayWithObjects:@"projInIcon", @"projOutIcon", @"projOrigIcon", @"projBlueIcon", @"projWhiteIcon", nil];
  [btnSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"]];
  if ([[NSUserDefaults standardUserDefaults] integerForKey:@"iconSelect"]){
    selectedCell = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"iconSelect"];
  } else {
    selectedCell = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:selectedCell forKey:@"iconSelect"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  webIcon = [UIImage imageNamed:projectIcon[selectedCell]];
  [borderSwitchControl setSelectedSegmentIndex:selectedCell];
  lightDidChange = YES;
  [self colorSettings];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorSettings) name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)colorSettings {
  if (@available(iOS 13, *)){
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"lightControl"]){
      case 0:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        gitIcon = [UIImage imageNamed:@"githubBlack"];
        break;
      case 1:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleDark];
        [self setNeedsStatusBarAppearanceUpdate];
        navBar.barTintColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        gitIcon = [UIImage imageNamed:@"githubWhite"];
        break;
      case 2:
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleUnspecified];
        if( self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark ){
          [self setNeedsStatusBarAppearanceUpdate];
          navBar.barTintColor = [UIColor blackColor];
          self.view.backgroundColor = [UIColor blackColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
          gitIcon = [UIImage imageNamed:@"githubWhite"];
        } else {
          [self setNeedsStatusBarAppearanceUpdate];
          navBar.barTintColor = [UIColor whiteColor];
          self.view.backgroundColor = [UIColor whiteColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
          gitIcon = [UIImage imageNamed:@"githubBlack"];
        }
        break;
      default:
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
          [self setNeedsStatusBarAppearanceUpdate];
          navBar.barTintColor = [UIColor whiteColor];
          self.view.backgroundColor = [UIColor whiteColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
          gitIcon = [UIImage imageNamed:@"githubBlack"];
        } else {
          [self setNeedsStatusBarAppearanceUpdate];
          navBar.barTintColor = [UIColor blackColor];
          self.view.backgroundColor = [UIColor blackColor];
          [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
          gitIcon = [UIImage imageNamed:@"githubWhite"];
        }
        break;
    }
    [settingsTable reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
  } else {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
      [self setNeedsStatusBarAppearanceUpdate];
      navBar.barTintColor = [UIColor whiteColor];
      self.view.backgroundColor = [UIColor whiteColor];
      tableColor = [UIColor groupTableViewBackgroundColor];
      [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
      gitIcon = [UIImage imageNamed:@"githubBlack"];
    } else {
      [self setNeedsStatusBarAppearanceUpdate];
      navBar.barTintColor = [UIColor blackColor];
      self.view.backgroundColor = [UIColor blackColor];
      tableColor = [UIColor blackColor];
      [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
      gitIcon = [UIImage imageNamed:@"githubWhite"];
    }
    if(@available(iOS 13, *)){
      [settingsTable reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationNone];
    } else {
      [UIView performWithoutAnimation:^{
        [settingsTable beginUpdates];
        [settingsTable reloadData];
        [settingsTable endUpdates];
      }];
    }
  }
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
      if (@available(iOS 13, *)) {
        return 9;
      }
      return 8;
      break;
    case 1:
      return 3;
      break;
    case 2:
      /*if (@available(iOS 10.3, *)) {
        return 3;
      } */ //Change this if adding more icons
      return 5;
      break;
    case 3:
      if (@available (iOS 10.3, *)) {
        return 5;
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
  switch (section) {
    case 2:
      if (@available(iOS 10.3, *)) {
        return nil;
      }
      return @"Copyright \u00A9 Dave1482";
      break;
    case 3:
      if (@available(iOS 10.3, *)) {
        return @"Copyright \u00A9 Dave1482";
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
        NSArray *nameArray = [NSArray arrayWithObjects:@"", @"outsetIcon", @"originalIcon", @"blueIcon", @"whiteIcon", nil];
        if ([[UIApplication sharedApplication] supportsAlternateIcons]){
          if (indexPath.row > 0){
            [[UIApplication sharedApplication] setAlternateIconName:nameArray[indexPath.row] completionHandler:nil];
          } else {
            [[UIApplication sharedApplication] setAlternateIconName:nil completionHandler:nil];
          }
        }
        [[NSUserDefaults standardUserDefaults] setInteger:self->selectedCell forKey:@"iconSelect"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self->webIcon = [UIImage imageNamed:self->projectIcon[self->selectedCell]];
        [UIView performWithoutAnimation:^{
          [self->settingsTable beginUpdates];
          [self->settingsTable reloadData];
          [self->settingsTable endUpdates];
        }];
      });
    } else if ([indexPath section] == 3){
      NSString *devURLString = [NSString stringWithFormat:@"%@",[devArray objectAtIndex:indexPath.row]];
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:devURLString] options:@{} completionHandler:nil];
    }
  } else if ([indexPath section] == 2){
    NSString *devURLString = [NSString stringWithFormat:@"%@",[devArray objectAtIndex:indexPath.row]];
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
  if (@available (iOS 13, *)){
    iconCell.selectionStyle = UITableViewCellSelectionStyleDefault;
  } else {
    UIView *customColorView = [[UIView alloc] init];
    settingsTable.backgroundColor = tableColor;
    if(lightSwitch.on){
      settingsTable.separatorColor = [UIColor colorWithRed:199.0/256.0 green:199.0/256.0 blue:201.0/256.0 alpha:1.0];
      cell.backgroundView.backgroundColor = [UIColor whiteColor];
      cell.backgroundColor = [UIColor whiteColor];
      iconCell.backgroundColor = [UIColor whiteColor];
      iconCell.selectionStyle = UITableViewCellSelectionStyleDefault;
      cell.textLabel.textColor = [UIColor blackColor];
      iconCell.textLabel.textColor = [UIColor blackColor];
      label.textColor = [UIColor blackColor];
      customColorView.backgroundColor = [UIColor colorWithRed:209.0/256.0 green:209.0/256.0 blue:214.0/256.0 alpha:1.0];
    } else {
      settingsTable.separatorColor = [UIColor colorWithRed:61.0/256.0 green:61.0/256.0 blue:68.0/256.0 alpha:0.7];
      cell.backgroundColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.12 alpha:1.0];
      iconCell.backgroundColor = [UIColor colorWithRed:0.11 green:0.11 blue:0.12 alpha:1.0];
      iconCell.selectionStyle = UITableViewCellSelectionStyleGray;
      cell.textLabel.textColor = [UIColor whiteColor];
      iconCell.textLabel.textColor = [UIColor whiteColor];
      label.textColor = [UIColor whiteColor];
      customColorView.backgroundColor = [UIColor colorWithRed:58/256.0 green:58/256.0 blue:60/256.0 alpha:1.0];
    }
    iconCell.selectedBackgroundView =  customColorView;
  }
  if ([indexPath section] == 0) {
    if ( [indexPath row] == 0 ){
        cell.textLabel.text = @"Respring Mode";
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else if ( [indexPath row] == 1 ){
        btnSwitchControl = [[UISegmentedControl alloc] initWithItems:@[@"killall", @"sbreload", @"ldrestart"]];
        btnSwitchControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        btnSwitchControl.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2);
        [cell.contentView addSubview:btnSwitchControl];
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        [btnSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"btnControl"]];
        [btnSwitchControl addTarget:self action:@selector(btnSwitchControlSelected) forControlEvents:UIControlEventValueChanged];
        [borderSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"borderControl"]];
        [borderSwitchControl addTarget:self action:@selector(borderSwitchControlSelected) forControlEvents:UIControlEventValueChanged];
        return cell;
    } else if ( [indexPath row] == 2 ){
        cell.textLabel.text = @"Button Border Thickness";
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else if ( [indexPath row] == 3 ){
        borderSwitchControl = [[UISegmentedControl alloc] initWithItems:@[@"None", @"Thin", @"Thick", @"THICC"]];
        [cell.contentView addSubview:borderSwitchControl];
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        borderSwitchControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        borderSwitchControl.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2);
        [borderSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"borderControl"]];
        [borderSwitchControl addTarget:self action:@selector(borderSwitchControlSelected) forControlEvents:UIControlEventValueChanged];
        return cell;
    } else if ( [indexPath row] == 4 ){
        cell.textLabel.text = @"Quick Action Reboot Mode";
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    } else if ( [indexPath row] == 5 ){
        rebootSwitchControl = [[UISegmentedControl alloc] initWithItems:@[@"Full", @"Soft"]];
        [cell.contentView addSubview:rebootSwitchControl];
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        rebootSwitchControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        rebootSwitchControl.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2);
        [rebootSwitchControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"rebootControl"]];
        [rebootSwitchControl addTarget:self action:@selector(rebootSwitchControlSelected) forControlEvents:UIControlEventValueChanged];
        return cell;
    } else if ( [indexPath row] == 6) {
      if(@available (iOS 13, *)){
        cell.textLabel.text = @"Theme";
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
      } else {
        cell.textLabel.text = @"Light Theme";
        cell.accessoryView = lightSwitch;
        [lightSwitch addTarget:self action:@selector(lightSwitchSwitched) forControlEvents:UIControlEventValueChanged];
        return cell;
      }
    } else if ( [indexPath row] == 7) {
      if(@available (iOS 13, *)){
        lightControl = [[UISegmentedControl alloc] initWithItems:@[@"Light", @"Dark", @"Auto"]];
        [cell.contentView addSubview:lightControl];
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        lightControl.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        lightControl.center = CGPointMake(cell.contentView.bounds.size.width/2,cell.contentView.bounds.size.height/2);
        [lightControl setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"lightControl"]];
        [lightControl addTarget:self action:@selector(lightControlSelected) forControlEvents:UIControlEventValueChanged];
        return cell;
      } else {cell.textLabel.text = @"Alerts";
          cell.accessoryView = alertSwitch;
          [alertSwitch addTarget:self action:@selector(alertSwitchSwitched) forControlEvents:UIControlEventValueChanged];
          return cell;
      }
    } if(@available (iOS 13, *)){
        if ( [indexPath row] == 8){
        cell.textLabel.text = @"Alerts";
        cell.accessoryView = alertSwitch;
        [alertSwitch addTarget:self action:@selector(alertSwitchSwitched) forControlEvents:UIControlEventValueChanged];
        return cell;
      }
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
        } else {
          iconCell.accessoryType = UITableViewCellAccessoryNone;
        }
        return iconCell;
      } else if ( [indexPath row] == 1 ){
        iconCell.imageView.image = [UIImage imageNamed:@"AltIcons/outsetIcon-60"];
        iconCell.textLabel.text = @"Gray";
        if([indexPath row] == selectedCell) {
          iconCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
          iconCell.accessoryType = UITableViewCellAccessoryNone;
        }
        return iconCell;
      } else if ( [indexPath row] == 2 ){
        iconCell.imageView.image = [UIImage imageNamed:@"AltIcons/originalIcon-60"];
        iconCell.textLabel.text = @"Original";
        if([indexPath row] == selectedCell) {
          iconCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
          iconCell.accessoryType = UITableViewCellAccessoryNone;
        }
        return iconCell;
      } else if ( [indexPath row] == 3 ){
        iconCell.imageView.image = [UIImage imageNamed:@"AltIcons/blueIcon-60"];
        iconCell.textLabel.text = @"Blue";
        if([indexPath row] == selectedCell) {
          iconCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
          iconCell.accessoryType = UITableViewCellAccessoryNone;
        }
        return iconCell;
      } else if ( [indexPath row] == 4 ){
        iconCell.imageView.image = [UIImage imageNamed:@"AltIcons/whiteIcon-60"];
        iconCell.textLabel.text = @"Light (by @project11x)";
        if([indexPath row] == selectedCell) {
          iconCell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
          iconCell.accessoryType = UITableViewCellAccessoryNone;
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
        cell.imageView.layer.cornerRadius = 6.0f;
        cell.imageView.layer.masksToBounds = YES;
        cell.textLabel.text = @"Project Page";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
      } else if ( [indexPath row] == 4) {
        cell.imageView.image = repoIcon;
        cell.imageView.layer.cornerRadius = 6.0f;
        cell.imageView.layer.masksToBounds = YES;
        cell.textLabel.text = @"Repo";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        cell.imageView.layer.cornerRadius = 6.0f;
        cell.imageView.layer.masksToBounds = YES;
        cell.textLabel.text = @"Project Page";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
      } else if ( [indexPath row] == 4) {
        cell.imageView.image = repoIcon;
        cell.imageView.layer.cornerRadius = 6.0f;
        cell.imageView.layer.masksToBounds = YES;
        cell.textLabel.text = @"Repo";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
      }
    }
  }
  return cell;
}

- (void)alertSwitchSwitched{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
  if(alertSwitch.on){
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alertSwitch.enabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  } else {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alertSwitch.enabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorSettings) name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)lightControlSelected{
  [[NSUserDefaults standardUserDefaults] setInteger:self->lightControl.selectedSegmentIndex forKey:@"lightControl"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)lightSwitchSwitched {
  if(lightSwitch.on){
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"lightSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  } else {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"lightSwitch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
}

- (void)btnSwitchControlSelected {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
  [[NSUserDefaults standardUserDefaults] setInteger:btnSwitchControl.selectedSegmentIndex forKey:@"btnControl"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorSettings) name:NSUserDefaultsDidChangeNotification object:nil];
  }

- (void)borderSwitchControlSelected {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
  [[NSUserDefaults standardUserDefaults] setInteger:borderSwitchControl.selectedSegmentIndex forKey:@"borderControl"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorSettings) name:NSUserDefaultsDidChangeNotification object:nil];
}

- (void)rebootSwitchControlSelected {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
  [[NSUserDefaults standardUserDefaults] setInteger:rebootSwitchControl.selectedSegmentIndex forKey:@"rebootControl"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorSettings) name:NSUserDefaultsDidChangeNotification object:nil];
}

- (IBAction)showDevInfo{
  UIAlertController *devAlert;
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
- (IBAction)dismissSettingsViewController {
  [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
