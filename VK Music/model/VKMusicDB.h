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
-(BOOL) deleteAllMusic;

@end
