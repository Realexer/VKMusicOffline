//
//  AppDelegate.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/27/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaybackViewController.h"

@class SongsListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+(AppDelegate*) sharedInstance;

@property (retain, nonatomic) IBOutlet UIWindow *window;

@property (retain, nonatomic) IBOutlet UINavigationController *navigationController;
@property (retain, nonatomic) PlaybackViewController *playbackController;

@end
