//
//  FBSFirebaseLoginViewController.m
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSFirebaseLoginViewController.h"
#import <Firebase/Firebase.h>
#import <FirebaseSimpleLogin/FirebaseSimpleLogin.h>
#import "FBSNestLoginViewController.h"
#import "FBSMainViewController.h"

@interface FBSFirebaseLoginViewController ()

@end

@implementation FBSFirebaseLoginViewController {
    Firebase* fb;
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
    fb = [[Firebase alloc] initWithUrl: @"https://graphnest.firebaseio.com/"];
    [self.emailTextField becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(UIButton *)sender {

    FirebaseSimpleLogin* authClient = [[FirebaseSimpleLogin alloc] initWithRef: fb];
    [authClient loginWithEmail:self.emailTextField.text andPassword:self.passwordTextField.text
           withCompletionBlock:^(NSError* error, FAUser* user) {
               
               if (error != nil) {
                   // There was an error logging in to this account
                   
               } else {
                   // We are now logged in
                   //[self performSegueWithIdentifier:@"LOGIN_INTO_NEST" sender:user.authToken];
                   [self performSegueWithIdentifier:@"UNWIND_TO_LOGIN" sender:user];
               }
    }];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    FBSNestLoginViewController *nestVC = (FBSNestLoginViewController*) segue.destinationViewController;
//    nestVC.authToken = sender;
    FBSMainViewController *graphVC = (FBSMainViewController*) segue.destinationViewController;
    graphVC.faUser = sender;
}
@end
