//
//  MusicalTables.m
//  MusicalTables
//
//  Created by Tim Cinel on 11/15/2011.
//  Modernized by Alexsander Akers on 10/8/2013.
//

#import "MTDifference.h"
#import "MTSection.h"
#import "MusicalTables.h"

MTComparator const MTDefaultComparator = ^BOOL(id obj1, id obj2) {
	return [obj1 isEqual:obj2];
};

@implementation MusicalTables

/*  differenceBetweenOldArray:oldArray andNewArray:newArray resultingInsertions:insertionsPtrOrNil resultingDeletions:deletionsPtrOrNil resultingCommon:commonPtrOrNil
 *
 *  Takes an old array (oldArray) and new array (newArray), analyses the differences
 *  between the two, and sets pointers to arrays containing insertions (insertionPtrOrNil)
 *  and deletions (deletionPtrOrNil) required to transition from the old array to the new
 *  array. An array of elements from the old array that aren't deleted is also maintained
 *  (commonPtrOrNil).
 *
 */

+ (MTDifference *)differencBetweenOldArray:(NSArray *)oldArray andNewArray:(NSArray *)newArray usingBlock:(MTComparator)comparator
{
	NSParameterAssert(comparator != NULL);
	
	NSInteger oldPos, oldCount, newPos, newCount;
	NSObject *oldItem, *newItem, *nextOldItem;
	
	NSMutableArray *deletions, *insertions, *common;
	deletions = [NSMutableArray array];
	insertions = [NSMutableArray array];
	common = [NSMutableArray array];
	
	oldPos = newPos = 0;
	
	oldCount = oldArray.count;
	newCount = newArray.count;
	
	for (;;) {
		oldItem = (oldPos < oldCount ? oldArray[oldPos] : nil);
		newItem = (newPos < newCount ? newArray[newPos] : nil);
		
		if (nil == oldItem && nil == newItem) {
			//we're done here
			break;
		} else if (nil == oldItem) {
			//we've exhausted all old items - just insert, insert, insert
			[insertions addObject:@(newPos++)];
			
		} else if (nil == newItem) {
			//we've exhausted all new items - just delete, delete, delete
			[deletions addObject:@(oldPos++)];
			
		} else if (comparator(oldItem, newItem)) {
			//keep this section - need to play musical tables with the rows
			[common addObject:@[ @(oldPos++), @(newPos++) ]];
			
		} else {
			//check if the new item matches any proceeding old items
			nextOldItem = nil;
			NSInteger i;
			
			for (i = oldPos + 1; i < oldCount && nil == nextOldItem; i++)
				if (comparator(oldArray[i], newItem)) {
					nextOldItem = oldArray[i];
					break;
				}
			
			if (nil != nextOldItem) {
				//one of the old items matched - delete old items from oldPos to i - 1
				for (NSInteger j = oldPos; j < i; j++) {
					[deletions addObject:@(j)];
				}
				
				//move to old pos after matching old pos, move to next new pos
				oldPos = i + 1;
				newPos++;
				
			} else {
				//no old items matched - add new item
				[insertions addObject:@(newPos++)];
			}
			
		}
		
	}
	//return arrays
	
	MTDifference *difference = [[MTDifference alloc] init];
	difference.insertions = insertions;
	difference.deletions = deletions;
	difference.common = common;
	
	return difference;
}

/* musicalTables:table oldContent:oldContent newContent:newContent
 * 
 * Takes the existing data source for your table (oldContent), the new data source
 * (newContent) and the table (table). The method compares oldContent and newContent,
 * determines the differences, and performs deleteSections/insertSections 
 * insertRows/deleteRows on the table accordingly.
 *
 * There is a prescribed schema for oldData and newData:
 *	  NSArray *(old|new)Content:
 *		  (
 *			  MusicalTableSection *(id row, id row, id row, id row, id row),
 *			  MusicalTableSection *(id row, id row),
 *			  MusicalTableSection *(id row, id row, id row, id row),
 *		  );
 *
 *	  Sections don't have to be stored as MusicalTableSelection objects. The class
 *	  used to store sections should: 
 *	   * Allow "tagging" so equivalent sections can be detected
 *	   * Have an NSArray or other storage mechanism to store rows
 *	   * Implement objectAtIndex: and count: like NSArray, so rows can be retrieved.
 * 
 */

