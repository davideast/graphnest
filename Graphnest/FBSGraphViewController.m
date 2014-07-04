//
//  FBSGraphViewController.m
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSGraphViewController.h"
#import <Firebase/Firebase.h>

@interface FBSGraphViewController ()

@end

@implementation FBSGraphViewController {
    Firebase *fb;
    NSArray *points;
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
    self.lineGraph.colorLine = [UIColor redColor];
    self.lineGraph.colorBottom  = [UIColor blueColor];
    self.lineGraph.colorXaxisLabel = [UIColor whiteColor];
    
    // hard code user for now
    fb = [[Firebase alloc] initWithUrl:@"https://graphnest.firebaseio.com/devices/lAb3q6xxUjFY3DhVFAOOMAw6L2reeSWu/ambient_temperature_f"];
    
    // total hack for now
    [fb authWithCredential:@"<token_here>" withCompletionBlock:^(NSError *error, id data) {
        //
        NSMutableArray *tempPoints = [[NSMutableArray alloc] init];
        [fb observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            //NSLog(@"%@ -> %@", snapshot.name, snapshot.value);
            [tempPoints addObject:snapshot.value];
            points = tempPoints;
            [self.lineGraph reloadGraph];
        }];
        
    } withCancelBlock:^(NSError *error) {
        //
    }];
    
    // Do any additional setup after loading the view.

}

-(NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return points.count;
}

-(CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    NSLog(@"%@", [points objectAtIndex:index]);
    return [[points objectAtIndex:index][@"value"] floatValue];
}

-(NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970: [[points objectAtIndex:index][@"timestamp"] longValue]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"hh";
    return [formatter stringFromDate:date];
}

-(NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
