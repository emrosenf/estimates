//
//  CustomerTableViewController.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) NSString *customerName;

- (void) addEstimate:(NSArray *)estimate;
@end
