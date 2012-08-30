//
//  VKMusicDownloader.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/30/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "VKMusicDownloader.h"

static VKMusicDB *sharedSingleton;

@implementation VKMusicDownloader

// syngleton initialization
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[VKMusicDB alloc] init];
    }
}

+(VKMusicDB*) sharedInstance 
{
    return sharedSingleton;
}


@end
