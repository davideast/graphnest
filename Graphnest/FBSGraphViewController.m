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
    NSArray *weatherPoints;
    NSArray *devices;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self setGraphOptions];
    [self loadChart];
}

- (IBAction)valueChanged:(UISlider *)sender {
    NSLog(@"%f", self.graphSlider.value);
}

- (void)secondViewControllerDismissed:(FBSDeviceUser *)deviceUser
{
    NSLog(@"%@", @"Here");
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

/*
- (void) setGraphOptions {
    self.lineGraph.delegate = self;
    self.lineGraph.enableBezierCurve = YES;
    self.lineGraph.enableTouchReport = YES;
    self.lineGraph.colorTop = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.lineGraph.colorBottom = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0]; // Leaving this not-set on iOS 7 will default to your window's tintColor
    self.lineGraph.colorLine = [UIColor whiteColor];
    //self.lineGraph.colorXaxisLabel = [UIColor whiteColor];
    self.lineGraph.widthLine = 4.0;
    self.lineGraph.enablePopUpReport = YES;
    self.statsView.layer.borderColor = [UIColor colorWithRed:226/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:1.0].CGColor;
}*/


- (void) loadUserDevices:(NSString *)userId {
    // create url for logged in user
    NSString *userUrl = [NSString stringWithFormat:@"%@/%@", kGraphnestUsersNS, userId];
    
    // create ref for logged in user
    userDevicesRef = [[Firebase alloc] initWithUrl:userUrl];
    
    // total hack for now
    [userDevicesRef authWithCredential:@"QjFSvWAukeTuzAHFB0w4TrlYrohywaHrUWD4ioEM" withCompletionBlock:^(NSError *error, id data) {
        
        [userDevicesRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            devices = [snapshot.value[@"devices"] allKeys];
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
    [fb authWithCredential:@"QjFSvWAukeTuzAHFB0w4TrlYrohywaHrUWD4ioEM" withCompletionBlock:^(NSError *error, id data) {
        
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

-(NSString *)formatDate:(NSString *)format atIndex:(int) index{
    NSNumber *testTime = [points objectAtIndex:index][@"timestamp"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: testTime.doubleValue / 1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}

#pragma mark - Line Graph
/*
-(NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return points.count;
}

-(CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[points objectAtIndex:index][@"value"] floatValue];
}*/

/*
-(NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    return [self formatDate:@"h a" atIndex:index];
}*/

-(NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 10;
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    self.valueLabel.text = [NSString stringWithFormat:@"%@", [points objectAtIndex:index][@"value"]];
    self.dateLabel.text = [self formatDate:@"EEEE, MMMM dd" atIndex:index];
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
