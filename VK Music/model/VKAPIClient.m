//
//  VKAPIClient.m
//  VK Music
//
//  Created by Vitaliy Volokh on 8/27/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import "VKAPIClient.h"
#import "XMLReaderDef.h"

// singleton
static VKAPIClient *sharedSingleton;
static NSString *_userAuthDataKey = @"userAuthData";

@implementation VKAPIClient

// syngleton initialization
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sharedSingleton = [[VKAPIClient alloc] init];
    }
}

// public access
+ (id) sharedInstance
{
    return sharedSingleton;
}

// auth
-(void) saveUserAuthData:(NSDictionary *) user 
{
    [[NSUserDefaults standardUserDefaults] setValue:user forKey:_userAuthDataKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSDictionary*) getUserAuthData 
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:_userAuthDataKey];
}


// music management
-(NSArray*) getUserMusic
{
    if([self getUserAuthData] == nil) {
        // alarm
        return nil;
    }
    
    NSMutableArray* musicList = [[NSMutableArray alloc] init];
    
    @try {
        
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.vk.com/method/audio.get.xml?uid=%@&access_token=%@", [[self getUserAuthData] objectForKey:@"user_id"], [[self getUserAuthData] objectForKey:@"access_token"]]];
        
        NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url];
        NSURLResponse* response = nil;
        NSError* error = nil;
        
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if(error) {
            // alarm
            return nil;
        }
        
        NSDictionary *result = [XMLReaderDef dictionaryForXMLData:responseData error:&error];
        [musicList addObjectsFromArray:[[result objectForKey:@"response"] objectForKey:@"audio"]];
        
        if(error) {
            // alarm
            return nil;
        }

    }
    @catch (NSException *exception) {
        // alarm
        return nil;
    }
    @finally {
        
    }
    
    return [musicList autorelease];    
}


-(NSString *) getAudioFilePath:(Audio *) audioItem 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ - %@.mp3", audioItem.artist, audioItem.title]];
}


-(BOOL) saveAudioFile:(NSData*) fileData ofAudioItem:(Audio *) audioItem 
{
    return [fileData writeToFile:[self getAudioFilePath:audioItem] atomically:NO];
}


-(BOOL) deleteAudioFile:(Audio *) audioItem 
{
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    return [fileMgr removeItemAtPath:[self getAudioFilePath:audioItem] error:&error];
}



@end
