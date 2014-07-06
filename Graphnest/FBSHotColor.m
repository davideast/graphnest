//
//  FBSHotColor.m
//  Graphnest
//
//  Created by David on 7/5/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "FBSHotColor.h"

@implementation UIColor(NewColor)
+(UIColor *)hotColor {
    return [UIColor colorWithRed:224.0f/255.0f
                           green:69.0f/255.0f
                            blue:2.0f/255.0f
                           alpha:1.0f];
}
@end