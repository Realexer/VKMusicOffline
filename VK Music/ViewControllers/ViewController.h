//
//  ViewController.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/27/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioSession.h>
#import "VKAPIClient.h"

@interface ViewController : UIViewController

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, retain) VKAPIClient *apiClient;

-(IBAction) playMusic:(UIButton *)sender;
-(IBAction) pauseMusic:(UIButton *)sender;

@end
