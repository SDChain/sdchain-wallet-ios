/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 *
 *  Created by George on 4/21/10.
 *  Copyright 2010 RED/SAFI. All rights reserved.
 *
 */
#import <Foundation/Foundation.h>
@interface HTFirstLetter : NSObject

+ (char)pinyinFirstLetter:(unsigned short )hanzi;
//Get the first letter of the Chinese character, if the parameter is neither Chinese characters nor English letters, then return @“#”
+ (NSString *)firstLetter:(NSString *)chineseString;

//Returns the first letter of all Chinese characters in the parameter. If other characters are encountered, replace it with #
+ (NSString *)firstLetters:(NSString *)chineseString;

@end
