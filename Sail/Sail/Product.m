//
//  Product.m
//  Sail
//
//  Created by TheDarkKnight on 12/21/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize name;
@synthesize upc;
@synthesize image;
@synthesize shortDescription;
@synthesize price;
@synthesize store;

-(Product *)initWithName:(NSString *)aName upc:(NSNumber *)aUpc image:(NSString *)aImage shortDescription:(NSString *)
aShortDescription price:(NSNumber *)aPrice store:(NSString *)aStore{
    self = [super init];
    if (self) {
        name = aName;
        upc = aUpc;
        image = aImage;
        shortDescription = aShortDescription;
        price = aPrice;
        store = aStore;
    }
    return self;
}

@end
