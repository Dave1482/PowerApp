//
//  SettingsViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 11/19/2023.
//  Copyright © Since 2014 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@interface SettingsViewController : UIViewController <UINavigationBarDelegate, UIBarPositioningDelegate, UITableViewDelegate, UITableViewDataSource> {
  IBOutlet UINavigationBar *navBar;
  IBOutlet UITableView *settingsTable;
  UISwitch *alertSwitch;
  UISwitch *lightSwitch;
  UISegmentedControl *btnSwitchControl;
  UISegmentedControl *lightControl;
  UISegmentedControl *borderSwitchControl;
  UISegmentedControl *rebootSwitchControl;
  UITableViewCell *cell;
  UITableViewCell *iconCell;
  UILabel *label;
  UIImage *payIcon;
  UIImage *twtIcon;
  UIImage *webIcon;
  UIImage *gitIcon;
  UIImage *repoIcon;
  NSMutableArray *projectIcon;
  NSMutableArray *devArray;
  UIColor *tableColor;
  BOOL lightDidChange;
  int selectedCell;
}

@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, readonly, copy) NSString *cellID;
@property (nonatomic, readonly, copy) NSString *iconCellID;
@property (strong,nonatomic) UITableView *settingsTable;
@property (nonatomic) UISwitch *alertSwitch;
@property (nonatomic) UISwitch *lightSwitch;
@property (nonatomic) UISegmentedControl *btnSwitchControl;
@property (nonatomic) UISegmentedControl *lightControl;
@property (nonatomic) UISegmentedControl *borderSwitchControl;
@property (nonatomic) UISegmentedControl *rebootSwitchControl;

- (void)colorSettings;
- (void)alertSwitchSwitched;
- (void)lightSwitchSwitched;
- (void)btnSwitchControlSelected;
- (void)borderSwitchControlSelected;
- (void)rebootSwitchControlSelected;
- (void)lightControlSelected;
- (IBAction)dismissSettingsViewController;
- (NSString *)informationOf:(NSString *)req;

@end

