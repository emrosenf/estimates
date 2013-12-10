//
//  AHTextFieldCell.h
//  Calendar
//
//  Created by Evan Rosenfeld on 4/26/12.
//  Copyright (c) 2012 Sirius Lab Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHTextFieldCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSString *placeholder;

@end
