//
//  WLMRTDataGetter.h
//  Sail
//
//  Created by TheDarkKnight on 12/22/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
#import "Product.h"
#import <CoreLocation/CoreLocation.h>

@protocol DataGetterDelegate <NSObject>
- (void) resultingStores: (NSMutableArray*) stores;
- (void) resultingProduct:(Product *) product;
- (void) resultingError;
@end

@interface WLMRTDataGetter : NSObject

@property NSMutableData *responseData;

@property (strong) id <DataGetterDelegate> delegate;

@property (strong) NSNumber* salePrice;

@property (readonly) NSString* productFromSku;
@property (readonly) NSString* productFromUpc;

@property (readonly) NSString* storesFromZip;
@property (readonly) NSString* storesFromLatLng;

@property (readonly) NSString* wlmrtkey;

@property (readonly) NSNumber* areaRadius;

@property (readonly) NSString* requestType;

-(NSMutableArray*)convertToStores: (NSDictionary*) json;
-(Product*)convertToProduct: (NSDictionary*) json;
-(WLMRTDataGetter*)initWithDelegate: (id) aDelegate;

-(void)getProductWithSku:(NSNumber *)aSku;
-(void)getProductWithUpc:(NSNumber *)aUpc;

-(void)getStoresWithZip:(NSNumber *)aZip price:(NSNumber*)aPrice;
-(void)getStoresWithLat:(float)aLat lng:(float)aLng price:(NSNumber*)aPrice;

@property CLGeocoder* geoCoder;
@property CLLocation* myLoc;

@end