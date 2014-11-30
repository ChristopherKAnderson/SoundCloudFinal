//
//  CKATrackListTableViewController.m
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/21/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import "BIDFavoritesList.h"
#import "CKAViewController.h"
//#import "CKATrackListViewController.h"
#import "CKATrackListTableViewController.h"
#import "CKATrackInfoViewController.h"
#import "SCUI.H"
#import <AVFoundation/AVFoundation.h>
#import "CKATrack.h"
#import "CKATrack1.h"

@interface CKATrackListTableViewController ()
@property (strong, nonatomic) BIDFavoritesList *favoritesList;
@property (strong, nonatomic) NSString *trackDesc;
@property (strong, nonatomic) NSArray *favTracks;
//@property (strong, nonatomic) CKATrack *searchTrack;
@property int fav;

@end

@implementation CKATrackListTableViewController
@synthesize tracks;
@synthesize player;

@synthesize filteredTracks;
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
            //CKATrackListViewController *trackListVC;
            //trackListVC = [[CKATrackListViewController alloc]
            //               initWithNibName:@"CKATrackListViewController"
            //               bundle:nil];
            
            
            // default
            tracks = (NSArray *)jsonResponse;
            
            
            /*
            // experimental
            //tracks = [NSArray arrayWithArray:(NSArray *)jsonResponse];
            tracks = [NSArray arrayWithObjects:
                       [CKATrack1 name: [tracks objectAtIndex:0]],
                       [CKATrack1 name: [tracks objectAtIndex:1]], nil];
            */
            
            //[self presentViewController:trackListVC
            //                  animated:YES completion:nil];
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
    
    self.favTracks = [BIDFavoritesList sharedFavoritesList].favorites;
    
    // Initialize the filteredCandyArray with a capacity equal to the candyArray's capacity
    //filteredTracks = [NSMutableArray arrayWithCapacity:[tracks count]];
    //filteredTracks = tracks;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if ([self.favoritesList.favorites count] > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    // Return the number of rows in the section.
    if (section == 0) {
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            return [filteredTracks count];
        } else {
            return [tracks count];
        }
    } else {
        return [self.favTracks count];
    }
    //return [self.tracks count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"All Tracks";
    } else {
        return @"My Favorite Tracks";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NormalCell = @"NormalCell";
    static NSString *FavoritesCell = @"FavoritesCell";
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:NormalCell];
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:NormalCell];
        }
    
        int row = indexPath.row;
        NSString *subtitle = [NSString stringWithFormat:@"%d", row];
        NSLog(@"row = %d", row);
        
        //Track for search
        // Create a new Track Object
        //CKATrack *searchTrack = nil;
        
        if (tableView == self.searchDisplayController.searchResultsTableView) {
            /*
            NSDictionary *track = [self.filteredTracks objectAtIndex:indexPath.row];
            cell.textLabel.text = [track objectForKey:@"title"];
            cell.detailTextLabel.text = subtitle;
            */
            
            NSDictionary *track = [filteredTracks objectAtIndex:indexPath.row];
            cell.textLabel.text = [track objectForKey:@"title"];
            cell.detailTextLabel.text = subtitle;
            
            // I'm losing my detail button when search is used
            //cell.accessoryType = UITableViewCellAccessoryDetailButton;
            
        }
        else {
            /*
            NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
            cell.textLabel.text = [track objectForKey:@"title"];
            cell.detailTextLabel.text = subtitle;
            */
            
            //self.searchTrack = nil;
            //searchTrack = [tracks objectAtIndex:indexPath.row];
            //NSDictionary *track = [self.filteredTracks objectAtIndex:indexPath.row];
            //cell.textLabel.text = [searchTrack.name objectForKey:@"title"];
            //cell.detailTextLabel.text = subtitle;
            //[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            NSDictionary *track = [tracks objectAtIndex:indexPath.row];
            cell.textLabel.text = [track objectForKey:@"title"];
            cell.detailTextLabel.text = subtitle;
            
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:FavoritesCell];
                                               //forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:FavoritesCell];
        }
        
        //NSDictionary *track = [self.tracks objectAtIndex:indexPath.row];
        //NSDictionary *track = [self.favTracks objectAtIndex:indexPath.row];
        //cell.textLabel.text = [track objectForKey:@"title"];
        
        //cell.textLabel.text = [self.favTracks objectAtIndex:indexPath.row];
        
        self.fav = [[self.favTracks objectAtIndex:indexPath.row] integerValue];
        NSDictionary *track = [self.tracks objectAtIndex:self.fav];
        cell.textLabel.text = [track objectForKey:@"title"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", self.fav];
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
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
    } else {
        int fav = [[self.favTracks objectAtIndex:indexPath.row] integerValue];
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
    
    int row = indexPath.row;
    //NSString *subtitle = [NSString stringWithFormat:@"%d", row];
    NSLog(@"row = %d", row);
    
    NSDictionary *track;
    NSString *titleLabel;
    if (self.tableView == self.searchDisplayController.searchResultsTableView) {
        track = [filteredTracks objectAtIndex:indexPath.row];
        titleLabel = [track objectForKey:@"title"];
    } else {
        track = [tracks objectAtIndex:indexPath.row];
        titleLabel = [track objectForKey:@"title"];
    }
    
    //infoVC.titleLabel = titleLabel;
    //infoVC.favorite = [[BIDFavoritesList sharedFavoritesList].favorites
    //                       containsObject:font.fontName];
    
    self.trackDesc = titleLabel;
    
    CKATrackInfoViewController *targetVC = (CKATrackInfoViewController*)segue.destinationViewController;
    targetVC.received = _trackDesc;
    targetVC.favoriteTrack = track;
    
    if (indexPath.section == 0) {
        id checkFav = [NSString stringWithFormat:@"%d", indexPath.row];
        targetVC.favorite = [[BIDFavoritesList sharedFavoritesList].favorites
                             containsObject:checkFav];
        BOOL check = [[BIDFavoritesList sharedFavoritesList].favorites
                      containsObject:checkFav];
        targetVC.returnPath = indexPath.row;
    } else {
        id checkFav = [NSString stringWithFormat:@"%d", self.fav];
        targetVC.favorite = [[BIDFavoritesList sharedFavoritesList].favorites
                             containsObject:checkFav];
        BOOL check = [[BIDFavoritesList sharedFavoritesList].favorites
                      containsObject:checkFav];
        targetVC.returnPath = self.fav;
    }
    
    // BID Set delegate reference
    CKATrackInfoViewController *controller = segue.destinationViewController;
    controller.delegate = self;
    
    // BID Fixup create an empty string and send it to Detail View
    NSNumber *s;
    [[segue destinationViewController] setDetailItem:s];
}

// BID define the delegated method that adds the returned string to the table and master view
- (void)detailViewController:(CKATrackInfoViewController *)detailViewController
           didToggleFavorite:(int)returnPathBack withState:(NSString *)state {
    NSLog(@"didToggleFavorite: %d - %@", returnPathBack, state);       // turn this off eventually
    
    /*
    if (returnPathBack) {
        [_objects addObject:returnPathBack];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_objects.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        UITableView *tableView = [self tableView];
        [tableView reloadData];
    }
    */
    [self.tableView reloadData];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    //[self.filteredTracks removeAllObjects];
    // Filter the array using NSPredicate
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    //filteredTracks = [NSMutableArray arrayWithArray:[tracks filteredArrayUsingPredicate:predicate]];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ['title'] contains[cd] %@",searchText];
    filteredTracks = [tracks filteredArrayUsingPredicate:predicate];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    /*
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    */
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
     // Return YES to cause the search result table view to be reloaded.
    return YES;
}

/*
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}
*/
 
@end
