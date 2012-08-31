//
//  ViewController.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/27/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "SongsListViewController.h"
#import "AuthorizationViewController.h"
#import "SynchronizationViewController.h"
#import "VKMusicDB.h"
#import "PlaybackViewController.h"

@interface SongsListViewController ()

@end

@implementation SongsListViewController
@synthesize songsList, songsTable;


@synthesize apiClient;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(authorize:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStyleBordered target:self action:@selector(synchronize:)];
    
    if([[VKAPIClient sharedInstance] getUserAuthData] == nil) 
    {
        [self.navigationController pushViewController:[[AuthorizationViewController alloc] init] animated:YES];
    }    
    
}

-(void) viewDidAppear:(BOOL)animated 
{
    if(songsList) {
        [songsList release];
        songsList = nil;
    }
    
    self.songsList = [[VKMusicDB sharedInstance] getAllMusic];
    
    [self.songsTable reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [songsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *reuseIdentifier = @"test";
    
    UITableViewCell *musicTableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    Audio *audioItem = [self.songsList objectAtIndex:indexPath.row];
    
    for (UIView *cellSubview in musicTableCell.contentView.subviews) {
        [cellSubview removeFromSuperview];
    }
    
    UILabel *songName = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, musicTableCell.frame.size.width - 10, 18)];
    songName.font = [UIFont systemFontOfSize:14];
    songName.textColor = [UIColor greenColor];
    songName.text = [NSString stringWithFormat:@"%@ - %@", audioItem.artist, audioItem.title];
    [musicTableCell.contentView addSubview:songName];
        
    return [musicTableCell autorelease];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [[MusicPlayer sharedInstance] setSongs:self.songsList];
    [self.navigationController pushViewController:[[PlaybackViewController alloc] init] animated:YES];
    [[MusicPlayer sharedInstance] setCurrentSong:indexPath.row];
    [[MusicPlayer sharedInstance] play];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void) dealloc 
{
    [super dealloc];
}


-(IBAction) synchronize:(id)sender 
{
    [self.navigationController pushViewController:[[SynchronizationViewController alloc] init] animated:YES];
}

-(IBAction) authorize:(id)sender 
{
    [self.navigationController pushViewController:[[AuthorizationViewController alloc] init] animated:YES];
}


@end
