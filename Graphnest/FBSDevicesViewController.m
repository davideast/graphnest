//
//  FBSDevicesViewController.m
//  Graphnest
//
//  Created by David on 7/6/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSDevicesViewController.h"
#import "FBSGraphViewController.h"
#import "FBSDeviceUser.h"
#import <Firebase/Firebase.h>

@interface FBSDevicesViewController ()

@property (strong, nonatomic) NSArray *array;

@end

@implementation FBSDevicesViewController {
    Firebase *userDevicesRef;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadUserDevices:@"2"];
}

- (void) loadUserDevices:(NSString *)userId {
    // create url for logged in user
    NSString *userUrl = [NSString stringWithFormat:@"%@/%@", @"https://graphnest.firebaseio.com/users", userId];
    
    // create ref for logged in user
    userDevicesRef = [[Firebase alloc] initWithUrl:userUrl];
    
    [userDevicesRef authWithCredential:@"<my-token>" withCompletionBlock:^(NSError *error, id data) {
        
        // get user info
        [userDevicesRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            NSArray* devices = [snapshot.value[@"devices"] allValues];
            // TODO: Init array of FBSDeviceUser
            self.array = devices;
            [self.devicesTables reloadData];
            
        } withCancelBlock:^(NSError *error) {
            

            
        }];
        
    } withCancelBlock:^(NSError *error) {
        

        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table View Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *deviceName = [self.array objectAtIndex:indexPath.row][@"deviceName"];
    cell.textLabel.text = deviceName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    NSString *segueString = @"DETAIL_TO_GRAPH";
    
    // gather info and populate into a FBSDeviceUser
    NSString *deviceId = [self.array objectAtIndex:indexPath.row][@"deviceId"];
    NSString *deviceName = [self.array objectAtIndex:indexPath.row][@"deviceName"];
    
    // init FBSDeviceUser
    FBSDeviceUser* deviceUser = [[FBSDeviceUser alloc] init];
    deviceUser.faUser = self.faUser;
    deviceUser.device = [[FBSDevice alloc] init];
    deviceUser.device.deviceName = deviceName;
    deviceUser.device.deviceId = deviceId;
    
    //Perform a segue sending the FBSDeviceUser
    [self performSegueWithIdentifier:segueString sender:deviceUser];

}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FBSDeviceUser *deviceUser = (FBSDeviceUser *)sender;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    FBSGraphViewController *graphVC = (FBSGraphViewController*) segue.destinationViewController;
    
    graphVC.faUser = deviceUser.faUser;
    graphVC.deviceUser = deviceUser;
    
    NSLog(@"%@ -> %@", graphVC.faUser, @" userId");
    
}


@end
