//
//  Product.h
//  Sail
//
//  Created by TheDarkKnight on 12/21/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject

@property NSString* name;
@property NSNumber* upc;
@property NSString* image;
@property NSString* shortDescription;
@property NSNumber* price;
@property NSString* store;

- (Product*) initWithName: (NSString*)aName upc: (NSNumber*)aUpc image: (NSString*) aImage shortDescription: (NSString*)aShortDescription price: (NSNumber*)aPrice store: (NSString*)aStore;

@end
