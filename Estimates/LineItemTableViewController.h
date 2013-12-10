//
//  LineItemTableViewController.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EstimateTableViewController.h"
@interface LineItemTableViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) EstimateTableViewController *delegate;

@end
