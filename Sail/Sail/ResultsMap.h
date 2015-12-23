//
//  ResultsMap.h
//  Sail
//
//  Created by TheDarkKnight on 12/18/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Store.h"
#import "ResultsRoot.h"

@interface ResultsMap : UIViewController{
    NSMutableArray *_stores;
}

@property (strong) NSMutableArray *stores;

@property (strong, nonatomic) IBOutlet MKMapView *map;

@property CLLocationCoordinate2D centerLoc;

- (IBAction)backToListBton:(id)sender;

@property id delegate;

- (IBAction)resetBton:(id)sender;

@end
