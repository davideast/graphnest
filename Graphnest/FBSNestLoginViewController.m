//
//  FBSNestLoginViewController.m
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSNestLoginViewController.h"

@interface FBSNestLoginViewController ()

@end

@implementation FBSNestLoginViewController
// https://home.nest.com/login/oauth2?client_id=d80c70f9-444d-4dd6-a457-8a77d142e6ba&state=<JWT>

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
    //NSURL *websiteUrl = [NSURL URLWithString:@"https://home.nest.com/login/oauth2?client_id=d80c70f9-444d-4dd6-a457-8a77d142e6ba&state=ASLJFASLFASF"];
    //NSLog(@"%@", self.authToken);
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

@end
