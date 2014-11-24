//
//  CKATrackListViewController.h
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/6/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CKATrackListViewController : UITableViewController
<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSArray *tracks;
@property (nonatomic, strong) AVAudioPlayer *player;

@end