//
//  Audio.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/28/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Audio : NSManagedObject

@property (nonatomic, retain) NSNumber * aid;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * duration;
@property (nonatomic, retain) NSNumber * lyrics_id;
@property (nonatomic, retain) NSNumber * owner_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;

@end
