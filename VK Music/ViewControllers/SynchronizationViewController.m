//
//  SynchronizationViewController.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/28/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "SynchronizationViewController.h"
#import "VKMusicDB.h"
#import "VKAPIClient.h"

@interface SynchronizationViewController ()

@end

@implementation SynchronizationViewController

@synthesize songsTable;
@synthesize musicList;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Resynch" style:UIBarButtonItemStyleDone target:self action:@selector(resynch:)] autorelease];
}

-(IBAction)resynch:(UIBarButtonItem *)sender 
{
    [[VKMusicDB sharedInstance] deleteAllMusic];
    [self synch];
}

-(void) synch 
{
    //[[VKMusicDB sharedInstance] deleteAllMusic];
    NSArray *userMusic = [[VKAPIClient sharedInstance] getUserMusic];
    
    if(![[VKMusicDB sharedInstance] saveMusic:userMusic]) {
        // could not save user music
    }
    
    // using music that we currently have in DB
    self.musicList = [[VKMusicDB sharedInstance] getAllMusic];
    
    
    for (int i = 0; i < [self.musicList count]; i++) 
    {
        Audio *audioItem = [self.musicList objectAtIndex:i];
        
        FileDownloader *downloader = [[FileDownloader alloc] init];
        [downloader setDelegate:self];
        [downloader setTag:i];
        [downloader setAudio:audioItem];
        [downloader downloadAudioFile];
    }
    
    [self.songsTable reloadData];
}

-(void) viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
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
    songName.textColor = [UIColor greenColor];
    songName.text = [NSString stringWithFormat:@"%@ - %@", audioItem.artist, audioItem.title];
    [musicTableCell.contentView addSubview:songName];
    
    if([audioItem.downloaded boolValue] == NO) 
    {
        songName.textColor = [UIColor blueColor];
        
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
        songName.textColor = [UIColor greenColor];
        
        [[musicCell viewWithTag:5] removeFromSuperview];
    }    
    
    [client release];
}

-(void) downloadingFailed:(FileDownloader*) client 
{
    [client autorelease];
}    

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
