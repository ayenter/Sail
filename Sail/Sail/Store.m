//
//  Store.m
//  Sail
//
//  Created by TheDarkKnight on 12/20/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import "Store.h"

@implementation Store
@synthesize name;
@synthesize addressOne;
@synthesize addressTwo;
@synthesize city;
@synthesize region;
@synthesize postalCode;
@synthesize lat;
@synthesize lng;
@synthesize storeType;
@synthesize distance;
@synthesize chain;
@synthesize price;

-(Store *)initWithName:(NSString *)aName addressOne:(NSString *)aAddressOne addressTwo:(NSString *)aAddressTwo city:(NSString *)aCity region:(NSString *)aRegion postalCode:(NSNumber *)aPostalCode lat:(float)aLat lng:(float)aLng storeType:(NSString *)aStoreType distance:(NSNumber *)aDistance chain:(NSString *)aChain price:(NSNumber *)aPrice{
    self = [super init];
    if (self){
        name = aName;
        addressOne = aAddressOne;
        addressTwo = aAddressTwo;
        city = aCity;
        region = aRegion;
        postalCode = aPostalCode;
        lat = aLat;
        lng = aLng;
        storeType = aStoreType;
        distance = aDistance;
        chain = aChain;
        price = aPrice;
    }
    return self;
}


@end
