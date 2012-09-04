//
//  FileDownloader.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/30/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Audio.h"

@class FileDownloader;

@protocol FileDownloaderDelegate <NSObject>

-(void) downloadingStarted:(FileDownloader*) client;
-(void) downloadingProgress:(FileDownloader*) client currentContentSize:(long long)currentContentSize;
-(void) downloadingFinished:(FileDownloader*) client;
-(void) downloadingFailed:(FileDownloader*) client;

@end



@interface FileDownloader : NSObject<NSURLConnectionDelegate>

@property (retain, nonatomic) NSObject<FileDownloaderDelegate>* delegate;
@property (nonatomic) long long expectedContentLength;
@property (nonatomic) long long currentContentLength;
@property (nonatomic, retain) NSMutableData *downloadedData;
@property (nonatomic) int tag;
@property (nonatomic, retain) Audio *audio;

-(BOOL) downloadAudioFile;

@end
