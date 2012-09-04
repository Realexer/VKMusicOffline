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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(authorize:)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStyleBordered target:self action:@selector(synchronize:)] autorelease];
    
    if([[VKAPIClient sharedInstance] getUserAuthData] == nil) 
    {
        [self.navigationController pushViewController:[[[AuthorizationViewController alloc] init] autorelease] animated:YES];
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
    
    UILabel *songTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, musicTableCell.frame.size.width - 10, 18)];
    songTitle.font = [UIFont boldSystemFontOfSize:16];
    songTitle.textColor = [UIColor colorWithRed:153.0/255.0 green:51.0/255.0 blue:0 alpha:1.0];
    songTitle.text = audioItem.title;
    songTitle.backgroundColor = [UIColor clearColor];
    [musicTableCell.contentView addSubview:songTitle];
    [songTitle release];
    
    UILabel *songArtist = [[UILabel alloc] initWithFrame:CGRectMake(5, 23, musicTableCell.frame.size.width - 10, 14)];
    songArtist.font = [UIFont systemFontOfSize:12];
    songArtist.textColor = [UIColor colorWithRed:153.0/255.0 green:51.0/255.0 blue:0 alpha:1.0];
    songArtist.text = audioItem.artist;
    songArtist.backgroundColor = [UIColor clearColor];
    [musicTableCell.contentView addSubview:songArtist];
    [songArtist release];
        
    return [musicTableCell autorelease];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    [[MusicPlayer sharedInstance] setSongs:self.songsList];
    [[MusicPlayer sharedInstance] setCurrentSong:indexPath.row];
    [[MusicPlayer sharedInstance] play];
    [self.navigationController pushViewController:[[PlaybackViewController alloc] init] animated:YES];
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
    [songsTable release];
    [songsList release];
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
