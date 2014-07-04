//
//  FBSMainViewController.m
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSMainViewController.h"
#import "FBSGraphViewController.h"

@interface FBSMainViewController ()

@end

@implementation FBSMainViewController

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
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.faUser == nil) {
        [self performSegueWithIdentifier:@"LOAD_LOGIN" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"LOAD_GRAPH" sender:self.faUser];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LOAD_GRAPH"]) {
        FBSGraphViewController *graphVC = (FBSGraphViewController*) segue.destinationViewController;
        graphVC.faUser = sender;
    }
    //    FBSNestLoginViewController *nestVC = (FBSNestLoginViewController*) segue.destinationViewController;
    //    nestVC.authToken = sender;
    
}

- (IBAction)unwindToMainViewController:(UIStoryboardSegue *)segue {
    
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

@end
