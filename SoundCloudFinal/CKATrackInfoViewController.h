//
//  CKATrackInfoViewController.h
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/21/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKATrackListTableViewController.h"

// CKA declare the detail view class to solve the forward reference
@class CKATrackInfoViewController;

// CKA define the protocol
@protocol DetailViewControllerDelegate <NSObject>

- (void)detailViewController:(CKATrackInfoViewController *)detailViewController
           didToggleFavorite:(int)returnPathBack withState:(NSString *)state;

@end

@interface CKATrackInfoViewController : UIViewController

@property (strong, nonatomic) id detailItem;

// CKA define the delegate reference
@property (nonatomic, weak) id <DetailViewControllerDelegate> delegate;

@property (strong, nonatomic) NSObject *favoriteTrack;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *received;
@property (assign, nonatomic) BOOL favorite;
@property int returnPath;
@property int returnPathBack;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