+ (void)musicalTableView:(UITableView *)tableView withOldContent:(NSArray *)oldContent newContent:(NSArray *)newContent usingComparator:(MTComparator)comparator
{
	[self musicalCollectionWithOldContent:oldContent newContent:newContent usingComparator:comparator sectionsMutation:^(MTMutationType mutationType, NSIndexSet *indexes) {
		if (mutationType == MTMutationTypeInsertion) {
			[tableView insertSections:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
		} else {
			[tableView deleteSections:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	} objectsMutation:^(MTMutationType mutationType, NSArray *indexPaths) {
		if (mutationType == MTMutationTypeInsertion) {
			[tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
		} else {
			[tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
		}
	}];
}

+ (void)musicalCollectionView:(UICollectionView *)collectionView withOldContent:(NSArray *)oldContent newContent:(NSArray *)newContent usingComparator:(MTComparator)comparator
{
	[self musicalCollectionWithOldContent:oldContent newContent:newContent usingComparator:comparator sectionsMutation:^(MTMutationType mutationType, NSIndexSet *indexes) {
		if (mutationType == MTMutationTypeInsertion) {
			[collectionView insertSections:indexes];
		} else {
			[collectionView deleteSections:indexes];
		}
	} objectsMutation:^(MTMutationType mutationType, NSArray *indexPaths) {
		if (mutationType == MTMutationTypeInsertion) {
			[collectionView insertItemsAtIndexPaths:indexPaths];
		} else {
			[collectionView deleteItemsAtIndexPaths:indexPaths];
		}
	}];
}

+ (void)musicalCollectionWithOldContent:(NSArray *)oldContent newContent:(NSArray *)newContent usingComparator:(MTComparator)comparator sectionsMutation:(MTSectionsMutation)sectionsMutation objectsMutation:(MTObjectsMutation)objectsMutation
{
	NSParameterAssert(comparator != NULL);
	
	NSMutableArray *rowsToInsert, *rowsToDelete;
	NSMutableIndexSet *sectionsToInsert, *sectionsToDelete;
	NSArray *oldRows, *newRows;
	
	//initialisation
	sectionsToInsert = [NSMutableIndexSet indexSet];
	sectionsToDelete = [NSMutableIndexSet indexSet];
	
	rowsToInsert = [NSMutableArray array];
	rowsToDelete = [NSMutableArray array];
	
	//SECTIONS
	
	//play musical tables with sections (determine differences between sections)
	MTDifference *difference = [self differencBetweenOldArray:oldContent andNewArray:newContent usingBlock:comparator];
	
	//place data into NSIndexSet
	for (NSNumber *section in difference.insertions)
		[sectionsToInsert addIndex:[section integerValue]];
	
	for (NSNumber *section in difference.deletions)
		[sectionsToDelete addIndex:[section integerValue]];
	
	//make changes to table's sections
	sectionsMutation(MTMutationTypeInsertion, sectionsToInsert);
	sectionsMutation(MTMutationTypeDeletion, sectionsToDelete);
	
	//ROWS
	
	//for each section that wasn't deleted and isn't new
	for (NSArray *rowPair in difference.common) {
		NSInteger oldSection, newSection;
		
		//schema for "common": (NSNumber *oldSection, NSNumber *newSection)
		oldSection = [rowPair[0] integerValue];
		newSection = [rowPair[1] integerValue];
		
		oldRows = oldContent[oldSection];
		newRows = newContent[newSection];
		
		//play musical tables with rows in sections that weren't deleted and aren't new (determine differences between rows in said sections)
		MTDifference *difference = [self differencBetweenOldArray:oldRows andNewArray:newRows usingBlock:comparator];
		
		//place data into NSArray of NSIndexPaths
		for (NSNumber *row in difference.insertions)
			[rowsToInsert addObject:[NSIndexPath indexPathForRow:[row integerValue] inSection:newSection]];
		
		for (NSNumber *row in difference.deletions)
			[rowsToDelete addObject:[NSIndexPath indexPathForRow:[row integerValue] inSection:newSection]];
	}
	
	//make changes to table's rows
	objectsMutation(MTMutationTypeInsertion, rowsToInsert);
	objectsMutation(MTMutationTypeDeletion, rowsToDelete);
	
	//that's all, folks!
}

@end
