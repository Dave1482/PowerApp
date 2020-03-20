//
//  SettingsViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 2/20/2020.
//  Copyright © 2014-2020 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@interface SettingsViewController : UIViewController <UINavigationBarDelegate, UIBarPositioningDelegate>{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UISwitch *alertSwitch;
    IBOutlet UISwitch *lightSwitch;
    IBOutlet UISwitch *lockSwitch;
    IBOutlet UISwitch *infoSwitch;
    IBOutlet UISegmentedControl *btnSwitchControl;
    IBOutlet UILabel *alertLabel;
    IBOutlet UILabel *lightLabel;
    IBOutlet UILabel *lockLabel;
    IBOutlet UILabel *showInfoLabel;
    IBOutlet UILabel *infoLabel;
    IBOutlet UILabel *btnSwitchLabel;
}

@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic) IBOutlet UISwitch *alertSwitch;
@property (nonatomic) IBOutlet UISwitch *lightSwitch;
@property (nonatomic) IBOutlet UISwitch *lockSwitch;
@property (nonatomic) IBOutlet UISwitch *infoSwitch;
@property (nonatomic) IBOutlet UISegmentedControl *btnSwitchControl;
@property (nonatomic, retain) IBOutlet UILabel *alertLabel;
@property (nonatomic, retain) IBOutlet UILabel *lightLabel;
@property (nonatomic, retain) IBOutlet UILabel *lockLabel;
@property (nonatomic, retain) IBOutlet UILabel *showInfoLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) IBOutlet UILabel *btnSwitchLabel;
- (IBAction)alertSwitchSwitched;
- (IBAction)lightSwitchSwitched;
- (IBAction)lockSwitchSwitched;
- (IBAction)infoSwitchSwitched;
- (IBAction)btnSwitchControlSelected;
- (IBAction)dismissSettingsViewController;

@end

