//
//  CKATrackListTableViewController.m
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/21/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import "BIDFavoritesList.h"
#import "CKAViewController.h"
#import "CKATrackListTableViewController.h"
#import "CKATrackInfoViewController.h"
#import "CKAPlaylistInfoViewController.h"
#import "SCUI.H"
#import <AVFoundation/AVFoundation.h>

@interface CKATrackListTableViewController ()
<DetailViewControllerDelegate, DetailViewControllerDelegate1> {
    //
}

@property (strong, nonatomic) BIDFavoritesList *favoritesList;
@property (strong, nonatomic) NSString *trackDesc;
@property (strong, nonatomic) NSArray *favTracks;
@property int fav;

/*
// for playlist update
@property BOOL onceToken;
*/

@end

@implementation CKATrackListTableViewController

@synthesize tracks;
@synthesize playlists;
@synthesize filteredTracks;
@synthesize player;
@synthesize trackSearchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.favoritesList = [BIDFavoritesList sharedFavoritesList];
    
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            
            tracks = (NSArray *)jsonResponse;
            [self.tableView reloadData];
        }
    };
    
    // Link to sound cloud assets / could use playlists instead but trickier
    NSString *resourceURL = @"https://api.soundcloud.com/me/tracks.json";
    
    /*
    // These might be used later when I can get the playlist navigation working correctly
    //NSString * resourceURL = [NSString stringWithFormat:@"https://api.soundcloud.com/me/tracks?q=%@&format=json", self.playlist];
    //NSString *resourceURL = @"https://api.soundcloud.com/me/playlists.json";
    */
    
     [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
    
    // Make playlist array
    [self makePlaylistArray];
    
    // initialize favorite tracks array
    self.favTracks = [BIDFavoritesList sharedFavoritesList].favorites;
}

/*
// Will be used later to implement the playlist navigation
-(void) drillDownTracks {
    // display only playlist tracks
    NSDictionary *temp = [tracks objectAtIndex:self.index];
    NSArray *tempArr = [temp objectForKey:@"tracks"];
    tracks = tempArr;
}
*/

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateTracksAfterDelete {
    
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            
            tracks = (NSArray *)jsonResponse;
            [self.tableView reloadData];
        }
    };
    
    NSString *resourceURL = @"https://api.soundcloud.com/me/tracks.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
}

