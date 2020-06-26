//
//  ViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 6/25/2020.
//  Copyright © 2014-2020 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface ViewController : UIViewController <UINavigationBarDelegate, UIBarPositioningDelegate>{
    IBOutlet UINavigationBar *navBar;
    IBOutlet UIBarButtonItem *rightButton;
    IBOutlet UIButton *rebootButton;
    IBOutlet UIButton *shutdownButton;
    IBOutlet UIButton *ldrButton;
    IBOutlet UIButton *respringButton;
    IBOutlet UIButton *uicButton;
    IBOutlet UIButton *lockButton;
    IBOutlet UIButton *exitButton;
    IBOutlet UIButton *safeButton;
    IBOutlet UIButton *nonButton;
    NSString *receivedDataString;
    NSString *keyInfo;
    
}

@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (nonatomic) IBOutlet UIButton *rebootButton;
@property (nonatomic) IBOutlet UIButton *shutdownButton;
@property (nonatomic) IBOutlet UIButton *softRebootButton;
@property (nonatomic) IBOutlet UIButton *ldrButton;
@property (nonatomic) IBOutlet UIButton *respringButton;
@property (nonatomic) IBOutlet UIButton *safeButton;
@property (nonatomic) IBOutlet UIButton *nonButton;
@property (nonatomic) IBOutlet UIButton *uicButton;
@property (nonatomic) IBOutlet UIButton *exitButton;


- (void) colorMe;
- (void) ldRunCheck;
- (void) sbreloadCheck;
- (void) updateCheckWithKeyInfo:(NSString *)leInfo;
- (IBAction)rebootButtonPressed;
- (IBAction)shutdownButtonPressed;
- (IBAction)softRebootButtonPressed;
- (IBAction)respringButtonPressed;
- (IBAction)safeModeButtonPressed;
- (IBAction)nonMobileSubstrateModeButtonPressed;
- (IBAction)refreshCacheButtonPressed;
- (IBAction)exitButtonPressed;

@end
