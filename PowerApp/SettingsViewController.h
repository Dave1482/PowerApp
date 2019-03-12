//
//  SettingsViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 3/11/2019.
//  Copyright © 2014-2019 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sys/utsname.h>

@interface SettingsViewController : UIViewController <UINavigationBarDelegate, UIBarPositioningDelegate>{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UISwitch *alertSwitch;
    IBOutlet UISwitch *lightSwitch;
    IBOutlet UISwitch *lockSwitch;
    IBOutlet UISwitch *infoSwitch;
    IBOutlet UILabel *alertLabel;
    IBOutlet UILabel *lightLabel;
    IBOutlet UILabel *lockLabel;
    IBOutlet UILabel *showInfoLabel;
    IBOutlet UILabel *infoLabel;
}

@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic) IBOutlet UISwitch *alertSwitch;
@property (nonatomic) IBOutlet UISwitch *lightSwitch;
@property (nonatomic) IBOutlet UISwitch *lockSwitch;
@property (nonatomic) IBOutlet UISwitch *infoSwitch;
@property (nonatomic, retain) IBOutlet UILabel *alertLabel;
@property (nonatomic, retain) IBOutlet UILabel *lightLabel;
@property (nonatomic, retain) IBOutlet UILabel *lockLabel;
@property (nonatomic, retain) IBOutlet UILabel *showInfoLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
- (IBAction)alertSwitchSwitched;
- (IBAction)lightSwitchSwitched;
- (IBAction)lockSwitchSwitched;
- (IBAction)infoSwitchSwitched;
- (IBAction)dismissSettingsViewController;

@end

