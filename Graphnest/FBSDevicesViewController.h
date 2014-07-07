//
//  FBSDevicesViewController.h
//  Graphnest
//
//  Created by David on 7/6/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSDeviceUser.h"
#import <UIKit/UIKit.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>

@protocol SecondDelegate <NSObject>
-(void) secondViewControllerDismissed:(FBSDeviceUser *)deviceUser;
@end

@interface FBSDevicesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    id myDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *devicesTables;
@property(nonatomic, retain) FAUser* faUser;
@property (nonatomic, retain) id<SecondDelegate> myDelegate;
@end
