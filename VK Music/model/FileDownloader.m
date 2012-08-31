//
//  FileDownloader.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/30/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "FileDownloader.h"
#import "VKMusicDB.h"
#import "VKAPIClient.h"

@implementation FileDownloader

@synthesize delegate, 
expectedContentLength, 
currentContentLength, 
downloadedData,
tag, audio;


-(BOOL) downloadAudioFile
{
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.audio.url]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    [connection start];
    
    return true;
}

#pragma mark downloading delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [downloadedData appendData:data];
    
    self.currentContentLength += (long long)data.length;
    [delegate downloadingProgress:self currentContentSize:self.currentContentLength];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    downloadedData = [[NSMutableData alloc] init];
    self.expectedContentLength = response.expectedContentLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    if(self.currentContentLength == self.expectedContentLength) 
    {
        [[VKAPIClient sharedInstance] saveAudioFile:self.downloadedData ofAudioItem:self.audio];
        [[VKMusicDB sharedInstance] setAudioDwonloaded:self.audio];
        [delegate downloadingFinished:self];
    }
}

-(void) dealloc 
{
    [super dealloc];
    [downloadedData release];
}


@end
