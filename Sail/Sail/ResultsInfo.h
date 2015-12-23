//
//  ResultsInfo.h
//  Sail
//
//  Created by TheDarkKnight on 12/21/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "ResultsRoot.h"

@interface ResultsInfo : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    NSMutableArray *_products;
}

@property id root;

@property (nonatomic, retain) NSMutableArray* products;

@property (strong, nonatomic) IBOutlet UITableView *pricings;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (retain) NSNumberFormatter *frmt;

- (IBAction)tsting:(id)sender;

@end
