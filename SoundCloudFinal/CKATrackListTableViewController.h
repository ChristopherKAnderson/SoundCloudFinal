//
//  CKATrackListTableViewController.h
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/21/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CKATrackListTableViewController : UITableViewController
<AVAudioPlayerDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *tracks;
@property (strong,nonatomic) NSArray *filteredTracks;

@property (nonatomic, strong) AVAudioPlayer *player;

@property IBOutlet UISearchBar *trackSearchBar;

-(void) updateTracksAfterDelete;

/*
// For segue to track list or playlist
@property (strong, nonatomic) NSString *playlist;
@property int index;

-(void) drillDownTracks;
*/

@end
