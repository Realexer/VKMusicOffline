//
// XMLReader.h
//  Starbucks
//
//  Created  on 3/2/11.
//  Copyright 2011 Douglas Consulting. All rights reserved.

#import <Foundation/Foundation.h>

@interface XMLReaderDef : NSObject
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError **errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end
