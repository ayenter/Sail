//
//  BBYDataGetter.m
//  Sail
//
//  Created by TheDarkKnight on 12/20/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import "BBYDataGetter.h"

@implementation BBYDataGetter
@synthesize delegate;
@synthesize responseData;
@synthesize storesFromUpcLatLng;
@synthesize storesFromUpcZip;
@synthesize storesFromSkuLatLng;
@synthesize storesFromSkuZip;
@synthesize bbyKey;
@synthesize areaRadius;
@synthesize requestType;
@synthesize productFromSku;
@synthesize productFromUpc;
@synthesize salePrice;


- (BBYDataGetter*)initWithDelegate: (id) aDelegate{
    self = [super init];
    if (self){
        storesFromUpcZip = @"http://api.bestbuy.com/v1/stores(area(%llu,%llu))+products(upc=%llu)?apiKey=%@&format=json&show=name,address,address2,city,region,postalCode,location,lat,lng,distance,storeType";
        storesFromUpcLatLng = @"http://api.bestbuy.com/v1/stores(area(%f,%f,%llu))+products(upc=%llu)?apiKey=%@&format=json&show=name,address,address2,city,region,postalCode,location,lat,lng,distance,storeType";
        storesFromSkuZip = @"http://api.bestbuy.com/v1/stores(area(%llu,%llu))+products(sku=%llu)?apiKey=%@&format=json&show=name,address,address2,city,region,postalCode,location,lat,lng,distance,storeType";
        storesFromSkuLatLng = @"http://api.bestbuy.com/v1/stores(area(%f,%f,%llu))+products(sku=%llu)?apiKey=%@&format=json&show=name,address,address2,city,region,postalCode,location,lat,lng,distance,storeType";
        productFromSku = @"http://api.bestbuy.com/v1/products(sku=%llu)?show=name,upc,largeImage,shortDescription,salePrice&apiKey=%@&format=json";
        productFromUpc = @"http://api.bestbuy.com/v1/products(upc=%llu)?show=name,upc,largeImage,shortDescription,salePrice&apiKey=%@&format=json";
        bbyKey = @"7t53xwdgugmaxuuzp6vsb95w";
        areaRadius = @15;
        delegate = aDelegate;
    }
    return self;
}

-(void)getProductWithSku:(NSNumber *)aSku{
    requestType = @"product";
    NSString *getProduct = [NSString stringWithFormat: productFromSku, [aSku unsignedLongLongValue], bbyKey];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:getProduct]];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(getProduct);
    (void)connect;
}

-(void)getProductWithUpc:(NSNumber *)aUpc{
    requestType = @"product";
    NSString *getProduct = [NSString stringWithFormat: productFromUpc, [aUpc unsignedLongLongValue], bbyKey];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:getProduct]];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(getProduct);
    (void)connect;
}

-(void)getStoresWithSku:(NSNumber *)aSku zip:(NSNumber *)aZip price:(NSNumber *)aPrice{
    requestType = @"stores";
    salePrice = aPrice;
    NSString *getStores = [NSString stringWithFormat:storesFromSkuZip, [aZip unsignedLongLongValue], [areaRadius unsignedLongLongValue], [aSku unsignedLongLongValue], bbyKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getStores]];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(getStores);
    (void)connect;
}

-(void)getStoresWithSku:(NSNumber *)aSku lat:(float)aLat lng:(float)aLng price:(NSNumber *)aPrice{
    requestType = @"stores";
    salePrice = aPrice;
    NSString *getStores = [NSString stringWithFormat:storesFromSkuLatLng, aLat, aLng, [areaRadius unsignedLongLongValue], [aSku unsignedLongLongValue], bbyKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getStores]];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(getStores);
    (void)connect;
}

-(void)getStoresWithUpc:(NSNumber *)aUpc zip:(NSNumber *)aZip price:(NSNumber *)aPrice{
    requestType = @"stores";
    salePrice = aPrice;
    NSString *getStores = [NSString stringWithFormat:storesFromUpcZip, [aZip unsignedLongLongValue], [areaRadius unsignedLongLongValue], [aUpc unsignedLongLongValue], bbyKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getStores]];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(getStores);
    (void)connect;
}

