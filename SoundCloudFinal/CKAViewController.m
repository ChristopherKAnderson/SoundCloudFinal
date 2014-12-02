//
//  CKAViewController.m
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/6/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import "BIDFavoritesList.h"
#import "CKAViewController.h"
#import "CKAFlipsideViewController.h"
#import "SCUI.h"
#import <sqlite3.h>

@interface CKAViewController () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    
    // to store audio file titles in db
    NSMutableArray *_objects;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *trackPicker;

@end

@implementation CKAViewController

// Default User Settings - Setup
- (void)refreshFields {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.titleLabel.text = [defaults objectForKey:kTitle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshFields];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:app];
}

- (void)applicationWillEnterForeground: (NSNotification *) notification {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    [self refreshFields];
}

// CKA setup sqlite3 data file path
- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Refresh User Default Settings
    [self refreshFields];
    
    /////////////////////////////////////////////////////////////////////////////////////////
    
    // CKA setup sqlite3 - open database
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    // CKA setup sqlite3 - create table
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS NAMES "
    "(ROW INTEGER PRIMARY KEY, NAME_DATA TEXT);";
    char *errorMsg;
    if (sqlite3_exec (database, [createSQL UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Error creating table: %s", errorMsg);
    }
    NSString *query = @"SELECT ROW, NAME_DATA FROM NAMES ORDER BY ROW";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *rowData = (char *)sqlite3_column_text(statement, 1);
            NSString *fieldValue = [[NSString alloc] initWithUTF8String:rowData];
            if (!_objects) {
                _objects = [[NSMutableArray alloc] init];
            }
            [_objects addObject:fieldValue];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    // CKA setup app to resign active state when exiting app
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(applicationWillResignActive:)
     name:UIApplicationWillResignActiveNotification object:app];
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:NO];
    
    // update meters
    self.currentTimeUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                              target:self selector:@selector(updateMeter)
                                                            userInfo:NULL repeats:YES];
}

// CKA build resign active method
- (void)applicationWillResignActive:(NSNotification *)notification
{
    // open database
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    // preparet statement to get row count from database
    sqlite3_stmt *stmt;
    int rowsDB = 0;
    long rowsObjects = [_objects count];
    NSString *countRows = @"SELECT COUNT (*) FROM NAMES;";
    if (sqlite3_prepare_v2(database, [countRows UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        if (sqlite3_step(stmt) != SQLITE_ERROR) {
            rowsDB = sqlite3_column_int(stmt, 0);
        }
        sqlite3_finalize(stmt);
    }
    
    // sync mutable objects array with rows in database
    for (int i = 0; i < rowsObjects; i ++) {
        NSString *field = _objects[i];
        char *update = "INSERT OR REPLACE INTO NAMES (ROW, NAME_DATA) "
        "VALUES (?, ?);";
        char *errorMsg = NULL;
        if (sqlite3_prepare_v2(database, update, -1, &stmt, nil) == SQLITE_OK) {
            sqlite3_bind_int(stmt, 1, i);
            sqlite3_bind_text(stmt, 2, [field UTF8String], -1, NULL);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE) {
            NSAssert(0, @"Error updating table: %s", errorMsg);
        }
        sqlite3_finalize(stmt);
    }
    
    /*
    // check to see if there are more rows in the DB than in the objects array
    // if so, then delete rows in the DB that are no longer in the objects array
    if (rowsDB > rowsObjects) {
        for (int i = rowsObjects; i < rowsDB; i++) {
            NSString *deleteSQL = [NSString stringWithFormat: @"DELETE FROM NAMES WHERE ROW=%d", i];
            //char *delete_stmt = [deleteSQL UTF8String];
            char *errorMsg = NULL;
            sqlite3_stmt *stmt;
            if (sqlite3_prepare_v2(database, [deleteSQL UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
                //sqlite3_bind_int(stmt, 1, i);
                if (sqlite3_step(stmt) != SQLITE_DONE) {
                    NSAssert(0, @"Error updating table: %s", errorMsg);
                }
            }
            sqlite3_finalize(stmt);
        }
    }
    */
    
    sqlite3_close(database);
}

- (void) setupAudioRecord {
    // Set Audio File
    NSString *fileName = [NSString stringWithFormat:@"%@.aac", self.name.text];
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], fileName, nil];
    self.outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    // Set Up Audio Session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:self.outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backgroundTap:(id)sender {
    [self.name resignFirstResponder];
    
}

