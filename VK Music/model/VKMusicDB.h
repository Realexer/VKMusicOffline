//
//  VKMusicDB.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/28/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RHManagedObjectContextManager.h"
#import "Audio.h"

@interface VKMusicDB : NSObject

+(VKMusicDB*) sharedInstance;

-(BOOL) saveMusic:(NSArray *) musicList;
-(NSArray *) getAllMusic;
-(NSArray *) getDownloadedMusic;
-(BOOL) deleteAllMusic;
-(BOOL) setAudioDwonloaded:(Audio*) audioItem;
-(Audio *) getAudioById:(NSNumber*) aid;
-(BOOL) setAudioLyrics:(NSString *) lyrics forAudio:(Audio *) audioItem;

@end
