//
//  FBSFirebaseLoginViewController.h
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBSFirebaseLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)login:(UIButton *)sender;

@end
