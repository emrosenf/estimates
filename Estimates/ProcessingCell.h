//
//  ProcessingCell.h
//  Estimates
//
//  Created by Evan Rosenfeld on 12/11/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ProcessingCell : UITableViewCell

- (void) processWithBlock:(void(^)())doneBlock;

@end
