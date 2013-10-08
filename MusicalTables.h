//
//  MusicalTables.h
//  MusicalTables
//
//  Created by Tim Cinel on 11/15/2011.
//  Modernized by Alexsander Akers on 10/8/2013.
//

typedef BOOL (^MTComparator)(id obj1, id obj2);

typedef NS_ENUM(NSUInteger, MTMutationType) {
	MTMutationTypeInsertion,
	MTMutationTypeDeletion
};
typedef void (^MTSectionsMutation)(MTMutationType mutationType, NSIndexSet *indexes);
typedef void (^MTObjectsMutation)(MTMutationType mutationType, NSArray *indexPaths);

extern MTComparator const MTDefaultComparator;

@interface MusicalTables : NSObject

+ (void)musicalTableView:(UITableView *)tableView withOldContent:(NSArray *)oldContent newContent:(NSArray *)newContent usingComparator:(MTComparator)comparator;

+ (void)musicalCollectionView:(UICollectionView *)collectionView withOldContent:(NSArray *)oldContent newContent:(NSArray *)newContent usingComparator:(MTComparator)comparator;

+ (void)musicalCollectionWithOldContent:(NSArray *)oldContent newContent:(NSArray *)newContent usingComparator:(MTComparator)comparator sectionsMutation:(MTSectionsMutation)sectionsMutation objectsMutation:(MTObjectsMutation)objectsMutation;

@end
