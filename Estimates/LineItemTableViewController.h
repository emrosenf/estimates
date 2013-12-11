//
//  LineItemTableViewController.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListEstimateTableViewController.h"
#import <MLPAutoCompleteTextField/MLPAutoCompleteTextField.h>
@interface LineItemTableViewController : UITableViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate>

@property (nonatomic, weak) ListEstimateTableViewController *delegate;

@end
