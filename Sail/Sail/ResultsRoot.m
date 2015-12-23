//
//  ResultsRoot.m
//  Sail
//
//  Created by TheDarkKnight on 12/18/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import "ResultsRoot.h"

@implementation ResultsRoot
@synthesize sortedDistance;

-(void)moveToPage:(NSInteger)page direction:(UIPageViewControllerNavigationDirection)dir{
    [self.pageViewController setViewControllers: [NSArray arrayWithObject:[self.viewContentControllers objectAtIndex: page]] direction:dir animated:YES completion:nil];
    self.pageController.currentPage = page;
}

- (IBAction)sortList:(id)sender {
    ResultsTable *r = [self.viewContentControllers objectAtIndex:1];
    if (sortedDistance) {
        r.stores = [NSMutableArray arrayWithArray:[r.stores sortedArrayUsingComparator: ^NSComparisonResult(Store* s1, Store* s2){
            return [s1.chain compare: s2.chain];
        }]];
        sortedDistance = NO;
        NSLog(@"sort chain");
    } else {
        r.stores = [NSMutableArray arrayWithArray:[r.stores sortedArrayUsingComparator: ^NSComparisonResult(Store* s1, Store* s2){
            return [s1.distance compare: s2.distance];
        }]];
        sortedDistance = YES;
        NSLog(@"sort distance");
    }
    [r.tableView reloadData];
}

-(void)viewDidLoad{
    sortedDistance = YES;
    self.navigationController.navigationBarHidden = NO;
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsPageViewController"];
    self.pageViewController.dataSource = self;
    
    ResultsInfo *firstViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"ResultsInfo"];
    
    firstViewController.products = self.product;
    firstViewController.root = self;
    ResultsTable *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier: @"ResultsTable"];
    
    secondViewController.stores = self.results;
    secondViewController.delegate = self;
    
    ResultsMap *thirdViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultsMap"];
    
    thirdViewController.stores = self.results;
    Store *astore = [self.results objectAtIndex:0];
    thirdViewController.centerLoc = CLLocationCoordinate2DMake([astore lat], [astore lng]);
    thirdViewController.delegate = self;
    
    self.viewContentControllers = [NSArray arrayWithObjects:firstViewController, secondViewController, thirdViewController, nil];
    
    [self.pageViewController setViewControllers: [NSArray arrayWithObject:[self.viewContentControllers objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
//    for (UIView *subview in self.pageViewController.view.subviews) {
//        if ([subview isKindOfClass:[UIPageControl class]]) {
//            UIPageControl *pageControl = (UIPageControl *)subview;
//            self.pageController = pageControl;
//            pageControl.pageIndicatorTintColor = [UIColor grayColor];
//            pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
//            pageControl.backgroundColor = [UIColor clearColor];
//        }
//    }
    
}

#pragma mark - Page View Controller Data Source

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[ResultsInfo class]]) {
        return nil;
    } else if ([viewController isKindOfClass:[ResultsTable class]]) {
        return [self.viewContentControllers objectAtIndex:0];
    } else {
        return [self.viewContentControllers objectAtIndex:1];
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if ([viewController isKindOfClass:[ResultsInfo class]]) {
        return [self.viewContentControllers objectAtIndex:1];
    } else if ([viewController isKindOfClass:[ResultsTable class]]) {
        return [self.viewContentControllers objectAtIndex:2];
    } else {
        return nil;
    }
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return self.currentIndex;
}


@end
