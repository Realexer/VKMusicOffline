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
#import <AudioToolbox/AudioServices.h>


void audioRouteChangeListenerCallback
(void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize, const void *inPropertyValue )
{
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
 
        CFDictionaryRef routeChangeDictionary = inPropertyValue;
        CFNumberRef routeChangeReasonRef =
        CFDictionaryGetValue (routeChangeDictionary, CFSTR (kAudioSession_AudioRouteChangeKey_Reason));
        
        SInt32 routeChangeReason;
        CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
        
        if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
        {
            // our case
            [[MusicPlayer sharedInstance] togglePlay];
        }
}


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

    seekingStep = 0.0;
    
    // audio route changes
    AudioSessionPropertyID routeChangeID = kAudioSessionProperty_AudioRouteChange;
    AudioSessionAddPropertyListener(routeChangeID, audioRouteChangeListenerCallback, nil);

    
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
        [audioPlayer setEnableRate:YES];
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

-(void) togglePlay 
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

-(void) _increaseSeekingStep:(NSTimer *) timer
{
//    int maxStep = 30;
//    int minStep = -30;
    
    if([[timer userInfo] boolValue]) {
        seekingStep += 0.5;
    } else {
        seekingStep -= 0.5;
    }
    
    //seekingStep = MAX(MIN(seekingStep, maxStep), minStep);
    
    [self _seeking];
}

-(void) _startSeeking:(BOOL) direction
{
    [audioPlayer setRate:1.5];
    seekingTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(_increaseSeekingStep:) userInfo:[NSNumber numberWithBool:direction] repeats:YES];
}

-(void) _stopSeeking
{
    [seekingTimer invalidate];
    seekingTimer = nil;

    seekingStep = 0.0;
    [audioPlayer setRate:1.0];
    //[self _seeking];
}

-(void) _seeking
{
    [audioPlayer setCurrentTime:[audioPlayer currentTime] + seekingStep];
    NSLog(@"Seeking step equils: %f", seekingStep);
}


-(void) startSeekingForward
{
    [self _startSeeking:YES];
}

-(void) startSeekingBackward
{
    [self _startSeeking:NO];
}

-(void) stopSeekingForward
{
    [self _stopSeeking];
}

-(void) stopSeekingBackward
{
    [self _stopSeeking];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag 
{
    [self next];
}


-(void) showSongInfo
{
    if([self getCurrentSong]) 
    {
     
        [[AppDelegate sharedInstance] playbackController].songTitle.text = [[self getCurrentSong] title];
        [[AppDelegate sharedInstance] playbackController].songArtist.text = [[self getCurrentSong] artist];
        [[AppDelegate sharedInstance] playbackController].seekingSlider.minimumValue = 0;
        [[AppDelegate sharedInstance] playbackController].seekingSlider.maximumValue = [[[MusicPlayer sharedInstance] audioPlayer] duration];
        [[AppDelegate sharedInstance] playbackController].lyricsTextView.text = [[self getCurrentSong] lyrics];

        NSArray *keys = [NSArray arrayWithObjects:MPMediaItemPropertyTitle, MPMediaItemPropertyArtist, nil];
        NSArray *values = [NSArray arrayWithObjects:[[self getCurrentSong] title], [[self getCurrentSong] artist],  nil];
        NSDictionary *mediaInfo = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:mediaInfo];
    }

}

#pragma makr AVAudioSessionDelegate
- (void)beginInterruption
{
    [audioPlayer pause];
}

- (void)endInterruption
{
    [audioPlayer play];
}


-(void) dealloc 
{
    [super dealloc];
    [audioPlayer release];
    [playlist release];
}

@end
