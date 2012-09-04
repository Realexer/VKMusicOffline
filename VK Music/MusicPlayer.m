//
//  MusicPlayer.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/31/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "MusicPlayer.h"
#import "VKAPIClient.h"
#import "FileManager.h"
#import "AppDelegate.h"
#import "PlaybackViewController.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>


// singleton
static MusicPlayer *musicSingleton;


@implementation MusicPlayer

@synthesize audioPlayer, currentSong, playlist;


// syngleton initialization
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        musicSingleton = [[MusicPlayer alloc] init];
    }
}


// public access
+ (MusicPlayer*) sharedInstance
{
    return musicSingleton;
}


-(id) init
{
    self = [super init];
    
    playlist = [[NSMutableArray alloc] init];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    return self;
}


-(void) setSongs:(NSArray *) songs 
{   
    [playlist removeAllObjects];
    for (Audio *audioItem in songs) 
    {
        [playlist addObject:audioItem];
    }
}


-(Audio*) getCurrentSong 
{
    Audio *currentSongItem = nil;
    
    if(currentSong >= 0 && [playlist count] > currentSong) 
    {
        currentSongItem = [playlist objectAtIndex:currentSong];
    } 
    
    return currentSongItem;
}


-(NSURL *) getCurrentSongURL
{
    NSURL *currentSongURL = nil;
    
    if(currentSong >= 0 && [playlist count] > currentSong) 
    {
        NSString *path = [[FileManager sharedInstance] getAudioFilePath:[self getCurrentSong]];
        currentSongURL = [NSURL fileURLWithPath:path];
    } 
    
    return currentSongURL;
}


-(void) play 
{
    
    if([audioPlayer url] != nil && [audioPlayer isPlaying]) 
    {
        [audioPlayer stop];
    }
    
    NSError *playingError = nil;
    if(!audioPlayer) {
        audioPlayer = [AVAudioPlayer alloc];
    }
    [audioPlayer initWithContentsOfURL:[self getCurrentSongURL] error:&playingError];
    
    if(playingError == nil) 
    {
        [audioPlayer setDelegate:self];
        [audioPlayer play];
        [self showSongInfo];
    } else {
        audioPlayer = nil;
        currentSong = 0;
    }
}

-(void) next 
{
    currentSong++;
    [self play];
}

-(void) previous 
{
    currentSong--;
    [self play];
}

-(void) pause 
{
    if([audioPlayer isPlaying]) {
        [audioPlayer pause];
    } else {
        [audioPlayer play];
    }
}


-(void) stop 
{

}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag 
{
    [self next];
}

-(void) showSongInfo
{
    if([self getCurrentSong]) 
    {
        UIViewController *currentViewController = [[[AppDelegate sharedInstance] navigationController] topViewController];
        
        if([currentViewController isKindOfClass:[PlaybackViewController class]]) 
        {
            ((PlaybackViewController*) currentViewController).songTitle.text = [[self getCurrentSong] title];
            ((PlaybackViewController*) currentViewController).songArtist.text = [[self getCurrentSong] artist];
            ((PlaybackViewController*) currentViewController).seekingSlider.minimumValue = 0;
            ((PlaybackViewController*) currentViewController).seekingSlider.maximumValue = [[[MusicPlayer sharedInstance] audioPlayer] duration];
            ((PlaybackViewController*) currentViewController).lyricsTextView.text = [[self getCurrentSong] lyrics];
        }

        NSArray *keys = [NSArray arrayWithObjects:MPMediaItemPropertyTitle, MPMediaItemPropertyArtist, nil];
        NSArray *values = [NSArray arrayWithObjects:[[self getCurrentSong] title], [[self getCurrentSong] artist],  nil];
        NSDictionary *mediaInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];
    }

}


-(void) dealloc 
{
    [super dealloc];
    [audioPlayer release];
    [playlist release];
}

@end
