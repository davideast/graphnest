//
//  FBSGraphViewController.m
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSGraphViewController.h"
#import <Firebase/Firebase.h>
#import "MyColor.h"
#import "FBSHotColor.h"

@interface FBSGraphViewController ()

@end

@implementation FBSGraphViewController {
    Firebase *fb;
    Firebase *userDevicesRef;
    NSArray *points;
    NSArray *devices;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.lineGraph.delegate = self;
    self.lineGraph.enableBezierCurve = YES;
    self.lineGraph.enableTouchReport = YES;
    self.lineGraph.colorLine = [UIColor hotColor];
    self.lineGraph.colorTop  = [UIColor MyColor];
    self.lineGraph.colorBottom  = [UIColor MyColor];
    self.lineGraph.colorXaxisLabel = [UIColor blackColor];
    
    //devices = [[NSArray alloc] initWithObjects:@"hallway", @"den", nil];
    
    
    // hard code user for now
   
    // create url for logged in user
    NSString *userUrl = [NSString stringWithFormat:@"%@/%@", @"https://graphnest.firebaseio.com/users", self.faUser.userId];
   
    // create ref for logged in user
    userDevicesRef = [[Firebase alloc] initWithUrl:userUrl];
    
    [userDevicesRef authWithCredential:@"<my-token>" withCompletionBlock:^(NSError *error, id data) {
        
        [userDevicesRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            devices = [snapshot.value[@"devices"] allKeys];
            self.devicePicker.delegate = self;
            //NSInteger first = devices.firstObject;
            NSLog(@"%@", devices.firstObject);
            [self reloadChartForDeviceId:devices.firstObject];
            
        } withCancelBlock:^(NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
        
    } withCancelBlock:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
    // Do any additional setup after loading the view.

}

-(void)reloadChartForDeviceId:(NSString *)device {
    // total hack for now
    NSString *deviceUrl = [NSString stringWithFormat:@"%@/%@/%@", @"https://graphnest.firebaseio.com/devices", device, @"ambient_temperature_f"];
    NSLog(@"%@", deviceUrl);
    fb = [[Firebase alloc] initWithUrl:deviceUrl];
    [fb authWithCredential:@"<my-token>" withCompletionBlock:^(NSError *error, id data) {
        
        // get the points for the graph
        NSMutableArray *tempPoints = [[NSMutableArray alloc] init];
        [fb observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            //NSLog(@"%@ -> %@", snapshot.name, snapshot.value);
            [tempPoints addObject:snapshot.value];
            points = tempPoints;
            [self.lineGraph reloadGraph];
        }];
        
    } withCancelBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

-(NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return points.count;
}

-(CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    //NSLog(@"%@", [points objectAtIndex:index]);
    return [[points objectAtIndex:index][@"value"] floatValue];
}

-(NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970: [[points objectAtIndex:index][@"timestamp"] longValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh:mm a";
    return [formatter stringFromDate:date];
}

-(NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 10;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection by setting the chart to the new device
    //NSLog(@"%@", devices[row]);
    [self reloadChartForDeviceId:devices[row]];
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [devices count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    
    title = [@"" stringByAppendingFormat:@"Row %d",row];
    
    return [devices objectAtIndex:row];
}

//- (IBAction)unwindToGraphViewController:(UIStoryboardSegue *)segue {
//    
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
