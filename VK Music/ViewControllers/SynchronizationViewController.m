//
//  SynchronizationViewController.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/28/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "SynchronizationViewController.h"
#import "VKAPIClient.h"
#import "VKMusicDB.h"

@interface SynchronizationViewController ()

@end

@implementation SynchronizationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[VKMusicDB sharedInstance] deleteAllMusic];
    NSArray *musicList = [[VKAPIClient sharedInstance] getUserMusic];
    BOOL result = [[VKMusicDB sharedInstance] saveMusic:musicList];
    
    if(result) {
        NSArray *savedMusic = [[VKMusicDB sharedInstance] getAllMusic];
        NSLog(@"%@", savedMusic);
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