-(void) makePlaylistArray {
    SCAccount *account = [SCSoundCloud account];
    if (account == nil) {
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Not Logged In"
                              message:@"You must login first"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    SCRequestResponseHandler handler;
    handler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            
            playlists = (NSArray *)jsonResponse;
            [self.tableView reloadData];
        }
    };
    
    NSString *resourceURL = @"https://api.soundcloud.com/me/playlists.json";
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:resourceURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:handler];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /* 
    // This is for playlist nav
    // ONLY DO THIS ONCE!
    if (!self.onceToken) {
        [self drillDownTracks];
    }
    */
    
    /*
    // Return the number of sections.
    if ([self.favoritesList.favorites count] > 0) {
        
        return 3;
        
    } else if ([playlists count] > 0) {
        
        return 2;
        
    } else {
        
        return 1;
    }
    */
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            return [filteredTracks count];
            
        } else {
            
            return [tracks count];
        }
        
    } else if (section == 1) {
        
        return [playlists count];
        
    } else {
        
        return [self.favTracks count];
    }
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return @"All Tracks";
        
    } else if (section == 1) {
        
        return @"All Playlists";
        
    } else {
        
        return @"My Favorite Tracks";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NormalCell = @"NormalCell";
    static NSString *FavoritesCell = @"FavoritesCell";
    static NSString *PlaylistsCell = @"PlaylistsCell";
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:NormalCell];
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:NormalCell];
        }
        
        // To help keep track of indexes
        int row = [[NSNumber numberWithLong:indexPath.row] intValue];
        NSString *subtitle = [NSString stringWithFormat:@"%d", row];
        NSLog(@"row = %d", row);
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            NSDictionary *track = [filteredTracks objectAtIndex:indexPath.row];
            cell.textLabel.text = [track objectForKey:@"title"];
            cell.detailTextLabel.text = subtitle;
            
        }
        
        else {
            
            NSDictionary *track = [tracks objectAtIndex:indexPath.row];
            cell.textLabel.text = [track objectForKey:@"title"];
            cell.detailTextLabel.text = subtitle;
            
        }
        
    } else if (indexPath.section == 1) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:PlaylistsCell];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:NormalCell];
        }
        
        // To help keep track of indexes
        int row = [[NSNumber numberWithLong:indexPath.row] intValue];
        NSString *subtitle = [NSString stringWithFormat:@"%d", row];
        NSLog(@"row = %d", row);
            
        NSDictionary *track = [playlists objectAtIndex:indexPath.row];
        cell.textLabel.text = [track objectForKey:@"title"];
        cell.detailTextLabel.text = subtitle;
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:FavoritesCell];
                                               //forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:FavoritesCell];
        }
        
        self.fav = [[self.favTracks objectAtIndex:indexPath.row] intValue];
        NSDictionary *track = [self.tracks objectAtIndex:self.fav];
        cell.textLabel.text = [track objectForKey:@"title"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", self.fav];
    }
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // delete from sound cloud too
        if (indexPath.section == 0) {
            
            if (tableView == self.searchDisplayController.searchResultsTableView) {
                
                NSDictionary *track = [filteredTracks objectAtIndex:indexPath.row];
                NSString *trackID = [track objectForKey:@"id"];
                
                SCAccount *account = [SCSoundCloud account];
                
                [SCRequest performMethod:SCRequestMethodDELETE
                              onResource:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/tracks/%@", trackID]]
                         usingParameters:nil
                             withAccount:account
                  sendingProgressHandler:nil
                         responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                             
                             // Handle the response
                             if (error) {
                                 NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                 
                             } else {
                                 
                                 // Check the statuscode and parse the data
                             }
                         }];
                
            } else {
                
                NSDictionary *track = [tracks objectAtIndex:indexPath.row];
                NSString *trackID = [track objectForKey:@"id"];
                
                SCAccount *account = [SCSoundCloud account];
                
                [SCRequest performMethod:SCRequestMethodDELETE
                              onResource:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/tracks/%@", trackID]]
                         usingParameters:nil
                             withAccount:account
                  sendingProgressHandler:nil
                         responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                             
                             // Handle the response
                             if (error) {
                                 NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                                 
                             } else {
                                 
                                 // Check the statuscode and parse the data
                             }
                         }];
            }
            
        } else if (indexPath.section == 1) {
            // For playlists
            
        }else {
            
            int fav = [[self.favTracks objectAtIndex:indexPath.row] intValue];
            NSDictionary *track = [self.tracks objectAtIndex:fav];
            NSString *trackID = [track objectForKey:@"id"];
            
            SCAccount *account = [SCSoundCloud account];
            
            [SCRequest performMethod:SCRequestMethodDELETE
                          onResource:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.soundcloud.com/tracks/%@", trackID]]
                     usingParameters:nil
                         withAccount:account
              sendingProgressHandler:nil
                     responseHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                         
                         // Handle the response
                         if (error) {
                             
                             NSLog(@"Ooops, something went wrong: %@", [error localizedDescription]);
                             
                         } else {
                             
                             // Check the statuscode and parse the data
                         }
                     }];
        }
        
        // Update table view to reflect deleted track
        [self updateTracksAfterDelete];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma mark - Navigation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            
            NSDictionary *track = [filteredTracks objectAtIndex:indexPath.row];
            NSString *streamURL = [track objectForKey:@"stream_url"];
    
            SCAccount *account = [SCSoundCloud account];
    
            [SCRequest performMethod:SCRequestMethodGET
                          onResource:[NSURL URLWithString:streamURL]
                     usingParameters:nil
                         withAccount:account
              sendingProgressHandler:nil
                     responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                         NSError *playerError;
                         player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                         [player prepareToPlay];
                         [player play];
                     }];
            
        } else {
            
            NSDictionary *track = [tracks objectAtIndex:indexPath.row];
            NSString *streamURL = [track objectForKey:@"stream_url"];
            
            SCAccount *account = [SCSoundCloud account];
            
            [SCRequest performMethod:SCRequestMethodGET
                          onResource:[NSURL URLWithString:streamURL]
                     usingParameters:nil
                         withAccount:account
              sendingProgressHandler:nil
                     responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                         NSError *playerError;
                         player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                         [player prepareToPlay];
                         [player play];
                     }];
        }
        
    } else if (indexPath.section == 1) {
        // For playlists
        
    }else {
        
        int fav = [[self.favTracks objectAtIndex:indexPath.row] intValue];
        NSDictionary *track = [self.tracks objectAtIndex:fav];
        NSString *streamURL = [track objectForKey:@"stream_url"];
        
        SCAccount *account = [SCSoundCloud account];
        
        [SCRequest performMethod:SCRequestMethodGET
                      onResource:[NSURL URLWithString:streamURL]
                 usingParameters:nil
                     withAccount:account
          sendingProgressHandler:nil
                 responseHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                     NSError *playerError;
                     player = [[AVAudioPlayer alloc] initWithData:data error:&playerError];
                     [player prepareToPlay];
                     [player play];
                 }];
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CKATrackListTableViewController *infoVC = segue.destinationViewController;
    infoVC.navigationItem.title = @"Track Info";
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    int row = [[NSNumber numberWithLong:indexPath.row] intValue];
    NSLog(@"row = %d", row);
    
    NSDictionary *track;
    NSDictionary *playlist;
    NSString *titleLabel;
    
    if (indexPath.section == 1) {
        
        // for playlists
        track = [playlists objectAtIndex:indexPath.row];
        titleLabel = [playlist objectForKey:@"title"];
        
        self.trackDesc = titleLabel;
        
        CKAPlaylistInfoViewController *targetVC = (CKAPlaylistInfoViewController*)segue.destinationViewController;
        targetVC.received = _trackDesc;
        targetVC.favoriteTrack = track;
        
        if (indexPath.section == 0) {
            
            id checkFav = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            targetVC.favorite = [[BIDFavoritesList sharedFavoritesList].favorites
                                 containsObject:checkFav];
            /*
             // For testing
             BOOL check = [[BIDFavoritesList sharedFavoritesList].favorites
             containsObject:checkFav];
             */
            
            targetVC.returnPath = [[NSNumber numberWithLong:indexPath.row] intValue];
            
        } else {
            
            id checkFav = [NSString stringWithFormat:@"%d", self.fav];
            targetVC.favorite = [[BIDFavoritesList sharedFavoritesList].favorites
                                 containsObject:checkFav];
            
            /*
             BOOL check = [[BIDFavoritesList sharedFavoritesList].favorites
             containsObject:checkFav];
             */
            
            targetVC.returnPath = self.fav;
        }
        
        // BID Set delegate reference
        CKAPlaylistInfoViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        
        // BID Fixup create an empty string and send it to Detail View
        NSNumber *s;
        [[segue destinationViewController] setDetailItem:s];
        
    } else {
    
        if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        
            track = [filteredTracks objectAtIndex:indexPath.row];
            titleLabel = [track objectForKey:@"title"];
        
        } else {
        
            track = [tracks objectAtIndex:indexPath.row];
            titleLabel = [track objectForKey:@"title"];
        }
    
        self.trackDesc = titleLabel;
    
        CKATrackInfoViewController *targetVC = (CKATrackInfoViewController*)segue.destinationViewController;
        targetVC.received = _trackDesc;
        targetVC.favoriteTrack = track;
    
        if (indexPath.section == 0) {
        
            id checkFav = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            targetVC.favorite = [[BIDFavoritesList sharedFavoritesList].favorites
                             containsObject:checkFav];
            /*
             // For testing
             BOOL check = [[BIDFavoritesList sharedFavoritesList].favorites
                      containsObject:checkFav];
             */
        
            targetVC.returnPath = [[NSNumber numberWithLong:indexPath.row] intValue];
        
        } else {
        
            id checkFav = [NSString stringWithFormat:@"%d", self.fav];
            targetVC.favorite = [[BIDFavoritesList sharedFavoritesList].favorites
                             containsObject:checkFav];
        
            /*
             BOOL check = [[BIDFavoritesList sharedFavoritesList].favorites
                      containsObject:checkFav];
             */
        
            targetVC.returnPath = self.fav;
        }
    
        // BID Set delegate reference
        CKATrackInfoViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    
        // BID Fixup create an empty string and send it to Detail View
        NSNumber *s;
        [[segue destinationViewController] setDetailItem:s];
    }
}

// BID define the delegated method that adds the returned string to the table and master view
- (void)detailViewController:(CKATrackInfoViewController *)detailViewController
           didToggleFavorite:(int)returnPathBack withState:(NSString *)state {
    
    NSLog(@"didToggleFavorite: %d - %@", returnPathBack, state);       // turn this off eventually
    
    /*
    // Return boolean for playlist nav
    self.onceToken = YES;
    */
    
    [self.tableView reloadData];
}

// BID define the delegated method that adds the returned string to the table and master view
- (void)detailViewController1:(CKAPlaylistInfoViewController *)detailViewController
           didToggleFavorite:(int)returnPathBack withState:(NSString *)state {
    
    NSLog(@"didToggleFavorite: %d - %@", returnPathBack, state);       // turn this off eventually
    
    /*
     // Return boolean for playlist nav
     self.onceToken = YES;
     */
    
    [self.tableView reloadData];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ['title'] contains[cd] %@",searchText];
    filteredTracks = [tracks filteredArrayUsingPredicate:predicate];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
 
@end
