//
//  ChangelogViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 3/11/2019.
//  Copyright © 2014-2019 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DTCustomTextView.h"

@interface ChangelogViewController : UIViewController <UINavigationBarDelegate, UIBarPositioningDelegate>{
    IBOutlet DTCustomTextView *changes;
    IBOutlet UINavigationBar *navBar;
}
@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet DTCustomTextView *changes;
- (IBAction)dismissChangelogViewController;
- (IBAction)showDevInfo;
@end
