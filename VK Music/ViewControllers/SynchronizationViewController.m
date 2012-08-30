//
//  SynchronizationViewController.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/28/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "SynchronizationViewController.h"
#import "VKMusicDB.h"
#import "VKAPIClient.h"

@interface SynchronizationViewController ()

@end

@implementation SynchronizationViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    
    [[VKMusicDB sharedInstance] deleteAllMusic];
    NSArray *musicList = [[VKAPIClient sharedInstance] getUserMusic];
    BOOL result = [[VKMusicDB sharedInstance] saveMusic:musicList];
    
    if(result) 
    {
        NSArray *savedMusic = [[VKMusicDB sharedInstance] getAllMusic];
        NSLog(@"%@", savedMusic);
        
        for (int i = 0; i < [savedMusic count]; i++) 
        {
            Audio *audioItem = [savedMusic objectAtIndex:i];
            
            UILabel *audioName = [[UILabel alloc] initWithFrame:CGRectMake(0, i * 30, self.view.frame.size.width, 14)];
            [audioName setFont:[UIFont systemFontOfSize:14]];
            audioName.text = [NSString stringWithFormat:@"%@ - %@", audioItem.artist, audioItem.title];
            [self.view addSubview:audioName];
            
            if([audioItem.downloaded boolValue] == NO) {
            
                UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
                progressView.frame = CGRectMake(0, (i * 30) + 15 , self.view.frame.size.width, 10);
                progressView.tag = i + 100;
                progressView.progress = 0;
                [self.view addSubview:progressView];
                
                FileDownloader *downloader = [[FileDownloader alloc] init];
                [downloader setDelegate:self];
                [downloader setTag:progressView.tag];
                [downloader downloadAudioFile:audioItem];
            } else {
                // downloaded
                UILabel *downloaded = [[UILabel alloc] init];
                downloaded.frame = CGRectMake(50, (i * 30) + 15 , self.view.frame.size.width, 10);
                audioName.text = @"Downloaded";
                [self.view addSubview:downloaded];
            }
        }
    }
}


-(void) downloadingStarted:(FileDownloader*) client 
{
    
}

-(void) downloadingProgress:(FileDownloader*) client currentContentSize:(long long)currentContentSize 
{
    UIProgressView *progressView = (UIProgressView *)[self.view viewWithTag:client.tag];
    progressView.progress = (float)currentContentSize/(float)client.expectedContentLength;
}

-(void) downloadingFinished:(FileDownloader*) client 
{

}

-(void) downloadingFailed:(FileDownloader*) client 
{
    [client autorelease];
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
