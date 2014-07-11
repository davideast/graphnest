//
//  FBSNestGraph.m
//  Graphnest
//
//  Created by David on 7/8/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//


#import "FBSNestGraph.h"
#import <Firebase/Firebase.h>

#define kGraphnestNS @"https://graphnest.firebaseio.com/"
#define kGraphnestUsersNS @"https://graphnest.firebaseio.com/users"
#define kGraphnestDevicesNS @"https://graphnest.firebaseio.com/devices"
@implementation FBSNestGraph {
    NSArray* devices;
    Firebase* fb;
    Firebase* userDevicesRef;
}

@synthesize touchReportDelegate;
@synthesize points;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init {
    self = [super init];
    [self setGraphOptions];
    return self;
}

- (void) setPoints:(NSArray *)newPoints {
    NSLog(@"%@", newPoints);
    //self.points = newPoints;
}

- (void) listen:(NSString *)deviceId {
    [self reloadChartForDeviceId:deviceId];
}

- (void) findDevice:(NSString *)userId {
    [self loadUserDevices:userId];
}

- (void)reloadChartForDeviceId:(NSString *)device {
    self.delegate = self;
    NSString *deviceUrl = [NSString stringWithFormat:@"%@/%@/%@", kGraphnestDevicesNS, device, @"ambient_temperature_f"];
    fb = [[Firebase alloc] initWithUrl:deviceUrl];
    
    // total hack for now
    [fb authWithCredential:@"QjFSvWAukeTuzAHFB0w4TrlYrohywaHrUWD4ioEM" withCompletionBlock:^(NSError *error, id data) {
        
        // get the points for the graph
        NSMutableArray *tempPoints = [[NSMutableArray alloc] init];
        [fb observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            [tempPoints addObject:snapshot.value];
            points = tempPoints;
            [self reloadGraph];
        }];
        
    } withCancelBlock:^(NSError *error) {
        
        
    }];
}


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



- (void) setGraphOptions {
    self.backgroundColor = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.enableBezierCurve = YES;
    self.enableTouchReport = YES;
    self.colorTop = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.colorBottom = [UIColor colorWithRed:0.0 green:140.0/255.0 blue:255.0/255.0 alpha:1.0]; // Leaving this not-set on iOS 7 will default to your window's tintColor
    self.colorLine = [UIColor whiteColor];
    //self.lineGraph.colorXaxisLabel = [UIColor whiteColor];
    self.widthLine = 4.0;
    self.enablePopUpReport = YES;
}

-(NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return points.count;
}

-(CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[points objectAtIndex:index][@"value"] floatValue];
}

-(NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 10;
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    NSString* dataValue = [NSString stringWithFormat:@"%@", [points objectAtIndex:index][@"value"]];
    NSString* dateValue = [self formatDate:@"EEEE, MMMM dd" atIndex:index];
    NSString* outsideValue = [NSString stringWithFormat:@"%@", [points objectAtIndex:index][@"outsideTemp"]];
    if([self.touchReportDelegate respondsToSelector:@selector(getReportData:)])
    {
        [self.touchReportDelegate getReportData: [[NSArray alloc] initWithObjects:dataValue, dateValue, outsideValue, nil]];
    }
}

-(NSString *)formatDate:(NSString *)format atIndex:(int) index{
    NSNumber *testTime = [points objectAtIndex:index][@"timestamp"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970: testTime.doubleValue / 1000];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
