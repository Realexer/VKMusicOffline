//
//  MusicPlayer.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/31/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVPlayerItem.h>
#import "Audio.h"

@interface MusicPlayer : NSObject <AVAudioPlayerDelegate>
{
    NSMutableArray *playlist;
    AVAudioPlayer *audioPlayer;
    int currentSong;
}

+(MusicPlayer*) sharedInstance;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, readonly) NSMutableArray *playlist;
@property (nonatomic) int currentSong;

-(void) setSongs:(NSArray *) songs;
-(Audio *) getCurrentSong;
-(NSURL *) getCurrentSongURL;
-(void) showSongInfo;

-(void) play;
-(void) pause;
-(void) next;
-(void) previous;


@end
