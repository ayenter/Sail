//
//  ResultsTable.h
//  Sail
//
//  Created by TheDarkKnight on 12/18/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "ResultsRoot.h"

@interface ResultsTable : UITableViewController{
    NSMutableArray *_stores;
}

@property (nonatomic, retain) NSMutableArray* stores;

@property id delegate;

@end
