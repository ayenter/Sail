//
//  ResultsInfo.m
//  Sail
//
//  Created by TheDarkKnight on 12/21/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import "ResultsInfo.h"

@implementation ResultsInfo
@synthesize products;
@synthesize frmt;


- (void)viewDidLoad{
    _pricings.dataSource = self;
    _pricings.delegate = self;
    Product *primary;
    for (Product* p in products) {
        if ([p.store isEqualToString:@"Best Buy"]) {
            primary = [products objectAtIndex:0];
        }
    }
    if (primary == nil) {
        primary = [products objectAtIndex:0];
    }
    _nameLabel.text = primary.name;
    _descriptionLabel.text = primary.shortDescription;
    frmt = [[NSNumberFormatter alloc] init];
    [frmt setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    products = [NSMutableArray arrayWithArray:[products sortedArrayUsingComparator: ^NSComparisonResult(Product* p1, Product* p2){
        return [p1.price compare: p2.price];
    }]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.products = nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return [products count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    return @"Stores";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyReuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:MyIdentifier];
    }
    Product *p = [products objectAtIndex:indexPath.row];
    cell.textLabel.text = p.store;
    cell.detailTextLabel.text = [frmt stringFromNumber: p.price];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"TOUCHED");
    ResultsRoot* r = (ResultsRoot*)_root;
    [r.pageViewController setViewControllers: [NSArray arrayWithObject: [r.viewContentControllers objectAtIndex:1]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

- (IBAction)tsting:(id)sender {
    NSLog(@"TOUCHED");
    [_root moveToPage:1 direction:UIPageViewControllerNavigationDirectionForward];
}
@end
