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
@property (nonatomic, strong) AVAudioPlayer *player;

//@property (strong,nonatomic) NSMutableArray *filteredTracks;
@property (strong,nonatomic) NSArray *filteredTracks;

@property IBOutlet UISearchBar *trackSearchBar;

// For segue to track list
@property (strong, nonatomic) NSString *playlist;
@property int index;

-(void) updateTracksAfterDelete;
-(void) drillDownTracks;

@end
