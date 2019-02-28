//
//  ViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 8/12/2018.
//  Copyright © 2014-2019 David Teddy, II. All rights reserved.
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


