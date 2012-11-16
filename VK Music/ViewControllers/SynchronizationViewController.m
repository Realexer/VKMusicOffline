//
//  SynchronizationViewController.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/28/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "SynchronizationViewController.h"
#import "AuthorizationViewController.h"
#import "VKMusicDB.h"
#import "VKAPIClient.h"

@interface SynchronizationViewController ()

@end

@implementation SynchronizationViewController

@synthesize songsTable;
@synthesize musicList;
@synthesize noAccessView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Resynch" style:UIBarButtonItemStyleDone target:self action:@selector(resynch:)] autorelease];
    
    downloadingManagers = [[NSMutableArray alloc] init];
}

-(IBAction) getAccess:(id)sender
{
    [self.navigationController pushViewController:[[[AuthorizationViewController alloc] init] autorelease] animated:YES];
}

-(IBAction)resynch:(UIBarButtonItem *)sender 
{
    [[VKMusicDB sharedInstance] deleteAllMusic];
    [self synch];
}

-(void) synch 
{
    //[[VKMusicDB sharedInstance] deleteAllMusic];
    
    NSArray *userMusic = nil;
//    @try {
//         userMusic = [[VKAPIClient sharedInstance] getUserMusic];
//    } @catch (NSException *exeption) {
//        [self.navigationController pushViewController:[[[AuthorizationViewController alloc] init] autorelease] animated:YES];
//        return;
//    }
    
    userMusic = [[VKAPIClient sharedInstance] getUserMusic];
    
    if(userMusic == nil)
    {
        noAccessView.hidden = NO;
        return;
    }

    
    if(![[VKMusicDB sharedInstance] saveMusic:userMusic]) {
        // could not save user music
    }
    
    // using music that we currently have in DB
    self.musicList = [[VKMusicDB sharedInstance] getAllMusic];

    for (Audio *audioItem in self.musicList) 
    {
        if(audioItem.lyrics == nil) 
        {
            NSString *lyrics = [[VKAPIClient sharedInstance] getAudioLyrics:audioItem];
            [[VKMusicDB sharedInstance] setAudioLyrics:lyrics forAudio:audioItem];
        }
    }

    
    
    for (int i = 0; i < [self.musicList count]; i++) 
    {
        Audio *audioItem = [self.musicList objectAtIndex:i];
        
        if(audioItem.downloaded == NO) 
        {
        
            FileDownloader *downloader = [[FileDownloader alloc] init];
            [downloader setDelegate:self];
            [downloader setTag:i];
            [downloader setAudio:audioItem];
            [downloader downloadAudioFile];
            [downloadingManagers addObject:[downloader autorelease]];
        }
    }
    
    [self.songsTable reloadData];
}

-(void) viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    
    noAccessView.hidden = YES;
    [self synch];
}

#pragma mark UITableViewDelegate

#pragma makr UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [self.musicList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *reuseIdentifier = @"test";
    
    UITableViewCell *musicTableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    

    Audio *audioItem = [self.musicList objectAtIndex:indexPath.row];

    for (UIView *cellSubview in musicTableCell.contentView.subviews) {
        [cellSubview removeFromSuperview];
    }
    
    UILabel *songName = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, musicTableCell.frame.size.width - 10, 18)];
    songName.tag = 10;
    songName.font = [UIFont systemFontOfSize:14];
    songName.textColor = [UIColor colorWithRed:153.0/255.0 green:51.0/255.0 blue:0 alpha:1.0];
    songName.text = [NSString stringWithFormat:@"%@ - %@", audioItem.artist, audioItem.title];
    [musicTableCell.contentView addSubview:songName];
    
    if([audioItem.downloaded boolValue] == NO) 
    {
        songName.textColor = [UIColor colorWithRed:65.0/255.0 green:103.0/255.0 blue:187.0/255.0 alpha:1.0];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.frame = CGRectMake(0, 25, musicTableCell.frame.size.width - 10, 10);
        progressView.progress = 0;
        progressView.tag = 5;
        [musicTableCell.contentView addSubview:progressView];        
    } 
    
    return [musicTableCell autorelease];
}


-(void) downloadingStarted:(FileDownloader*) client 
{
    
}

-(void) downloadingProgress:(FileDownloader*) client currentContentSize:(long long)currentContentSize 
{
    UITableViewCell *musicCell = [self.songsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:client.tag inSection:0]];
    if(musicCell) {
        UIProgressView *progressView = (UIProgressView *)[musicCell viewWithTag:5];
        progressView.progress = (float)currentContentSize/(float)client.expectedContentLength;
    }
}

-(void) downloadingFinished:(FileDownloader*) client 
{
    UITableViewCell *musicCell = [self.songsTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:client.tag inSection:0]];
    if(musicCell) {
        UILabel *songName = (UILabel *) [musicCell viewWithTag:10];
        songName.textColor = [UIColor colorWithRed:153.0/255.0 green:51.0/255.0 blue:0 alpha:1.0];
        
        [[musicCell viewWithTag:5] removeFromSuperview];
    }    
    
    [downloadingManagers removeObject:client];
}

-(void) downloadingFailed:(FileDownloader*) client 
{
    [downloadingManagers removeObject:client];
}    

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) dealloc 
{
    [super dealloc];
    [downloadingManagers removeAllObjects];
    [downloadingManagers release];
    [songsTable release];
    [musicList release];
}

@end
