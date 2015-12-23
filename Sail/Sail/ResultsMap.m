//
//  ResultsMap.m
//  Sail
//
//  Created by TheDarkKnight on 12/18/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import "ResultsMap.h"

@implementation ResultsMap

-(void)viewDidLoad{
    
    [self.map setCenterCoordinate: self.centerLoc animated: YES];
    
    self.map.region = MKCoordinateRegionMake(self.centerLoc, MKCoordinateSpanMake(0.7, 0.7));
    
    for (Store *s in self.stores) {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate: CLLocationCoordinate2DMake(s.lat, s.lng) ];
        [annotation setTitle: [NSString stringWithFormat:@"%@ %@", [s.chain capitalizedString],[s.city capitalizedString]]];
        [self.map addAnnotation:annotation];
    }
}

- (IBAction)backToListBton:(id)sender {
    ResultsRoot *root = self.delegate;
    [root moveToPage:1 direction:UIPageViewControllerNavigationDirectionReverse];
}
- (IBAction)resetBton:(id)sender {
    [self.map setCenterCoordinate: self.centerLoc animated: YES];
    
    self.map.region = MKCoordinateRegionMake(self.centerLoc, MKCoordinateSpanMake(0.7, 0.7));
}
@end
