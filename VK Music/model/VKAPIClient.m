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

@implementation VKAPIClient

@synthesize user;

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


-(NSArray*) getUserMusic
{
    if(user == nil) {
        // alarm
        return nil;
    }
    
    NSMutableArray* musicList = [[NSMutableArray alloc] init];
    
    @try {
        
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.vk.com/method/audio.get.xml?uid=%@&access_token=%@", [user objectForKey:@"user_id"], [user objectForKey:@"access_token"]]];
        
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


-(BOOL) saveAudioFile:(NSData*) fileData ofAudioItem:(Audio *) audioItem 
{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ - %@", audioItem.artist, audioItem.title]];
    
    return [fileData writeToFile:appFile atomically:YES];
}

-(NSData*) getAudioFile:(Audio *) audioItem {

}

-(BOOL) deleteAudioFile:(Audio *) audioItem {

}


@end
