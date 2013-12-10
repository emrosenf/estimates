//
//  AHTextFieldCell.m
//  Calendar
//
//  Created by Evan Rosenfeld on 4/26/12.
//  Copyright (c) 2012 Sirius Lab Ltd. All rights reserved.
//

#import "AHTextFieldCell.h"

@implementation AHTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
    }
    return self;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: [UIColorFromRGB(0xaaaaaa) colorWithAlphaComponent:0.6]}];
}

- (void)setTextField:(UITextField *)newTextField {
    _textField = newTextField;
    CGRect frm = CGRectMake(15, 0, 280, 44);
    if (_textField.superview) {
        [_textField removeFromSuperview];
    }
    _textField.frame = frm;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.contentView addSubview:_textField];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _textField.font = [UIFont systemFontOfSize:18.0f];
    _textField.returnKeyType = UIReturnKeyDone;
}


- (void)dealloc
{
    self.textField.delegate = nil;
    self.textField = nil;
}

@end
