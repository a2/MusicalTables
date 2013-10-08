//
//  ViewController.m
//  MusicalTables
//
//  Created by Tim Cinel on 2011-11-15.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "MusicalTables.h"
#import "MTSection.h"

@implementation ViewController

@synthesize tableView = _tableView;
@synthesize tableData = _tableData;

@synthesize tableSections = _tableSections;
@synthesize tableRows = _tableRows;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _tableRows = @[ @"Hello", @"World", //0
					@"All", @"Your", @"Base", @"Are",  @"Belong", @"To", @"Us", //2
					@"Y", @"U", @"NO", //9
					@"Then", @"Who", @"Was", @"Telephone" ]; //12
	
	_tableSections = @[ [MTSection sectionWithIdentifier:@"HW" rows:@[ self.tableRows[0], self.tableRows[1] ]],
						[MTSection sectionWithIdentifier:@"AYB" rows:@[ self.tableRows[2], self.tableRows[3], self.tableRows[4], self.tableRows[5], self.tableRows[6], self.tableRows[7], self.tableRows[8] ]],
						[MTSection sectionWithIdentifier:@"YUNO" rows:@[ self.tableRows[9], self.tableRows[10], self.tableRows[11] ]],
						[MTSection sectionWithIdentifier:@"THW" rows:@[ self.tableRows[12], self.tableRows[13], self.tableRows[14], self.tableRows[15] ]]
					   ].mutableCopy;
	
    _tableData = [[NSMutableArray alloc] init];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    self.tableData = nil;
    
    self.tableSections = nil;
    self.tableRows = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - IBActions

- (IBAction)runNextTest:(id)sender {
    static NSInteger test = -1;
    NSMutableArray *newTableElements;
    MTSection *tempSection;
	
    switch ((test = (test + 1) % 5)) {
        case 0:
            newTableElements = [NSMutableArray arrayWithObjects:
                                [self.tableSections objectAtIndex:0],
                                [self.tableSections objectAtIndex:1],
                                [self.tableSections objectAtIndex:2],
                                nil];

            break;
        case 1:            
            newTableElements = [NSMutableArray arrayWithObjects:
                                [self.tableSections objectAtIndex:1],
                                [self.tableSections objectAtIndex:3],
                                nil];
            break;
        case 2:
			tempSection = [self.tableSections[1] mutableCopy];
            [tempSection insertObject:@"lolWAT" atIndex:0];
            [tempSection insertObject:@"huh?!" atIndex:2];
            [tempSection removeLastObject];
            [tempSection removeLastObject];
            [tempSection removeLastObject];
            
            [self.tableSections replaceObjectAtIndex:1 withObject:tempSection];
            
            newTableElements = [NSMutableArray arrayWithObjects:
                                [self.tableSections objectAtIndex:1],
                                [self.tableSections objectAtIndex:0],
                                [self.tableSections objectAtIndex:3],
                                nil];
            break;
        case 3:
			tempSection = [self.tableSections[1] mutableCopy];
            [tempSection removeObjectAtIndex:2];
            [tempSection removeObjectAtIndex:0];
            [tempSection addObject:[self.tableRows objectAtIndex:6]];
            [tempSection addObject:[self.tableRows objectAtIndex:7]];
            [tempSection addObject:[self.tableRows objectAtIndex:8]];
            
            [self.tableSections replaceObjectAtIndex:1 withObject:tempSection];
            
            newTableElements = [NSMutableArray arrayWithObjects:
                                [self.tableSections objectAtIndex:1],
                                [self.tableSections objectAtIndex:2],
                                [self.tableSections objectAtIndex:0],
                                [self.tableSections objectAtIndex:3],
                                nil];
            break;
        default:
            newTableElements = [NSMutableArray array];
            break;
    }
    
    [self.tableView beginUpdates];
    NSLog(@"newTableElements: %@", self.tableData);
    NSLog(@"oldTableElements: %@", newTableElements);
    
    [MusicalTables musicalTableView:self.tableView withOldContent:self.tableData newContent:newTableElements usingComparator:MTDefaultComparator];
    self.tableData = newTableElements;
    [self.tableView endUpdates];
    
}






#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [(NSArray *)[self.tableData objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"MTCell";
    UITableViewCell *cell;
    
    if (nil == (cell = [tableView dequeueReusableCellWithIdentifier:identifier])) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [(NSArray *)[self.tableData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end