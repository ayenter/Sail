//
//  Home.h
//  Sail
//
//  Created by TheDarkKnight on 12/17/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultsRoot.h"
#import "BBYDataGetter.h"
#import "WLMRTDataGetter.h"
#import <MapKit/MapKit.h>

@interface Home : UIViewController <DataGetterDelegate, UITextFieldDelegate, CLLocationManagerDelegate>

@property (strong) BBYDataGetter *bby;
@property (strong) WLMRTDataGetter *wlmrt;

@property (strong, nonatomic) IBOutlet UITextField *upcInput;
@property (strong, nonatomic) IBOutlet UITextField *skuInput;


- (IBAction)upcGo:(id)sender;

- (IBAction)skuGo:(id)sender;

@property BOOL requestIsSku;
@property NSString *laterTitle;


@property (strong) NSNumber* selectedZipCode;
@property float selectedLat;
@property float selectedLng;

@property BOOL useCurrentLocation;

@property (strong) NSMutableArray *productResults;
@property (strong) NSMutableArray *storeResults;


@property int numOfResponses;

@property int numOfRequests;


@property (strong, nonatomic) IBOutlet UITextField *zipInput;

- (IBAction)callChangeLocationPopUp:(id)sender;
- (IBAction)changeLocation:(id)sender;
- (IBAction)useCurrentLocation:(id)sender;
- (IBAction)cancelChangeLocationPopUp:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *changeLocationPopUp;
@property (strong) UIView *darkenView;
@property BOOL keyboardHiding;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIdicator;

- (void)hideKeyboard;

- (void)sendUpcReq: (NSNumber*) upc;
- (void)sendSkuReq: (NSNumber*) sku;

- (void)alertWithTitle: (NSString*)aTitle subtitle: (NSString*)aSubtitle;

@end
