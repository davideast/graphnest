//
//  FBSDevicesViewController.h
//  Graphnest
//
//  Created by David on 7/6/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>

@interface FBSDevicesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *devicesTables;
@property(nonatomic, retain) FAUser* faUser;
@end
