//
//  CKAPlaylistInfoViewController.m
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 12/4/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import "BIDFavoritesList.h"
#import "CKAPlaylistInfoViewController.h"

@interface CKAPlaylistInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UILabel *toggleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *favoritesSwitch;

- (void)configureView;

@end

@implementation CKAPlaylistInfoViewController {
    SystemSoundID removeFavSoundID;
    SystemSoundID addFavSoundID;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.returnPath) {
        //self.returnPathBack = self.returnPath;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.favoritesSwitch.on = self.favorite;
    self.trackLabel.text = self.received;
    self.returnPathBack = self.returnPath;
    self.index = [NSString stringWithFormat:@"%d", self.returnPath];
    
    /*
     // Testing with objects
     NSObject *test = self.favoriteTrack;
     */
    
    // create sound when adding favorite
    if (addFavSoundID == 0) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"bell"
                                                         ofType:@"wav"];
        NSURL *soundURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,
                                         &addFavSoundID);
    }
    
    // create sound when removing favorite
    if (removeFavSoundID == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"crunch"
                                                         ofType:@"wav"];
        NSURL *soundURL = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundURL,
                                         &removeFavSoundID);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleFavorite:(UISwitch *)sender {
    
    BIDFavoritesList *favoritesList = [BIDFavoritesList sharedFavoritesList];
    if (sender.on) {
        
        [favoritesList addFavorite:self.index];
        [self.delegate detailViewController1:self didToggleFavorite:self.returnPathBack withState:@"ON"];
        AudioServicesPlaySystemSound(addFavSoundID);
        
    } else {
        
        // dialog view
        if (!sender.on) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Delete Favorite"
                                  message:@"Are You Sure?"
                                  delegate:self
                                  cancelButtonTitle:@"CONFIRM"
                                  otherButtonTitles:@"CANCEL", nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        self.favoritesSwitch.on = YES;
        
    } else {
        
        BIDFavoritesList *favoritesList = [BIDFavoritesList sharedFavoritesList];
        [favoritesList removeFavorite:self.index];
        
        // send back to table view
        [self.delegate detailViewController1:self didToggleFavorite:self.returnPathBack withState:@"OFF"];
        AudioServicesPlaySystemSound(removeFavSoundID);
    }
}

@end
