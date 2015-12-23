//
//  ResultsRoot.h
//  Sail
//
//  Created by TheDarkKnight on 12/18/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsTable.h"
#import "ResultsMap.h"
#import "ResultsInfo.h"
#import "Product.h"

@interface ResultsRoot : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) NSString* testString;

@property (strong, nonatomic) NSArray *viewContentControllers;

@property (strong) NSMutableArray *results;

@property (strong) NSMutableArray *product;

-(void)moveToPage:(NSInteger)page direction:(UIPageViewControllerNavigationDirection)dir;

- (IBAction)sortList:(id)sender;

@property BOOL sortedDistance;

@property (nonatomic, assign) NSInteger currentIndex;

@property (retain) UIPageControl *pageController;

@end