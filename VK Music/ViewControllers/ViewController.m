//
//  ViewController.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/27/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "ViewController.h"
#import "AuthorizationViewController.h"
#import "SynchronizationViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize audioPlayer;
@synthesize apiClient;

-(id) init 
{
    self = [super init];
    
    return self;
}

- (void)viewDidLoad
{
    
//    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"10. Space Bound" ofType:@"mp3"]];
//    
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
//    
//    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//    [[AVAudioSession sharedInstance] setActive: YES error: nil];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [super viewDidLoad];
    
//    if([[VKAPIClient sharedInstance] user] == nil) 
//    {
//        [self.navigationController pushViewController:[[AuthorizationViewController alloc] init] animated:YES];
//    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(authorize:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sync" style:UIBarButtonItemStyleBordered target:self action:@selector(synchronize:)];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void) dealloc 
{
    [super dealloc];
    [audioPlayer release];
}


-(IBAction) playMusic:(UIButton *)sender 
{
    //[audioPlayer play]; 
}

-(IBAction) pauseMusic:(UIButton *)sender 
{
    [audioPlayer pause]; 
}


-(IBAction) synchronize:(id)sender 
{
    [self.navigationController pushViewController:[[SynchronizationViewController alloc] init] animated:YES];
}

-(IBAction) authorize:(id)sender 
{
    [self.navigationController pushViewController:[[AuthorizationViewController alloc] init] animated:YES];
}


@end
