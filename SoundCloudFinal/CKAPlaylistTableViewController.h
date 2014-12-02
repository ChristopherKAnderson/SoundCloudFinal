//
//  CKAPlaylistTableViewController.h
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 12/1/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CKAPlaylistTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *playlists;

@property (strong,nonatomic) NSArray *filteredPlaylists;

/*
// For playlist navigation
-(void) updateTracksAfterDelete;
*/

@end
