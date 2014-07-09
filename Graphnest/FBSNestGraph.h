//
//  FBSNestGraph.h
//  Graphnest
//
//  Created by David on 7/8/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

#import "BEMSimpleLineGraphView.h"

@protocol TouchReportDelegate <NSObject>
-(void) getReportData:(NSArray *)arry;
@end


@interface FBSNestGraph : BEMSimpleLineGraphView <BEMSimpleLineGraphDelegate> {
    id touchReportDelegate;
}
@property (nonatomic, retain) id<TouchReportDelegate> touchReportDelegate;
- (void) setGraphOptions;
- (void) listen:(NSString *)deviceId;
- (void) findDevice:(NSString *)userId;
@end