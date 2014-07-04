//
//  FBSNestLoginViewController.h
//  Graphnest
//
//  Created by David on 7/3/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBSNestLoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *oAuthWebView;
@property (nonatomic, strong) NSString *authToken;

@end
