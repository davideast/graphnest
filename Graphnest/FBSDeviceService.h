//
//  FBSDeviceService.h
//  Graphnest
//
//  Created by David on 7/6/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBSDeviceService : NSObject

- (void) loadUserDevices:(NSString *) userId withBlock:(^*);

@end
/*
- (void) loadUserDevices:(NSString *)userId {
    // create url for logged in user
    NSString *userUrl = [NSString stringWithFormat:@"%@/%@", @"https://graphnest.firebaseio.com/users", userId];
    
    // create ref for logged in user
    userDevicesRef = [[Firebase alloc] initWithUrl:userUrl];
    
    [userDevicesRef authWithCredential:@"QjFSvWAukeTuzAHFB0w4TrlYrohywaHrUWD4ioEM" withCompletionBlock:^(NSError *error, id data) {
        
        [userDevicesRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            devices = [snapshot.value[@"devices"] allKeys];
            [self reloadChartForDeviceId:devices.firstObject];
            
        } withCancelBlock:^(NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
        
    } withCancelBlock:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}
*/