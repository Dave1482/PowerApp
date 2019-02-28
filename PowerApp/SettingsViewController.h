//
//  SettingsViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 8/12/2018.
//  Copyright © 2014-2019 David Teddy, II. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UINavigationBarDelegate, UIBarPositioningDelegate>{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UISwitch *alertSwitch;
    IBOutlet UISwitch *lightSwitch;
    IBOutlet UISwitch *lockSwitch;
    IBOutlet UILabel *alertLabel;
    IBOutlet UILabel *lightLabel;
    IBOutlet UILabel *lockLabel;
}

@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic) IBOutlet UISwitch *alertSwitch;
@property (nonatomic) IBOutlet UISwitch *lightSwitch;
@property (nonatomic) IBOutlet UISwitch *lockSwitch;
@property (nonatomic, retain) IBOutlet UILabel *alertLabel;
@property (nonatomic, retain) IBOutlet UILabel *lightLabel;
@property (nonatomic, retain) IBOutlet UILabel *lockLabel;
- (IBAction)alertSwitchSwitched;
- (IBAction)lightSwitchSwitched;
- (IBAction)lockSwitchSwitched;
- (IBAction)dismissSettingsViewController;
- (IBAction)showDevInfo;
@end

