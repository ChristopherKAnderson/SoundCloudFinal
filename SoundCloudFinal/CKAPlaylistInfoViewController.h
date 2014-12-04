//
//  CKAPlaylistInfoViewController.h
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 12/4/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKATrackListTableViewController.h"

// CKA declare the detail view class to solve the forward reference
@class CKAPlaylistInfoViewController;

// CKA define the protocol
@protocol DetailViewControllerDelegate1 <NSObject>

- (void)detailViewController1:(CKAPlaylistInfoViewController *)detailViewController
           didToggleFavorite:(int)returnPathBack withState:(NSString *)state;

@end

@interface CKAPlaylistInfoViewController : UIViewController

@property (strong, nonatomic) id detailItem;

// CKA define the delegate reference
@property (nonatomic, weak) id <DetailViewControllerDelegate1> delegate;

@property (strong, nonatomic) NSObject *favoriteTrack;
@property (strong, nonatomic) NSString *index;
@property (strong, nonatomic) NSString *received;
@property (assign, nonatomic) BOOL favorite;
@property int returnPath;
@property int returnPathBack;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
