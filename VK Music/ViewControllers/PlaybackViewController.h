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

-(IBAction) playMusic:(UIButton *)sender;
-(IBAction) pauseMusic:(UIButton *)sender;

@end
