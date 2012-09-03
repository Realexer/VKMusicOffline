//
//  AppDelegate.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/27/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicPlayer.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

+(AppDelegate*) sharedInstance 
{
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.window makeKeyAndVisible];

    return YES;
}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent 
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        
        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:
                [[MusicPlayer sharedInstance] play];
                break;
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [[MusicPlayer sharedInstance] pause];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                 [[MusicPlayer sharedInstance] previous];
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                [[MusicPlayer sharedInstance] next];
                break;
                
            default:
                break;
        }
    }
}

@end
