//
//  JLThreadSafeArray.h
//  YstenVideoJackLib
//
//  Created by percent on 2026/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 线程安全数组 - 使用并发队列+barrier实现
 支持多线程并发读，串行写
 */
@interface JLThreadSafeArray<ObjectType> : NSObject

    /// 元素数量
@property (readonly) NSUInteger count;

    /// 是否为空
@property (readonly, getter=isEmpty) BOOL empty;

#pragma mark - 初始化方法
+ (instancetype)array;
+ (instancetype)arrayWithArray:(NSArray<ObjectType> *)array;
- (instancetype)initWithArray:(NSArray<ObjectType> *)array;

#pragma mark - 添加元素
- (void)addObject:(ObjectType)object;
- (void)addObjectsFromArray:(NSArray<ObjectType> *)array;
- (void)insertObject:(ObjectType)object atIndex:(NSUInteger)index;

#pragma mark - 移除元素
- (void)removeObject:(ObjectType)object;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeAllObjects;
- (void)removeLastObject;

#pragma mark - 查询元素
- (nullable ObjectType)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(ObjectType)object;
- (BOOL)containsObject:(ObjectType)object;
- (ObjectType)firstObject;
- (ObjectType)lastObject;

#pragma mark - 批量操作
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)object;
- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;
- (void)setArray:(NSArray<ObjectType> *)array;

#pragma mark - 遍历操作
- (void)enumerateObjectsUsingBlock:(void (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;
- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts
                         usingBlock:(void (^)(ObjectType obj, NSUInteger idx, BOOL *stop))block;

#pragma mark - 获取数据
- (NSArray<ObjectType> *)allObjects;
- (NSArray<ObjectType> *)subarrayWithRange:(NSRange)range;

#pragma mark - 下标访问
- (ObjectType)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(ObjectType)obj atIndexedSubscript:(NSUInteger)index;

@end


NS_ASSUME_NONNULL_END
