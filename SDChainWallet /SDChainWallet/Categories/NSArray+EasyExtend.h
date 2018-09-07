//  Created by EasyIOS on 14-4-10.
//  Copyright (c) 2014年 zhuchao. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#pragma mark -

typedef NSMutableArray *	(^NSArrayAppendBlock)( id obj );
typedef NSMutableArray *	(^NSMutableArrayAppendBlock)( id obj );
typedef NSComparisonResult	(^NSMutableArrayCompareBlock)( id left, id right );

#pragma mark -

@interface NSArray(EasyExtend)

@property (nonatomic, readonly) NSArrayAppendBlock			APPEND;
@property (nonatomic, readonly) NSMutableArray *			mutableArray;

- (NSArray *)head:(NSUInteger)count;
- (NSArray *)tail:(NSUInteger)count;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (id)safeObjectAtIndex:(NSInteger)index;
- (NSArray *)safeSubarrayWithRange:(NSRange)range;

- (NSString *)join:(NSString *)delimiter;
- (NSString *)stringByWords;
- (NSArray *)map:(id (^)(id obj))block;
- (NSArray *)mapWithIndex:(id (^)(id obj, NSUInteger idx))block;
- (NSArray *)each:(void (^)(id obj))block;
- (NSArray *)eachWithIndex:(void (^)(id obj, NSUInteger idx))block;
- (NSArray *)eachWithStop:(void (^)(id obj, BOOL *stop))block;
- (NSArray *)eachWithIndexAndStop:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;
- (NSArray *)filter:(BOOL(^)(id obj))block;
- (id)find:(BOOL(^)(id obj))block;
- (NSDictionary *)sortedArrayUsingFirstLetter;
@end

#pragma mark -

@interface NSMutableArray(BeeExtension)

@property (nonatomic, readonly) NSMutableArrayAppendBlock	APPEND;

+ (NSMutableArray *)nonRetainingArray;			// copy from Three20

- (void)addUniqueObject:(id)object compare:(NSMutableArrayCompareBlock)compare;
- (void)addUniqueObjects:(const id [])objects count:(NSUInteger)count compare:(NSMutableArrayCompareBlock)compare;
- (void)addUniqueObjectsFromArray:(NSArray *)array compare:(NSMutableArrayCompareBlock)compare;

- (void)unique;
- (void)unique:(NSMutableArrayCompareBlock)compare;

- (void)sort;
- (void)sort:(NSMutableArrayCompareBlock)compare;

- (NSMutableArray *)pushHead:(NSObject *)obj;
- (NSMutableArray *)pushHeadN:(NSArray *)all;
- (NSMutableArray *)popTail;
- (NSMutableArray *)popTailN:(NSUInteger)n;

- (NSMutableArray *)pushTail:(NSObject *)obj;
- (NSMutableArray *)pushTailN:(NSArray *)all;
- (NSMutableArray *)popHead;
- (NSMutableArray *)popHeadN:(NSUInteger)n;

- (NSMutableArray *)keepHead:(NSUInteger)n;
- (NSMutableArray *)keepTail:(NSUInteger)n;

- (void)insertObjectNoRetain:(id)anObject atIndex:(NSUInteger)index;
- (void)addObjectNoRetain:(NSObject *)obj;
- (void)removeObjectNoRelease:(NSObject *)obj;
- (void)removeAllObjectsNoRelease;

- (void)removeObject:(NSObject *)obj usingComparator:(NSMutableArrayCompareBlock)cmptr;

@end
