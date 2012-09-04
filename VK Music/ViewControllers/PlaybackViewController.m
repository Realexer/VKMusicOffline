//
//  PlaybackViewController.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/31/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "PlaybackViewController.h"
#import <MediaPlayer/MPVolumeView.h>

@interface PlaybackViewController ()

@end

@implementation PlaybackViewController

@synthesize playButton, pauseButton, songTitle, songArtist, seekingSlider, volumeSlider, lyricsTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame:self.volumeSlider.frame];

    for (UIView *view in [myVolumeView subviews]) 
    {
        if ([[[view class] description] isEqualToString:@"MPVolumeSlider"]) {

            [(UISlider *)view setThumbTintColor:self.seekingSlider.thumbTintColor];
            [(UISlider *)view setMinimumTrackTintColor:self.seekingSlider.minimumTrackTintColor];
            [(UISlider *)view setMaximumTrackTintColor:self.seekingSlider.maximumTrackTintColor];
        }
    }
    
    [self.view addSubview: myVolumeView];
    [myVolumeView release];
    [volumeSlider removeFromSuperview];
    
    if([[[MusicPlayer sharedInstance] audioPlayer] isPlaying]) {
        self.playButton.hidden = YES;
    } else {
        self.playButton.hidden = NO;
    }
    
    [[MusicPlayer sharedInstance] showSongInfo];
    
    songTimingUpdating = [NSTimer scheduledTimerWithTimeInterval:0.23 target:self selector:@selector(updateSongTiming:) userInfo:nil repeats:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) playSong:(UIButton *)sender
{
    [[MusicPlayer sharedInstance] play]; 
    [playButton setHidden:YES];
    [pauseButton setHidden:NO];
}

-(IBAction) pauseSong:(UIButton *)sender
{
    [[MusicPlayer sharedInstance] pause]; 
    
    if([[[MusicPlayer sharedInstance] audioPlayer] isPlaying]){
        [playButton setHidden:YES];
        [pauseButton setHidden:NO];
    } else {
        [playButton setHidden:NO];
        [pauseButton setHidden:YES];
    }
}

-(IBAction) nextSong:(UIButton *)sender
{
    [[MusicPlayer sharedInstance] next]; 
}

-(IBAction) previousSong:(UIButton *)sender
{
    [[MusicPlayer sharedInstance] previous]; 
}

-(IBAction) seeking:(UISlider *) slider
{
    [[[MusicPlayer sharedInstance] audioPlayer] setCurrentTime:slider.value];
}

-(void) updateSongTiming:(NSTimer *) timer 
{
    self.seekingSlider.value = [[[MusicPlayer sharedInstance] audioPlayer] currentTime];
}

-(void) dealloc 
{
    [super dealloc];
    
    [songTimingUpdating invalidate];
    [playButton release];
    [pauseButton release];
    [songTitle release];
    [songArtist release];
    [volumeSlider release];
    [seekingSlider release];
}

@end
