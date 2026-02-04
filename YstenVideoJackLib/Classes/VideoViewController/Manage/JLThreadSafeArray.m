//
//  JLThreadSafeArray.m
//  YstenVideoJackLib
//
//  Created by percent on 2026/2/4.
//

#import "JLThreadSafeArray.h"

@interface JLThreadSafeArray<ObjectType>()
@property (nonatomic, strong) NSMutableArray<ObjectType> *storage;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@end

@implementation JLThreadSafeArray

#pragma mark - 初始化方法

- (instancetype)init {
    self = [super init];
    if (self) {
        _storage = [NSMutableArray array];
            // 创建并发队列，注意label要有唯一性
        _concurrentQueue = dispatch_queue_create("com.threadsafe.array.queue",
                                                 DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array {
    self = [self init];
    if (self) {
        if (array) {
            _storage = [array mutableCopy];
        }
    }
    return self;
}

+ (instancetype)array {
    return [[self alloc] init];
}

+ (instancetype)arrayWithArray:(NSArray *)array {
    return [[self alloc] initWithArray:array];
}

#pragma mark - 基本属性

- (NSUInteger)count {
    __block NSUInteger count;
    dispatch_sync(self.concurrentQueue, ^{
        count = self.storage.count;
    });
    return count;
}

- (BOOL)isEmpty {
    __block BOOL empty;
    dispatch_sync(self.concurrentQueue, ^{
        empty = (self.storage.count == 0);
    });
    return empty;
}

#pragma mark - 添加元素

- (void)addObject:(id)object {
    if (!object) return;
    
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self.storage addObject:object];
    });
}

- (void)addObjectsFromArray:(NSArray *)array {
    if (!array || array.count == 0) return;
    
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self.storage addObjectsFromArray:array];
    });
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index {
    if (!object) return;
    
    dispatch_barrier_async(self.concurrentQueue, ^{
        @try {
                // 检查索引是否有效
            if (index <= self.storage.count) {
                [self.storage insertObject:object atIndex:index];
            } else {
                    // 如果索引超出范围，添加到末尾
                [self.storage addObject:object];
            }
        } @catch (NSException *exception) {
            NSLog(@"插入对象失败: %@", exception);
        }
    });
}

#pragma mark - 移除元素

- (void)removeObject:(id)object {
    if (!object) return;
    
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self.storage removeObject:object];
    });
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    dispatch_barrier_async(self.concurrentQueue, ^{
        @try {
            if (index < self.storage.count) {
                [self.storage removeObjectAtIndex:index];
            }
        } @catch (NSException *exception) {
            NSLog(@"移除对象失败: %@", exception);
        }
    });
}

- (void)removeAllObjects {
    dispatch_barrier_async(self.concurrentQueue, ^{
        [self.storage removeAllObjects];
    });
}

- (void)removeLastObject {
    dispatch_barrier_async(self.concurrentQueue, ^{
        if (self.storage.count > 0) {
            [self.storage removeLastObject];
        }
    });
}

#pragma mark - 查询元素

- (id)objectAtIndex:(NSUInteger)index {
    __block id object = nil;
    
    dispatch_sync(self.concurrentQueue, ^{
        if (index < self.storage.count) {
            object = self.storage[index];
        }
    });
    
    return object;
}

- (NSUInteger)indexOfObject:(id)object {
    if (!object) return NSNotFound;
    
    __block NSUInteger index = NSNotFound;
    dispatch_sync(self.concurrentQueue, ^{
        index = [self.storage indexOfObject:object];
    });
    
    return index;
}

- (BOOL)containsObject:(id)object {
    if (!object) return NO;
    
    __block BOOL contains = NO;
    dispatch_sync(self.concurrentQueue, ^{
        contains = [self.storage containsObject:object];
    });
    
    return contains;
}

- (id)firstObject {
    __block id object = nil;
    dispatch_sync(self.concurrentQueue, ^{
        object = self.storage.firstObject;
    });
    return object;
}

- (id)lastObject {
    __block id object = nil;
    dispatch_sync(self.concurrentQueue, ^{
        object = self.storage.lastObject;
    });
    return object;
}

#pragma mark - 批量操作

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object {
    if (!object) return;
    
    dispatch_barrier_async(self.concurrentQueue, ^{
        @try {
            if (index < self.storage.count) {
                [self.storage replaceObjectAtIndex:index withObject:object];
            }
        } @catch (NSException *exception) {
            NSLog(@"替换对象失败: %@", exception);
        }
    });
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    dispatch_barrier_async(self.concurrentQueue, ^{
        @try {
            if (idx1 < self.storage.count && idx2 < self.storage.count) {
                [self.storage exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
            }
        } @catch (NSException *exception) {
            NSLog(@"交换对象失败: %@", exception);
        }
    });
}

- (void)setArray:(NSArray *)array {
    dispatch_barrier_async(self.concurrentQueue, ^{
        self.storage = [array mutableCopy];
    });
}

#pragma mark - 遍历操作

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    if (!block) return;
    
    dispatch_sync(self.concurrentQueue, ^{
        [self.storage enumerateObjectsUsingBlock:block];
    });
}

- (void)enumerateObjectsWithOptions:(NSEnumerationOptions)opts
                         usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block {
    if (!block) return;
    
    dispatch_sync(self.concurrentQueue, ^{
        [self.storage enumerateObjectsWithOptions:opts usingBlock:block];
    });
}

#pragma mark - 获取数据

- (NSArray *)allObjects {
    __block NSArray *array;
    dispatch_sync(self.concurrentQueue, ^{
        array = [self.storage copy];
    });
    return array;
}

- (NSArray *)subarrayWithRange:(NSRange)range {
    __block NSArray *array = nil;
    
    dispatch_sync(self.concurrentQueue, ^{
        @try {
            if (range.location < self.storage.count) {
                NSUInteger length = MIN(range.length, self.storage.count - range.location);
                NSRange validRange = NSMakeRange(range.location, length);
                array = [self.storage subarrayWithRange:validRange];
            }
        } @catch (NSException *exception) {
            NSLog(@"获取子数组失败: %@", exception);
            array = @[];
        }
    });
    
    return array;
}

#pragma mark - 下标访问

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    return [self objectAtIndex:index];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index {
    dispatch_barrier_async(self.concurrentQueue, ^{
        @try {
            if (index < self.storage.count) {
                self.storage[index] = obj;
            } else if (index == self.storage.count) {
                [self.storage addObject:obj];
            }
        } @catch (NSException *exception) {
            NSLog(@"下标赋值失败: %@", exception);
        }
    });
}

#pragma mark - 描述信息

- (NSString *)description {
    __block NSString *description;
    dispatch_sync(self.concurrentQueue, ^{
        description = [self.storage description];
    });
    return [NSString stringWithFormat:@"<ThreadSafeArray: %p> %@", self, description];
}

@end
