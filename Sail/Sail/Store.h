//
//  Store.h
//  Sail
//
//  Created by TheDarkKnight on 12/20/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Store : NSObject

@property (readonly) NSString *name;
@property (readonly) NSString *addressOne;
@property (readonly) NSString *addressTwo;
@property (readonly) NSString *city;
@property (readonly) NSString *region;
@property (readonly) NSNumber *postalCode;
@property (readonly) float lat;
@property (readonly) float lng;
@property (readonly) NSString *storeType;
@property (readonly) NSNumber *distance;
@property (readonly) NSString *chain;
@property (readonly) NSNumber *price;

- (Store*) initWithName: (NSString*) aName
             addressOne: (NSString*) aAddressOne
             addressTwo: (NSString*) aAddressTwo
                   city: (NSString*) aCity
                 region: (NSString*) aRegion
             postalCode: (NSNumber*) aPostalCode
                    lat: (float) aLat
                    lng: (float) aLng
              storeType: (NSString*) aStoreType
               distance: (NSNumber*) aDistance
                  chain: (NSString*) aChain
                  price: (NSNumber*) aPrice;

@end
