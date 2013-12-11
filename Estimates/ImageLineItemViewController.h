//
//  ImageLineItemViewController.h
//  Estimates
//
//  Created by Nick Lane-Smith on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageEstimateTableViewController.h"

@interface ImageLineItemViewController : UITableViewController
    @property (nonatomic, weak) ImageEstimateTableViewController *delegate;
@end
