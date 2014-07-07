//
//  FBSMainViewController.h
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
@interface FBSMainViewController : UIViewController <UIAlertViewDelegate>
@property(nonatomic, retain) FAUser* faUser;
@end
