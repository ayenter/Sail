//
//  BBYDataGetter.h
//  Sail
//
//  Created by TheDarkKnight on 12/20/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Store.h"
#import "Product.h"

@protocol DataGetterDelegate <NSObject>
- (void) resultingStores: (NSMutableArray*) stores;
- (void) resultingProduct:(Product *) product;
- (void) resultingError;
@end

@interface BBYDataGetter : NSObject

@property NSMutableData *responseData;

@property (strong) id <DataGetterDelegate> delegate;

@property (strong) NSNumber* salePrice;


@property (readonly) NSString* storesFromUpcZip;
@property (readonly) NSString* storesFromUpcLatLng;

@property (readonly) NSString* storesFromSkuZip;
@property (readonly) NSString* storesFromSkuLatLng;

@property (readonly) NSString* productFromSku;
@property (readonly) NSString* productFromUpc;

@property (readonly) NSString* bbyKey;

@property (readonly) NSNumber* areaRadius;

@property (readonly) NSString* requestType;

-(NSMutableArray*)convertToStores: (NSDictionary*) json;
-(Product*)convertToProduct: (NSDictionary*) json;
-(BBYDataGetter*)initWithDelegate: (id) aDelegate;
-(void)getStoresWithUpc:(NSNumber *)aUpc zip:(NSNumber *)aZip price:(NSNumber*)aPrice;
-(void)getStoresWithUpc:(NSNumber *)aUpc lat:(float)aLat lng:(float)aLng price:(NSNumber*)aPrice;
-(void)getStoresWithSku:(NSNumber *)aSku zip:(NSNumber *)aZip price:(NSNumber*)aPrice;
-(void)getStoresWithSku:(NSNumber *)aSku lat:(float)aLat lng:(float)aLng price:(NSNumber*)aPrice;

-(void)getProductWithSku:(NSNumber *)aSku;
-(void)getProductWithUpc:(NSNumber *)aUpc;

@end
