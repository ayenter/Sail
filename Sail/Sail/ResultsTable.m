//
//  ResultsTable.m
//  Sail
//
//  Created by TheDarkKnight on 12/18/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import "ResultsTable.h"

@implementation ResultsTable

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    _stores = [NSMutableArray arrayWithArray:[_stores sortedArrayUsingComparator: ^NSComparisonResult(Store* s1, Store* s2){
        return [s1.distance compare: s2.distance];
    }]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.stores = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.stores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    static NSString *MyIdentifier = @"MyCellIdentifier";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        // Use the default cell style.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
    }
    
    Store *s = [self.stores objectAtIndex: indexPath.row];
    NSString *availability = [[NSString alloc] init];
    if ([s.chain isEqualToString:@"Best Buy"]) {
        availability = @"In Stock";
    } else {
        availability = @"Stock Unknown";
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [s.chain capitalizedString], [s.name capitalizedString]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f miles (%@) - %@", [s.distance doubleValue], [s.addressOne capitalizedString], availability];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultsRoot *root = self.delegate;
    [root moveToPage: 2 direction:UIPageViewControllerNavigationDirectionForward];
}


@end
