//
//  EstimateInputMethod.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomerTableViewController.h"

@protocol EstimateInputMethod <NSObject>

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) CustomerTableViewController *delegate;
@end
