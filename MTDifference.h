//
//  MTDifference.h
//  MusicalTables
//
//  Created by Tim Cinel on 11/15/2011.
//  Modernized by Alexsander Akers on 10/8/2013.
//

@interface MTDifference : NSObject

@property (nonatomic, copy) NSArray *insertions;
@property (nonatomic, copy) NSArray *deletions;
@property (nonatomic, copy) NSArray *common;

@end
