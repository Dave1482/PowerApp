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
    IBOutlet UISwitch *alertSwitch;
    IBOutlet UISwitch *lightSwitch;
    IBOutlet UISegmentedControl *btnSwitchControl;
    UITableViewCell *lightCell;
    UITableViewCell *alertCell;
    UITableViewCell *respringCell;
    UITableViewCell *appVersionCell;
    UITableViewCell *versionCell;
    UITableViewCell *deviceCell;
    UILabel *appVersionLabel;
    UILabel *versionLabel;
    UILabel *deviceLabel;
}

@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, readonly, copy) NSString *cellID;
@property (strong,nonatomic) UITableView *settingsTable;
@property (nonatomic) UISwitch *alertSwitch;
@property (nonatomic) UISwitch *lightSwitch;
@property (nonatomic) UISegmentedControl *btnSwitchControl;
- (IBAction)alertSwitchSwitched;
- (IBAction)lightSwitchSwitched;
- (IBAction)btnSwitchControlSelected;
- (IBAction)dismissSettingsViewController;
- (NSString *)informationOf:(NSString *)req;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

@end

