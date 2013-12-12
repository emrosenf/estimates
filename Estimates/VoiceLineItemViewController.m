//
//  VoiceLineItemViewController.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/11/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "VoiceLineItemViewController.h"
#import "AHTextFieldCell.h"

@interface VoiceLineItemViewController ()
@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation VoiceLineItemViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"New Item";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.backgroundColor = UIColorFromRGB(0x2d77b0);
    button.layer.cornerRadius = 8;
    [view addSubview:button];
    int margin = 10;
    button.frame = CGRectMake(margin, 0, self.view.frame.size.width - 2*margin, 42);
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [button addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    button.center = view.center;
    self.tableView.tableFooterView = view;
    
    self.cells = [NSMutableArray array];
    
    for (int i = 0; i < 2; i ++) {
        
        AHTextFieldCell *cell = [[AHTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        switch (i) {
            case 0:
                cell.placeholder = @"Price";
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                break;
            case 1:
                cell.placeholder = @"Notes";
                break;
            default:
                break;
        }
        
        [self.cells addObject:cell];
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = @"Take Photo";
    [self.cells addObject:cell];
    
    [self.tableView reloadData];
    
    
}

- (void) save:(id)sender {
    NSString *price = ((AHTextFieldCell*)self.cells[0]).textField.text;
    NSString *notes = ((AHTextFieldCell*)self.cells[1]).textField.text;
    self.data[@"price"] = [NSString stringWithFormat:@"$%@", price];
    self.data[@"notes"] = notes;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cells.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cells[indexPath.section];
}

@end
