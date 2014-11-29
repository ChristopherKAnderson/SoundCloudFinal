//
//  CKAViewController.h
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/6/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CKAViewController : UIViewController
<AVAudioRecorderDelegate, AVAudioPlayerDelegate, AVAssetResourceLoaderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *recordPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) NSTimer *currentTimeUpdateTimer;
@property NSURL *outputFileURL;

@property (weak, nonatomic) IBOutlet UILabel *meter;
@property (weak, nonatomic) IBOutlet UITextField *name;

- (IBAction)playTapped:(id)sender;
- (IBAction)recordPauseTapped:(id)sender;
- (IBAction)stopTapped:(id)sender;



@end
