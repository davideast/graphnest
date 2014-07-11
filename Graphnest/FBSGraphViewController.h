//
//  FBSGraphViewController.h
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//
#import "FBSDevicesViewController.h"
#import "FBSNestGraph.h"
#import "FBSDeviceUser.h"
#import <UIKit/UIKit.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import <BEMSimpleLineGraphView.h>

@interface FBSGraphViewController : UIViewController <SecondDelegate, TouchReportDelegate>
@property (strong, nonatomic) IBOutlet FBSNestGraph *nestGraph;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *devicesButton;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property(nonatomic, retain) FAUser* faUser;
@property (strong, nonatomic) IBOutlet UIView *statsView;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UILabel *outsideLabel;
@property (strong, nonatomic) IBOutlet UISlider *graphSlider;
@property(nonatomic, retain) FBSDeviceUser* deviceUser;
@end
