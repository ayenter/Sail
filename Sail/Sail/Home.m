//
//  Home.m
//  Sail
//
//  Created by TheDarkKnight on 12/17/15.
//  Copyright (c) 2015 Alec Yenter. All rights reserved.
//

#import "Home.h"

@implementation Home{
    CLLocationManager* locationManager;
}
@synthesize selectedLat;
@synthesize selectedLng;
@synthesize selectedZipCode;
@synthesize useCurrentLocation;
@synthesize storeResults;
@synthesize numOfResponses;
@synthesize numOfRequests;
@synthesize bby;
@synthesize darkenView;
@synthesize keyboardHiding;
@synthesize productResults;
@synthesize requestIsSku;
@synthesize wlmrt;
@synthesize laterTitle;


-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    locationManager.delegate = self; // we set the delegate of locationManager to self.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // setting the accuracy
    
    keyboardHiding = NO;
    useCurrentLocation = YES;
    _zipInput.delegate = self;
    _upcInput.delegate = self;
    _skuInput.delegate = self;
    bby = [[BBYDataGetter alloc] initWithDelegate:self];
    wlmrt = [[WLMRTDataGetter alloc] initWithDelegate:self];
    UITapGestureRecognizer *gestureHideKeyboard = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureHideKeyboard];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.upcInput becomeFirstResponder];
}

-(void)hideKeyboard{
    [self.view endEditing:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"location updated");
    CLLocation *crnLoc = [locations lastObject];
    
    [locationManager stopUpdatingLocation];
    
    self.selectedLat = crnLoc.coordinate.latitude;
    self.selectedLng = crnLoc.coordinate.longitude;
    
    NSLog(@"lat: %f lng: %f", self.selectedLat, self.selectedLng);
    
    if (requestIsSku) {
        [self sendSkuReq: [NSNumber numberWithLong: [self.skuInput.text longLongValue]]];
    } else {
        [self sendUpcReq: [NSNumber numberWithLong: [self.upcInput.text longLongValue]]];
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self alertWithTitle:@"Could not get the current location" subtitle: @"Ensure that location serivces is active."];
    NSLog(@"Error: %@",error.description);
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showstores"]){
        [self.loadingIdicator stopAnimating];
        NSLog(@"SHOW STORES");
        ResultsRoot* root = segue.destinationViewController;
        root.results = self.storeResults;
        root.product = self.productResults;
        for (Product* p in self.productResults){
            NSLog([NSString stringWithFormat:@"%@%@", p.name, p.price]);
        }
        [root.navigationItem setTitle: self.laterTitle];
        self.storeResults = nil;
        self.productResults = nil;
    }
}

- (void) resultingStores: (NSMutableArray*) stores{
    NSLog(@"RESULTING STORES");
    if ([self.storeResults count] <= 0) {
        self.storeResults = stores;
    } else {
        [self.storeResults addObjectsFromArray:stores];
    }
    NSLog(@"ABOUT TO GO");
    if (++numOfResponses >= numOfRequests) {
        NSLog(@"GOING");
        [self performSegueWithIdentifier:@"showstores" sender:self];
        numOfResponses = 0;
    }
}

-(void)resultingProduct:(Product *)product{
    NSLog(@"%@ - %@", product.name, product.store);
    NSLog(@"RESULTING PRODUCT");
    if (requestIsSku) {
        if (product) {
            [self sendUpcReq: product.upc];
        } else {
            [self alertWithTitle:@"Not Found" subtitle:@"The SKU could not be found."];
        }
    } else {
        if (product) {
            if ([self.productResults count] <= 0) {
                self.productResults = [NSMutableArray arrayWithObject:product];
            } else {
                [self.productResults addObject:product];
            }
        } else {
            if (numOfResponses+1 >= numOfRequests) {
                if (productResults && [productResults count]>0) {
                } else{
                    [self alertWithTitle:@"Not Found" subtitle:@"The UPC could not be found."];
                }
            }
        }
        if (++numOfResponses >= numOfRequests) {
            numOfRequests=0;
            numOfResponses=0;
            for (Product* p in self.productResults) {
                if (!useCurrentLocation) {
                    if ([p.store isEqualToString: @"Best Buy"]) {
                        [bby getStoresWithUpc:p.upc zip:selectedZipCode price:p.price];
                        numOfRequests++;
                    } else if ([p.store isEqualToString: @"Walmart"]) {
                        [wlmrt getStoresWithZip:selectedZipCode price:p.price];
                        numOfRequests++;
                    }
                } else {
                    if ([p.store isEqualToString: @"Best Buy"]) {
                        [bby getStoresWithUpc:p.upc lat:selectedLat lng:selectedLng price:p.price];
                        numOfRequests++;
                    } else if ([p.store isEqualToString:@"Walmart"]){
                        [wlmrt getStoresWithLat:selectedLat lng:selectedLng price:p.price];
                        numOfRequests++;
                    }
                }
            }
        }
    }
}

