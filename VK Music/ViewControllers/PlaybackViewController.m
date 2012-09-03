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

@synthesize playButton, pauseButton, songTitle, songArtist, seekingSlider, volumeSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MPVolumeView *myVolumeView = [[MPVolumeView alloc] initWithFrame:self.volumeSlider.frame];
    [self.view addSubview: myVolumeView];
    [myVolumeView release];
    [volumeSlider removeFromSuperview];
}

-(void) viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
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
    [playButton setHidden:NO];
    [pauseButton setHidden:YES];
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
    
}

@end
