//
//  WLMRTDataGetter.m
//  Sail
//
//  Created by TheDarkKnight on 12/22/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import "WLMRTDataGetter.h"

@implementation WLMRTDataGetter
@synthesize delegate;
@synthesize responseData;
@synthesize wlmrtkey;
@synthesize areaRadius;
@synthesize requestType;
@synthesize productFromSku;
@synthesize productFromUpc;
@synthesize salePrice;
@synthesize storesFromLatLng;
@synthesize storesFromZip;
@synthesize geoCoder;
@synthesize myLoc;


- (WLMRTDataGetter*)initWithDelegate: (id) aDelegate{
    self = [super init];
    if (self){
        productFromSku = @"http://api.walmartlabs.com/v1/items?apiKey=%@&ids=%llu";
        productFromUpc = @"http://api.walmartlabs.com/v1/items?apiKey=%@&upc=%llu";
        storesFromZip = @"http://api.walmartlabs.com/v1/stores?apiKey=%@&zip=%llu&format=json";
        storesFromLatLng = @"http://api.walmartlabs.com/v1/stores?apiKey=%@&lon=%f&lat=%f&format=json";
        wlmrtkey = @"w4fkt22baxyqjmpwmcvmget7";
        areaRadius = @15;
        delegate = aDelegate;
        geoCoder = [[CLGeocoder alloc] init];;
    }
    return self;
}

-(void)getProductWithSku:(NSNumber *)aSku{
    requestType = @"product";
    NSString *getProduct = [NSString stringWithFormat: productFromSku, wlmrtkey, [aSku unsignedLongLongValue]];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:getProduct]];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(getProduct);
    (void)connect;
}

-(void)getProductWithUpc:(NSNumber *)aUpc{
    requestType = @"product";
    NSString *getProduct = [NSString stringWithFormat: productFromUpc, wlmrtkey, [aUpc unsignedLongLongValue]];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:getProduct]];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(getProduct);
    (void)connect;
}

-(void)getStoresWithZip:(NSNumber *)aZip price:(NSNumber*)aPrice{
    requestType = @"stores";
    salePrice = aPrice;
    //send to latlng for more stores
    [geoCoder geocodeAddressString:[aZip stringValue] completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil)
        {
            CLPlacemark* placemark = [placemarks objectAtIndex:0];
            [self getStoresWithLat:placemark.location.coordinate.latitude lng:placemark.location.coordinate.longitude price:aPrice];
        }
    }];
}
-(void)getStoresWithLat:(float)aLat lng:(float)aLng price:(NSNumber*)aPrice{
    requestType = @"stores";
    salePrice = aPrice;
    myLoc = [[CLLocation alloc] initWithLatitude:aLat longitude:aLng];
    NSString *getStores = [NSString stringWithFormat: storesFromLatLng, wlmrtkey, aLng, aLat];
    NSURLRequest *request = [NSURLRequest requestWithURL: [NSURL URLWithString:getStores]];
    NSURLConnection *connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(getStores);
    (void)connect;
}


-(NSMutableArray *)convertToStores:(NSDictionary *)json{
    NSMutableArray *resultingStores = [[NSMutableArray alloc] init];
    NSNumberFormatter *formt = [[NSNumberFormatter alloc] init];
    formt.numberStyle = NSNumberFormatterDecimalStyle;
    NSArray *jsonStores = [json objectForKey:@"stores"];
    if ([jsonStores count] > 0) {
        for (NSDictionary* dict in jsonStores) {
            NSArray* coord = [dict objectForKey:@"coordinates"];
            NSNumber *latnum = [coord objectAtIndex:1];
            NSNumber *lngnum = [coord objectAtIndex:0];
            CLLocation *loc = [[CLLocation alloc]initWithLatitude:[latnum floatValue] longitude:[lngnum floatValue]];
            CLLocationDistance dist = [loc distanceFromLocation: myLoc];
            [resultingStores addObject:
             [[Store alloc]
              initWithName:[dict objectForKey:@"city"]
              addressOne:[dict objectForKey:@"streetAddress"]
              addressTwo:@""
              city:[dict objectForKey:@"city"]
              region:[dict objectForKey:@"stateProvCode"]
              postalCode:[formt numberFromString:[dict objectForKey:@"zip"]]
              lat:[latnum floatValue]
              lng:[lngnum floatValue]
              storeType:[dict objectForKey:@"name"]
              distance: [NSNumber numberWithFloat: (dist*0.000621371)]
              chain:@"Walmart"
              price:salePrice]];
        }
    }
    return resultingStores;
}

-(Product *)convertToProduct:(NSDictionary *)json{
    //NSLog(@"CONVERTING");
    NSNumber* jsonError = [json objectForKey:@"errors"];
    if (jsonError==nil) {
        NSNumberFormatter *formt = [[NSNumberFormatter alloc] init];
        formt.numberStyle = NSNumberFormatterDecimalStyle;
        NSArray *jsonProducts = [json objectForKey:@"items"];
        NSDictionary* dict = [jsonProducts objectAtIndex:0];
        NSString *name = [dict objectForKey:@"name"];
        NSNumber *upc = [formt numberFromString:[dict objectForKey:@"upc"]];
        NSString *image = [dict objectForKey:@"largeImage"];
        NSString *shortDescription = [dict objectForKey:@"shortDescription"];
//        NSError *err = nil;
//        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"&#([0-9]+);" options:NSRegularExpressionCaseInsensitive error:&err];
//        NSString *modifiedDescription = [regex stringByReplacingMatchesInString:shortDescription options:0 range:NSMakeRange(0, [shortDescription length]) withTemplate:@""];
        NSNumber * price = [dict objectForKey:@"salePrice"];
        return [[Product alloc] initWithName:name upc:upc image:image shortDescription:shortDescription price:price store:@"Walmart"];
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
    
    //NSLog([[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding]);
    
    NSError* error;
    NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:kNilOptions
                                                                 error:&error];
    if (!error) {
        for (id key in dictionary) {
            //NSLog(@"key: %@, value: %@ \n", key, [dictionary objectForKey:key]);
        }
        if ([requestType isEqualToString:@"stores"]) {
            NSArray* stor = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers
                                                             error:&error];
            NSMutableArray *stores = [self convertToStores:[[NSDictionary alloc] initWithObjectsAndKeys:stor, @"stores", nil]];
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
