//
//  VKAPIClient.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/27/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Audio.h"


@interface VKAPIClient : NSObject

// 
+(VKAPIClient *) sharedInstance;
//
-(void) saveUserAuthData:(NSDictionary *) user;
//
-(NSDictionary*) getUserAuthData;
//
-(NSArray*) getUserMusic;
//
-(NSString*) getAudioLyrics:(Audio*) audioItem;

@end
