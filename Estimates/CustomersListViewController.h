//
//  CustomersTableViewController.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomersListViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *data;
- (void) createCustomerWithName:(NSString *)name email:(NSString *)email;
@end
