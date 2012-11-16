//
//  FileManager.h
//  VK Music
//
//  Created by Vitaliy Volokh on 9/4/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Audio.h"

@interface FileManager : NSObject
+(FileManager*) sharedInstance;
//
-(BOOL) saveAudioFile:(NSData*) fileData ofAudioItem:(Audio *) audioItem;
//
-(NSString *) getAudioFilePath:(Audio *) audioItem;
//
-(BOOL) deleteAudioFile:(Audio *) audioItem;
@end
