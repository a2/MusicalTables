MusicalTables
=============

*It’s like musical chairs but in your collections.*

## Overview

MusicalTables looks at the changes in your table view, collection view, or other sectioned data source source data and automatically calls the appropriate methods to insert or delete sections or rows. Just worry about the data, let MusicalTables take care of the transition.


## Details

There are two main classes: *MusicalTables* and *MTSection*


### MusicalTables

#### `+musicalTableView:withOldContent:newContent:usingComparator:`


* **UITableView \*tableView**: The table view whose data will be altered.
* **NSArray \*oldContent**: Thew table view's old content. This is an array of sections represented by instances of either `NSArray` or `MTSection`.
* **NSArray \*newContent**: Thew table view's new content. This is an array of sections represented by instances of either `NSArray` or `MTSection`.
* **MTComparator comparator**: The block to use when comparing objects. This will be called to determine if "row objects" are equal. To compare using `-isEqual:`, pass the `MTDefaultComparator` constant.

#### `+musicalCollectionView:withOldContent:newContent:usingComparator:`

* **UICollectionView \*collectionView**: The collection view view whose data will be altered.
* **NSArray \*oldContent**: Thew collection view's old content. This is an array of sections represented by instances of either `NSArray` or `MTSection`.
* **NSArray \*newContent**: Thew collection view's new content. This is an array of sections represented by instances of either `NSArray` or `MTSection`.
* **MTComparator comparator**: The block to use when comparing objects. This will be called to determine if "row objects" are equal. To compare using `-isEqual:`, pass the `MTDefaultComparator` constant.

#### `+musicalCollectionWithOldContent:newContent:usingComparator:sectionsMutation:objectsMutation:`

* **NSArray \*oldContent**: Thew collection view's old content. This is an array of sections represented by instances of either `NSArray` or `MTSection`.
* **NSArray \*newContent**: Thew collection view's new content. This is an array of sections represented by instances of either `NSArray` or `MTSection`.
* **MTComparator comparator**: The block to use when comparing objects. This will be called to determine if "row objects" are equal. To compare using `-isEqual:`, pass the `MTDefaultComparator` constant.
* **MTSectionsMutation sectionsMutation**: The block to use when inserting or deleting sections. Use this time to call the methods on your custom view.
* **MTObjectsMutation objectsMutation**: The block to use when inserting or deleting objects in sections. Use this time to call the methods on your custom view.

### MTSection

Section objects don't have to be stored as MTSection objects, but this class lets you assign an additional `identifier` attribute to allow tagging so equivalent sections can be detected.

## Contributors

Created by [Tim Cinel](http://github.com/sickanimations)

Modernized by [Alexsander Akers](http://github.com/a2)
