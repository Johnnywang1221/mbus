//
//  Stop.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "Stop.h"
#import "UMNetworkingSession.h"
#import "Route.h"
#import "Bus.h"

@interface Stop ()

@property (strong, nonatomic) UMNetworkingSession *networkingSession;

@end

@implementation Stop

- (instancetype)init {
    if (self = [super init]) {
        _networkingSession = [[UMNetworkingSession alloc] init];
    }
    return self;
}

- (void)fetchBusesServicingStop {
    NSMutableArray *routesArray = [NSMutableArray array];
    NSMutableArray *busArray = [NSMutableArray array];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_networkingSession fetchRoutesWithSuccessBlock:^(NSArray *routes) {
        for (Route *route in routes) {
            if ([route.stops containsObject:self.id]) {
                [routesArray addObject:route];
            }
        }
        
        [_networkingSession fetchBusLocationsWithSuccessBlock:^(NSArray *buses) {
            for (Bus *bus in buses) {
                for (Route *route in routesArray) {
                    if ([bus.route isEqualToString:route.id]) {
                        [busArray addObject:bus];
                    }
                }
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            self.busesServicingStop = [NSArray arrayWithArray:busArray];
        } errorBlock:NULL];
    } errorBlock:NULL];
}

- (void)fetchRoutesServicingStop {
    NSMutableArray *routesArray = [NSMutableArray array];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [_networkingSession fetchRoutesWithSuccessBlock:^(NSArray *routes) {
        for (Route *route in routes) {
            if ([route.stops containsObject:self.id]) {
                [routesArray addObject:route];
            }
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        self.routesServicingStop = [NSArray arrayWithArray:routesArray];
    } errorBlock:NULL];
}

#pragma mark MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uniqueName" : @"unique_name",
             @"humanName" : @"human_name",
             @"additionalName" : @"additional_name"};
}


@end
