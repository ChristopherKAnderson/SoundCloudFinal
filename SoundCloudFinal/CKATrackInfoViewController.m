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

@implementation CKATrackInfoViewController

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
    } else {
        //[favoritesList removeFavorite:self.trackLabel.text];
        //[favoritesList removeFavorite:self.favoriteTrack];
        [favoritesList removeFavorite:self.index];
        
        //
        [self.delegate detailViewController:self didToggleFavorite:self.returnPathBack withState:@"OFF"];
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
