//
//  FBSGraphViewController.h
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSDeviceUser.h"
#import <UIKit/UIKit.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import <BEMSimpleLineGraphView.h>

@interface FBSGraphViewController : UIViewController <BEMSimpleLineGraphDelegate, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGraph;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *devicesButton;
@property(nonatomic, retain) FAUser* faUser;
@property(nonatomic, retain) FBSDeviceUser* deviceUser;
//@property(nonatomic, retain) NSString* deviceId;
@end