- (IBAction) login:(id) sender
{
    SCLoginViewControllerCompletionHandler handler = ^(NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Done!");
        }
    };
    
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController
                               loginViewControllerWithPreparedURL:preparedURL
                               completionHandler:handler];
        //[self presentModalViewController:loginViewController animated:YES];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }];
}

- (IBAction)upload:(id)sender
{
    // sandbox document directory
    NSURL *trackURL = self.outputFileURL;
    
    SCShareViewController *shareViewController;
    SCSharingViewControllerCompletionHandler handler;
    
    handler = ^(NSDictionary *trackInfo, NSError *error) {
        if (SC_CANCELED(error)) {
            NSLog(@"Canceled!");
        } else if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        } else {
            NSLog(@"Uploaded track: %@", trackInfo);
        }
    };
    
    shareViewController = [SCShareViewController
                           shareViewControllerWithFileURL:trackURL
                           completionHandler:handler];
    [shareViewController setTitle:@"Example Sound"];
    [shareViewController setPrivate:YES];
    //[self presentModalViewController:shareViewController animated:YES];
    [self presentViewController:shareViewController animated:YES completion:nil];
}

- (IBAction)selectTrack:(id)sender {
    
    NSInteger row = [self.trackPicker selectedRowInComponent:0];
    NSString *selected = _objects[row];
    NSString *title = [[NSString alloc] initWithFormat:
                       @"You selected %@!", selected];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:@"Upload Stored Track"
                                                   delegate:nil
                                          cancelButtonTitle:@"Selection Changed"
                                          otherButtonTitles:nil];
    [alert show];
    
    // Set Audio File
    self.name.text = selected;
    NSString *fileName = [NSString stringWithFormat:@"%@.aac", self.name.text];
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], fileName, nil];
    self.outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
}

- (IBAction)playTapped:(id)sender {
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.outputFileURL error:nil];
        [player setDelegate:self];
        [player play];
    }
}

- (IBAction)recordPauseTapped:(id)sender {
    // resign to first responder
    [self.name resignFirstResponder];
    
    // check if user entered track name in text field
    if ([self.name.text  isEqual: @""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Warning"
                                                        message: @"Enter A Track Name!"
                                                       delegate: nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        // setup up recorder
        [self setupAudioRecord];
    
        // Stop the audio player before recording
        if (player.playing) {
            [player stop];
        }
    
        if (!recorder.recording) {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setActive:YES error:nil];
        
            // Start recording
            [recorder record];
            [self.recordPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
        
        } else {
        
            // Pause recording
            [recorder pause];
            [self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
        }
    
        [self.stopButton setEnabled:YES];
        [self.playButton setEnabled:NO];
    }
}

- (IBAction)stopTapped:(id)sender {
    [recorder stop];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    [self.recordPauseButton setTitle:@"Record" forState:UIControlStateNormal];
    
    [self.stopButton setEnabled:NO];
    [self.playButton setEnabled:YES];
    
    // store in db
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects addObject:self.name.text];
    
    [self.trackPicker reloadAllComponents];
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) updateMeter {
    
    // setup meters for recording
    float level = 0;
    double currentTime = recorder.currentTime;
    
    if (recorder == nil) {
        self.meter.text = @"";
    } else if (!recorder.isRecording) {
        [recorder updateMeters];
        level = [recorder peakPowerForChannel:1];
        self.meter.text = [NSString stringWithFormat: @"Recording  %02d:%02d\ndb:%.02f",
                                 (int) currentTime/60,
                                 (int) currentTime%60,
                                       level];
    } else {
        [recorder updateMeters];
        level = [recorder peakPowerForChannel:1];
        self.meter.text = [NSString stringWithFormat: @"Recording %02d:%02d\ndb:%.02f",
                                 (int) currentTime/60,
                                 (int) currentTime%60,
                                       level];
        [recorder updateMeters];
    }
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_objects count];
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _objects[row];
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(CKAFlipsideViewController *)controller
{
    [self refreshFields];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}


@end
