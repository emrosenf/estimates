//
//  ImageEstimateTableViewController.m
//  Estimates
//
//  Created by Nick Lane-Smith on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "ImageEstimateTableViewController.h"
#import "ImageLineItemViewController.h"

@interface ImageEstimateTableViewController ()

@end

@implementation ImageEstimateTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Estimate";

    if (!self.data) {
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
        [button setTitle:NSLocalizedString(@"Send Estimate", nil) forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
        button.center = view.center;
        self.tableView.tableFooterView = view;
    }
    
}

- (void) save:(id)sender {
    [self.delegate addEstimate:self.data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Line Items";
            break;
        case 1:
            return @"New Item";
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.data.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (!cell) {
        //make a generic cell.
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0) {
        //line items.
    } else if (indexPath.section == 1) {
        // new item.
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"New Item";
        cell.imageView.image = [UIImage imageNamed:@"camera.png"];
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ImageLineItemViewController *ivc = [ImageLineItemViewController new];
        ivc.delegate = self;
        [self.navigationController pushViewController:ivc animated:YES];
    } else if (indexPath.section == 1) {
        //  [self addLineItem:self.presets[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
