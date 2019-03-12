//
//  ChangelogViewController.m
//  PowerApp
//
//  Modified by David Teddy, II on 3/11/2019.
//  Copyright © 2014-2019 David Teddy, II (Dave1482). All rights reserved.
//

#import "ChangelogViewController.h"

@interface ChangelogViewController ()

@end
@implementation ChangelogViewController
@synthesize changes;
@synthesize navBar;



- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
        [self setNeedsStatusBarAppearanceUpdate];
        [changes setBackgroundColor:[UIColor whiteColor]];
        [changes setTextColor:[UIColor blackColor]];
        navBar.barTintColor = [UIColor whiteColor];
        self.view.backgroundColor = [UIColor whiteColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];

    } else {
        [self setNeedsStatusBarAppearanceUpdate];
        [changes setBackgroundColor:[UIColor blackColor]];
        [changes setTextColor:[UIColor whiteColor]];
        navBar.barTintColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    }
    [changes setFont:[UIFont systemFontOfSize:16]];
    
    NSString *cLog = [[NSBundle mainBundle] pathForResource:@"cLog" ofType:@"txt"];
    changes.text = [NSString stringWithContentsOfFile:cLog encoding:NSUTF8StringEncoding error:NULL];
    [changes setTextAlignment:NSTextAlignmentLeft];

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"Version \\d?\\d?\\d\\.\\d\\.?\\d?:" options:0 error:&error];
    NSArray *matches = [regex matchesInString:changes.text options:0 range:NSMakeRange(0, [changes.text length])];
    NSUInteger matchCount = [matches count];
    if (matchCount) {
        for (NSUInteger matchIdx = 0; matchIdx < matchCount; matchIdx++) {
            NSTextCheckingResult *match = [matches objectAtIndex:matchIdx];
            NSRange matchRange = [match range];
            NSString *version = [changes.text substringWithRange:matchRange];
            [changes boldSubstring: version ofSize:16.0 colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        }
    }
    // Yay, no more updating this for each new version!
    changes.editable = NO;
    [changes setUserInteractionEnabled:YES];
    
}
- (void)viewDidLayoutSubviews {
    [changes setContentOffset:CGPointZero animated:NO];
}

- (IBAction)showDevInfo{
    UIAlertController *devAlert = [UIAlertController alertControllerWithTitle:@"Developer Information" message:@"Dave1482\nWebsite: http://dave1482.com/\nProject Page: http://dave1482.com/projects/powerapp/\nRepo: http://repo.dave1482.com/\nEmail: dave1482@dave1482.com\n\nCopyright © 2014-2019" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneDevBtn = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [devAlert addAction:doneDevBtn];
    [self presentViewController:devAlert animated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"lightSwitch"] == YES){
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

- (IBAction)dismissChangelogViewController {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
