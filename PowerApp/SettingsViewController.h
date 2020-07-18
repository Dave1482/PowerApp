//
//  SettingsViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 6/25/2020.
//  Copyright © 2014-2020 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@interface SettingsViewController : UIViewController <UINavigationBarDelegate, UIBarPositioningDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UINavigationBar *navBar;
    IBOutlet UITableView *settingsTable;
    UISwitch *alertSwitch;
    UISwitch *lightSwitch;
    UISegmentedControl *btnSwitchControl;
    UISegmentedControl *rebootSwitchControl;
    UISegmentedControl *iconControl;
    UITableViewCell *cell;
    UITableViewCell *iconCell;
    UILabel *appVersionLabel;
    UILabel *versionLabel;
    UILabel *deviceLabel;
    UILabel *appIcon1Label;
    UILabel *appIcon2Label;
    UILabel *appIcon3Label;
    int selectedCell;
}

@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, readonly, copy) NSString *cellID;
@property (nonatomic, readonly, copy) NSString *iconCellID;
@property (strong,nonatomic) UITableView *settingsTable;
@property (nonatomic) UISwitch *alertSwitch;
@property (nonatomic) UISwitch *lightSwitch;
@property (nonatomic) UISegmentedControl *btnSwitchControl;
@property (nonatomic) UISegmentedControl *rebootSwitchControl;
@property (nonatomic) UISegmentedControl *iconControl;

- (void)alertSwitchSwitched;
- (void)lightSwitchSwitched;
- (void)btnSwitchControlSelected;
- (void)rebootSwitchControlSelected;
- (void)iconSwitchControlSelected;
- (IBAction)dismissSettingsViewController;
- (NSString *)informationOf:(NSString *)req;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

