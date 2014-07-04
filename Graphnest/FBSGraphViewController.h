//
//  FBSGraphViewController.h
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import <BEMSimpleLineGraphView.h>

@interface FBSGraphViewController : UIViewController <BEMSimpleLineGraphDelegate>

@property (strong, nonatomic) IBOutlet BEMSimpleLineGraphView *lineGraph;
@property(nonatomic, retain) FAUser* faUser;
@end
