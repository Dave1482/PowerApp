//
//  ChangelogViewController.h
//  PowerApp
//
//  Modified by David Teddy, II on 7/24/2020.
//  Copyright © 2014-2022 David Teddy, II (Dave1482). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DTCustomTextView.h"

@interface ChangelogViewController : UIViewController <UINavigationBarDelegate, UIBarPositioningDelegate>{
  IBOutlet DTCustomTextView *changes;
  IBOutlet UINavigationBar *navBar;
  NSString *cLog;
  NSRegularExpression *regex;
  NSArray *matches;
  NSUInteger matchCount;
  NSTextCheckingResult *match;
  NSRange matchRange;
  NSString *version;
}
@property (nonatomic) IBOutlet UINavigationBar *navBar;
@property (nonatomic, retain) IBOutlet DTCustomTextView *changes;

- (void) colorChanges;
- (IBAction)dismissChangelogViewController;
- (IBAction)showDevInfo;
@end
