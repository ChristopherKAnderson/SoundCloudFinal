//
//  CKATrackInfoViewController.m
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/21/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import "BIDFavoritesList.h"
#import "CKATrackInfoViewController.h"

@interface CKATrackInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *trackLabel;
@property (weak, nonatomic) IBOutlet UILabel *toggleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *favoritesSwitch;

- (void)configureView;

@end

@implementation CKATrackInfoViewController {
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
    //self.label.text = self.title;
    self.favoritesSwitch.on = self.favorite;
    self.trackLabel.text = self.received;
    self.returnPathBack = self.returnPath;
    self.index = [NSString stringWithFormat:@"%d", self.returnPath];
    //NSObject *test = self.favoriteTrack;
    
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
        //[favoritesList addFavorite:self.trackLabel.text];
        //[favoritesList addFavorite:self.favoriteTrack];
        [favoritesList addFavorite:self.index];
        
        //
        [self.delegate detailViewController:self didToggleFavorite:self.returnPathBack withState:@"ON"];
        AudioServicesPlaySystemSound(addFavSoundID);
    } else {
        // dialog
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

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.favoritesSwitch.on = YES;
    } else {
        BIDFavoritesList *favoritesList = [BIDFavoritesList sharedFavoritesList];
        //[favoritesList removeFavorite:self.trackLabel.text];
        //[favoritesList removeFavorite:self.favoriteTrack];
        [favoritesList removeFavorite:self.index];
        
        // send back to table view
        [self.delegate detailViewController:self didToggleFavorite:self.returnPathBack withState:@"OFF"];
        AudioServicesPlaySystemSound(removeFavSoundID);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
