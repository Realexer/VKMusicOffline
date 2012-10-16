//
//  PlaybackViewController.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/31/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayer.h"


@interface PlaybackViewController : UIViewController 
{
    NSTimer *songTimingUpdating;
    BOOL seeking;
}

@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *pauseButton;
@property (nonatomic, retain) IBOutlet UILabel *songTitle;
@property (nonatomic, retain) IBOutlet UILabel *songArtist;

@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@property (nonatomic, retain) IBOutlet UISlider *seekingSlider;
@property (nonatomic, retain) IBOutlet UITextView *lyricsTextView;


-(IBAction) playSong:(UIButton *)sender;
-(IBAction) pauseSong:(UIButton *)sender;
-(IBAction) nextSong:(UIButton *)sender;
-(IBAction) previousSong:(UIButton *)sender;

-(IBAction) seekingStarted:(id)sender;
-(IBAction) seekingEnded:(id)sender;
-(IBAction) seeking:(UISlider*)sender;

-(void) updateSongTiming:(NSTimer *) timer;

@end
