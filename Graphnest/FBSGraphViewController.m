//
//  FBSGraphViewController.m
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSNestGraph.h"
#import "FBSGraphViewController.h"
#import "FBSDevicesViewController.h"
#import <Firebase/Firebase.h>
#import "MyColor.h"
#import "FBSHotColor.h"

#define kGraphnestNS @"https://graphnest.firebaseio.com/"
#define kGraphnestUsersNS @"https://graphnest.firebaseio.com/users"
#define kGraphnestDevicesNS @"https://graphnest.firebaseio.com/devices"

@interface FBSGraphViewController ()

@end

@implementation FBSGraphViewController {
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadChart];
}

- (IBAction)doneSliding:(UISlider *)sender {
    float percentage = round(self.graphSlider.value * 100) * .01;
    int index = round(percentage * self.nestGraph.points.count);
    NSUInteger count = [self.nestGraph.points count];
    NSArray * slice = [self.nestGraph.points subarrayWithRange:(NSRange){count-index, index}];
    [self.nestGraph setPoints:slice];
}

- (void)secondViewControllerDismissed:(FBSDeviceUser *)deviceUser
{
    self.deviceUser = deviceUser;
    self.faUser = deviceUser.faUser;
    [self loadChart];
}

- (void) getReportData:(NSArray *)arry {
    NSString* dataValue = arry[0];
    NSString* dateValue = arry[1];
    NSString* outsideTemp = arry[2];
    self.valueLabel.text = dataValue;
    self.dateLabel.text = dateValue;
    self.outsideLabel.text = outsideTemp;
}

- (void) loadChart {
    // load up device to use
    // if there is a device id then load that device
    // else then find the users devices and use the first one
    [self.nestGraph setGraphOptions];
    self.nestGraph.touchReportDelegate = self;
    //self.nestGraph.parent = self;
    if (self.deviceUser && self.deviceUser.device) {
        [self.nestGraph listen: self.deviceUser.device.deviceId];
        //[self reloadChartForDeviceId:self.deviceUser.device.deviceId];
    } else {
        [self.nestGraph findDevice: self.faUser.userId];
        //[self loadUserDevices:self.faUser.userId];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    FBSDevicesViewController *deviceVC = (FBSDevicesViewController*) segue.destinationViewController;
    deviceVC.faUser = self.faUser;
    deviceVC.myDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
