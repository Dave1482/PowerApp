//
//  ViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 3/11/2019.
//  Copyright © 2014-2019 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface ViewController : UIViewController <UINavigationBarDelegate, UIBarPositioningDelegate>{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIBarButtonItem *rightButton;
    IBOutlet UIButton *safeButton;
    IBOutlet UIButton *nonButton;
}

@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (nonatomic) IBOutlet UIButton *safeButton;
@property (nonatomic) IBOutlet UIButton *nonButton;


- (void) colorMe;
- (IBAction)rebootButtonPressed;
- (IBAction)shutdownButtonPressed;
- (IBAction)respringButtonPressed;
- (IBAction)safeModeButtonPressed;
- (IBAction)nonMobileSubstrateModeButtonPressed;
- (IBAction)refreshCacheButtonPressed;
- (IBAction)lockButtonPressed;
- (IBAction)exitButtonPressed;

@end


