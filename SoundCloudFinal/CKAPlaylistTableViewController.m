//
//  CKAPlaylistTableViewController.m
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 12/1/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import "CKAPlaylistTableViewController.h"
#import "CKAViewController.h"
#import "SCUI.H"

@interface CKAPlaylistTableViewController ()

@end

@implementation CKAPlaylistTableViewController

@synthesize playlists;
@synthesize filteredPlaylists;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [playlists count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // Name title
    return @"All Playlists";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *NormalCell = @"NormalCell";
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:NormalCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:NormalCell];
    }
        
    int row = [[NSNumber numberWithLong:indexPath.row] intValue];
    NSString *subtitle = [NSString stringWithFormat:@"%d", row];
    NSLog(@"row = %d", row);
    
    NSDictionary *playlist = [playlists objectAtIndex:indexPath.row];
    cell.textLabel.text = [playlist objectForKey:@"title"];
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    /*
    // For playlist navigation to tracklist
    CKAPlaylistTableViewController *infoVC = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    CKATrackListTableViewController *targetVC = (CKATrackListTableViewController*)segue.destinationViewController;
    
    NSDictionary *playlist = [playlists objectAtIndex:indexPath.row];
    targetVC.playlist = [playlist objectForKey:@"id"];
    
    int index = indexPath.row;
    targetVC.index = index;
    */
}

@end
