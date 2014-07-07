//
//  FBSGraphViewController.m
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

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
    Firebase *fb;
    Firebase *userDevicesRef;
    Firebase *deviceRef;
    NSArray *points;
    NSArray *devices;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setGraphOptions];
    [self loadChart];
}

- (void) loadChart {
    // load up device to use
    // if there is a device id then load that device
    // else then find the users devices and use the first one
    if (self.deviceUser && self.deviceUser.device) {
        [self reloadChartForDeviceId:self.deviceUser.device.deviceId];
    } else {
        [self loadUserDevices:self.faUser.userId];
    }
}

- (void) setGraphOptions {
    self.lineGraph.delegate = self;
    self.lineGraph.enableBezierCurve = YES;
    self.lineGraph.enableTouchReport = YES;
    self.lineGraph.colorTop = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.lineGraph.colorBottom = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0]; // Leaving this not-set on iOS 7 will default to your window's tintColor
    self.lineGraph.colorLine = [UIColor whiteColor];
    self.lineGraph.colorXaxisLabel = [UIColor whiteColor];
    self.lineGraph.widthLine = 4.0;
    self.lineGraph.enablePopUpReport = YES;
}


- (void) loadUserDevices:(NSString *)userId {
    // create url for logged in user
    NSString *userUrl = [NSString stringWithFormat:@"%@/%@", kGraphnestUsersNS, userId];
    
    // create ref for logged in user
    userDevicesRef = [[Firebase alloc] initWithUrl:userUrl];
    
    // total hack for now
    [userDevicesRef authWithCredential:@"<my-token>" withCompletionBlock:^(NSError *error, id data) {
        
        [userDevicesRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            devices = [snapshot.value[@"devices"] allKeys];
            NSLog(@"%@", devices.firstObject);
            [self reloadChartForDeviceId:devices.firstObject];
            
        } withCancelBlock:^(NSError *error) {
            
            
        }];
        
    } withCancelBlock:^(NSError *error) {
        
        
    }];
}

- (void)reloadChartForDeviceId:(NSString *)device {
    NSString *deviceUrl = [NSString stringWithFormat:@"%@/%@/%@", kGraphnestDevicesNS, device, @"ambient_temperature_f"];
    fb = [[Firebase alloc] initWithUrl:deviceUrl];
    
    // total hack for now
    [fb authWithCredential:@"<my-token>" withCompletionBlock:^(NSError *error, id data) {
        
        // get the points for the graph
        NSMutableArray *tempPoints = [[NSMutableArray alloc] init];
        [fb observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            [tempPoints addObject:snapshot.value];
            points = tempPoints;
            [self.lineGraph reloadGraph];
        }];
        
    } withCancelBlock:^(NSError *error) {
        
        
    }];
}

#pragma mark - Line Graph
-(NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return points.count;
}

-(CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[points objectAtIndex:index][@"value"] floatValue];
}

-(NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970: [[points objectAtIndex:index][@"timestamp"] longValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"h a";
    return [formatter stringFromDate:date];
}

-(NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 10;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    FBSDevicesViewController *deviceVC = (FBSDevicesViewController*) segue.destinationViewController;
    deviceVC.faUser = self.faUser;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