-(void)getStoresWithUpc:(NSNumber *)aUpc lat:(float)aLat lng:(float)aLng price:(NSNumber *)aPrice{
    requestType = @"stores";
    salePrice = aPrice;
    NSString *getStores = [NSString stringWithFormat:storesFromUpcLatLng, aLat, aLng, [areaRadius unsignedLongLongValue], [aUpc unsignedLongLongValue], bbyKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getStores]];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(getStores);
    (void)connect;
}



-(NSMutableArray *)convertToStores:(NSDictionary *)json{
    NSNumber* jsonTotal = [json objectForKey:@"total"];
    NSMutableArray *resultingStores = [[NSMutableArray alloc] init];
    NSNumberFormatter *formt = [[NSNumberFormatter alloc] init];
    formt.numberStyle = NSNumberFormatterDecimalStyle;
    if ([jsonTotal intValue] > 0) {
        NSArray *jsonStores = [json objectForKey:@"stores"];
        for (NSDictionary* dict in jsonStores) {
            NSNumber *latnum = [dict objectForKey:@"lat"];
            NSNumber *lngnum = [dict objectForKey:@"lng"];
            [resultingStores addObject:
                    [[Store alloc]
                     initWithName:[dict objectForKey:@"name"]
                                     addressOne:[dict objectForKey:@"address"]
                                     addressTwo:[dict objectForKey:@"address2"]
                                           city:[dict objectForKey:@"city"]
                                         region:[dict objectForKey:@"region"]
                                     postalCode:[formt numberFromString:[dict objectForKey:@"postalCode"]]
                                            lat:[latnum floatValue]
                                            lng:[lngnum floatValue]
                                      storeType:[dict objectForKey:@"storeType"]
                                       distance:[dict objectForKey:@"distance"]
                                      chain:@"Best Buy"
                                          price:salePrice]];
        }
    }
    return resultingStores;
}

-(Product *)convertToProduct:(NSDictionary *)json{
    //NSLog(@"CONVERTING");
    NSNumber* jsonTotal = [json objectForKey:@"total"];
    if ([jsonTotal intValue] > 0) {
        NSNumberFormatter *formt = [[NSNumberFormatter alloc] init];
        formt.numberStyle = NSNumberFormatterDecimalStyle;
        NSArray *jsonProducts = [json objectForKey:@"products"];
        NSDictionary* dict = [jsonProducts objectAtIndex:0];
        NSString *name = [dict objectForKey:@"name"];
        NSNumber *upc = [formt numberFromString:[dict objectForKey:@"upc"]];
        NSString *image = [dict objectForKey:@"largeImage"];
        NSString *shortDescription = [dict objectForKey:@"shortDescription"];
        NSError *err = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"&#([0-9]+);" options:NSRegularExpressionCaseInsensitive error:&err];
        NSString *modifiedDescription = [regex stringByReplacingMatchesInString:shortDescription options:0 range:NSMakeRange(0, [shortDescription length]) withTemplate:@""];
        NSNumber * price = [dict objectForKey:@"salePrice"];
        return [[Product alloc] initWithName:name upc:upc image:image shortDescription:modifiedDescription price:price store:@"Best Buy"];
    } else {
        return nil;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    if(!responseData){
        responseData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    NSError* error;
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:kNilOptions
                                                                 error:&error];
    if (!error) {
        for (id key in dictionary) {
            //NSLog(@"key: %@, value: %@ \n", key, [dictionary objectForKey:key]);
        }
        if ([requestType isEqualToString:@"stores"]) {
            //NSLog(@"STORES RESPONSES");
            NSMutableArray *stores = [self convertToStores:dictionary];
            [delegate resultingStores: stores];
        } else if ([requestType isEqualToString:@"product"]){
            NSLog(@"PRODUCT RESPONSES");
            Product *product = [self convertToProduct:dictionary];
            NSLog(@"PRODUCT CONVERTED");
            [delegate resultingProduct: product];
        }
        responseData = nil;
        
//        Store *tester = [stores objectAtIndex:0];
//        NSLog(@"connection did finish: %@ %@ %@ %@ %@ %llu %f %f %@ %lf", tester.name, tester.addressOne, tester.addressTwo, tester.city, tester.region, [tester.postalCode unsignedLongLongValue], tester.lat, tester.lng, tester.storeType, [tester.distance doubleValue]);
    } else {
        // TODO :  ERROR POP-UP
        [delegate resultingError];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [delegate resultingError];
}

@end

