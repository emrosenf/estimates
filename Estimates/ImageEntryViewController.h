//
//  ImageEntryViewController.h
//  Estimates
//
//  Created by Nick Lane-Smith on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerTableViewController.h"

@interface ImageEntryViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, weak) CustomerTableViewController *delegate;

@end