-(void)resultingError{
    [self alertWithTitle:@"Network Issue" subtitle:@"You must be connected to the internet to use this app."];
    [self.loadingIdicator stopAnimating];
}

- (void)alertWithTitle: (NSString*)aTitle subtitle: (NSString*)aSubtitle{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:aTitle
                                                    message:aSubtitle
                                                   delegate:nil
                                          cancelButtonTitle:@"Alllrrrighty Then!"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)upcGo:(id)sender {
    NSLog(@"UPCGO");
    laterTitle = self.upcInput.text;
    requestIsSku = NO;
    if ([self.upcInput.text length] == 12) {
        if (useCurrentLocation) {
            [locationManager requestWhenInUseAuthorization];
            [locationManager startUpdatingLocation];
        } else {
            [self sendUpcReq:[NSNumber numberWithLongLong: [self.upcInput.text longLongValue]]];
        }
    } else {
        [_upcInput setTextColor:[UIColor redColor]];
    }
}

- (IBAction)skuGo:(id)sender {
    NSLog(@"SKUGO");
    laterTitle = self.skuInput.text;
    requestIsSku = YES;
    if ([self.skuInput.text length] == 7) {
        if (useCurrentLocation) {
            NSLog(@"INITIATE CURRENT LOCATION");
            [locationManager requestWhenInUseAuthorization];
            NSLog(@"REQUESTED AUTHORIZATION");
            [locationManager startUpdatingLocation];
        } else {
            [self sendSkuReq:[NSNumber numberWithLongLong: [self.skuInput.text longLongValue]]];
        }
    } else {
        [_skuInput setTextColor:[UIColor redColor]];
    }
}

- (void)sendUpcReq: (NSNumber*) upc{
    requestIsSku = NO;
    numOfRequests=2;
    numOfResponses=0;
    [self.loadingIdicator startAnimating];
    [bby getProductWithUpc:upc];
    [wlmrt getProductWithUpc:upc];
}
- (void)sendSkuReq: (NSNumber*) sku{
    requestIsSku = YES;
    numOfRequests=1;
    numOfResponses=0;
    [self.loadingIdicator startAnimating];
    [bby getProductWithSku:sku];
}


- (IBAction)callChangeLocationPopUp:(id)sender {
    if (self.changeLocationPopUp.hidden) {
        darkenView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        darkenView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
        [self.view addSubview: darkenView];
        [[self.changeLocationPopUp layer] setCornerRadius:25.0f];
        self.changeLocationPopUp.hidden = NO;
        [self.view bringSubviewToFront: self.changeLocationPopUp];
        [self.zipInput becomeFirstResponder];
    } else {
        [darkenView removeFromSuperview];
        self.changeLocationPopUp.hidden = YES;
        [self.upcInput becomeFirstResponder];
    }
    
}
- (IBAction)changeLocation:(id)sender {
    if ([_zipInput.text length] == 5) {
        self.useCurrentLocation = NO;
        NSNumberFormatter *formt = [[NSNumberFormatter alloc] init];
        formt.numberStyle = NSNumberFormatterDecimalStyle;
        selectedZipCode = [formt numberFromString:self.zipInput.text];
        self.changeLocationPopUp.hidden = YES;
        [darkenView removeFromSuperview];
    } else {
        [_zipInput setTextColor: [UIColor redColor]];
    }
}

- (IBAction)useCurrentLocation:(id)sender {
    self.useCurrentLocation=YES;
    self.changeLocationPopUp.hidden = YES;
    [darkenView removeFromSuperview];
}

- (IBAction)cancelChangeLocationPopUp:(id)sender {
    [darkenView removeFromSuperview];
    self.changeLocationPopUp.hidden = YES;
    [self.upcInput becomeFirstResponder];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    if ([newString rangeOfCharacterFromSet:characterSet].location != NSNotFound)
    {
        return NO;
    }
    if (textField == _zipInput) {
        [_zipInput setTextColor:[UIColor blackColor]];
        return ([newString length]<=5);
    } else if (textField == _upcInput) {
        [_upcInput setTextColor:[UIColor blackColor]];
        return ([newString length]<=12);
    } else if (textField == _skuInput){
        [_skuInput setTextColor:[UIColor blackColor]];
        return ([newString length]<=7);
    } else {
        return YES;
    }
}
@end
