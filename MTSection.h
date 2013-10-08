//
//  MTSection.h
//  MusicalTables
//
//  Created by Tim Cinel on 11/15/2011.
//  Modernized by Alexsander Akers on 10/8/2013.
//

@interface MTSection : NSMutableArray

@property (nonatomic, readonly, copy) NSString *identifier;

- (BOOL)isEqualToSection:(MTSection *)section;

- (instancetype)initWithIdentifier:(NSString *)identifier rows:(NSArray *)rows;
+ (instancetype)sectionWithIdentifier:(NSString *)identifier rows:(NSArray *)rows;

@end
