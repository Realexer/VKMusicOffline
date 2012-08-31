//
//  MusicPlayer.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/31/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "MusicPlayer.h"
#import "Audio.h"
#import "VKAPIClient.h"


// singleton
static MusicPlayer *sharedSingleton;


@implementation MusicPlayer

@synthesize audioPlayer, currentSong, playlist;


// syngleton initialization
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[MusicPlayer alloc] init];
    }
}

// public access
+ (MusicPlayer*) sharedInstance
{
    return sharedSingleton;
}

-(id) init
{
    self = [super init];
    
    self.audioPlayer = [[AVAudioPlayer alloc] init];
    playlist = [[NSMutableArray alloc] init];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    return self;
}

-(void) setSongs:(NSArray *) songs 
{   
    for (Audio *audioItem in songs) 
    {
        NSString *path = [[VKAPIClient sharedInstance] getAudioFilePath:audioItem];
        NSURL *songUrl = [NSURL fileURLWithPath:path];
        [playlist addObject:songUrl];
    }
}


-(void) play 
{
    [self.audioPlayer initWithContentsOfURL:[playlist objectAtIndex:currentSong] error:nil];
    [self.audioPlayer play];
}

-(void) pause 
{
    [self.audioPlayer pause];
}


-(void) stop 
{

}


-(void) dealloc 
{
    [super dealloc];
    [audioPlayer release];
}

@end
