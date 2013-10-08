//
//  MTSection.m
//  MusicalTables
//
//  Created by Tim Cinel on 11/15/2011.
//  Modernized by Alexsander Akers on 10/8/2013.
//

#import "MTSection.h"
#import "MusicalTables.h"

@interface MTSection ()

@property (nonatomic, strong) NSMutableArray *rows;

@end

@implementation MTSection

- (BOOL)isEqualToSection:(MTSection *)section
{
	return [self.identifier isEqualToString:section.identifier];
}

- (instancetype)initWithIdentifier:(NSString *)identifier rows:(NSArray *)rows
{
	self = [super init];
	
	_identifier = identifier.copy;
	_rows = [NSMutableArray arrayWithArray:rows];
	
	return self;
}
+ (instancetype)sectionWithIdentifier:(NSString *)identifier rows:(NSArray *)rows
{
	return [[self alloc] initWithIdentifier:identifier rows:rows];
}

#pragma mark - NSArray

- (BOOL)isEqualToArray:(NSArray *)otherArray
{
	return [otherArray isKindOfClass:[MTSection class]] && [self isEqualToSection:(MTSection *)otherArray];
}

- (id)objectAtIndex:(NSUInteger)index
{
	return self.rows[index];
}

- (NSUInteger)count
{
	return self.rows.count;
}

- (void)getObjects:(__unsafe_unretained id [])objects range:(NSRange)range
{
	[self.rows getObjects:objects range:range];
}

#pragma mark - <NSCopying>

- (id)copyWithZone:(NSZone *)zone
{
	return self.rows.copy;
}

#pragma mark - NSMutableArray

- (void)addObject:(id)anObject
{
	[self.rows addObject:anObject];
}
- (void)insertObject:(id)anObject atIndex:(NSUInteger)index
{
	[self.rows insertObject:anObject atIndex:index];
}
- (void)removeLastObject
{
	[self.rows removeLastObject];
}
- (void)removeObjectAtIndex:(NSUInteger)index
{
	[self.rows removeObjectAtIndex:index];
}
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
	[self.rows replaceObjectAtIndex:index withObject:anObject];
}

#pragma mark - <NSMutableCopying>

- (id)mutableCopyWithZone:(NSZone *)zone
{
	return [[self.class alloc] initWithIdentifier:self.identifier rows:self.rows];
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
	return [object isKindOfClass:[MTSection class]] && [self isEqualToSection:(MTSection *)object];
}

- (NSUInteger)hash
{
	return self.identifier.hash;
}

@end
