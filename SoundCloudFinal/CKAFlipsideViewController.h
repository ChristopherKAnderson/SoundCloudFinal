//
//  CKAFlipsideViewController.h
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 12/1/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKAFlipsideViewController.h"

#define kUser                         @"user"
#define kPassword                     @"password"

@class CKAFlipsideViewController;

@protocol CKAFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(CKAFlipsideViewController *)controller;
@end

@interface CKAFlipsideViewController : UIViewController 

@property (weak, nonatomic) id <CKAFlipsideViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

- (void)refreshFields;
- (IBAction)done:(id)sender;

@end
