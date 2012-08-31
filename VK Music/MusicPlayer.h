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


@interface MusicPlayer : NSObject 
{
    NSMutableArray *playlist;
}

+(MusicPlayer*) sharedInstance;

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, readonly) NSMutableArray *playlist;
@property (nonatomic) int currentSong;

-(void) setSongs:(NSArray *) songs;

-(void) play;
-(void) stop;
-(void) pause;

@end
