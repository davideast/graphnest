//
//  FBSDeviceUser.h
//  Graphnest
//
//  Created by David on 7/6/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import "FBSDevice.h"

@interface FBSDeviceUser : NSObject

@property(nonatomic, retain) FAUser* faUser;
@property(nonatomic, retain) FBSDevice* device;

@end
