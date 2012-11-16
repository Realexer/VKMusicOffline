//
//  FileManager.m
//  VK Music
//
//  Created by Vitaliy Volokh on 9/4/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "FileManager.h"

// singleton
static FileManager *sharedSingleton;

@implementation FileManager


// syngleton initialization
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[FileManager alloc] init];
    }
}

// public access
+(FileManager*) sharedInstance
{
    return sharedSingleton;
}


//
-(NSString *) getAudioFilePath:(Audio *) audioItem 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ - %@.mp3", 
                                                               [audioItem.artist stringByReplacingOccurrencesOfString:@"/" withString:@"|"], 
                                                               [audioItem.title stringByReplacingOccurrencesOfString:@"/" withString:@"|"]]];
}


-(BOOL) saveAudioFile:(NSData*) fileData ofAudioItem:(Audio *) audioItem 
{
    return [[NSFileManager defaultManager] createFileAtPath:[self getAudioFilePath:audioItem]
                                            contents:fileData
                                          attributes:nil];
}


-(BOOL) deleteAudioFile:(Audio *) audioItem 
{
    NSError *error;
    return [[NSFileManager defaultManager] removeItemAtPath:[self getAudioFilePath:audioItem] error:&error];
}

@end
