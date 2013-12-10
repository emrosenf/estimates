//
//  EstimateTableViewController.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "LineItemTableViewController.h"
#import "EstimateTableViewController.h"


@interface EstimateTableViewController ()

@property (nonatomic, strong) NSMutableArray *presets;

@end

@implementation EstimateTableViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Estimate";
    
    self.presets = [@[
                      @{@"title": @"Basket of Apples", @"price": @"$10.95"},
                      @{@"title": @"Gallon of Milk", @"price": @"$3.25"},
                      @{@"title": @"Carton of Eggs", @"price": @"$1.99"},
                      @{@"title": @"Guacamole", @"price": @"$4.99"}
                      
                      ] mutableCopy];
    
    if (! self.data) {
        self.data = [NSMutableArray array];
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

#pragma mark - Table view data source
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"List Items";
            break;
        case 1:
            return @"Item Library";
            break;
        case 2:
            return @"New Item";
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return self.data.count;
    else if (section == 1) {
        return self.presets.count;
    } else return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        LineItemTableViewController *vc = [LineItemTableViewController new];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1) {
        [self addLineItem:self.presets[indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addLineItem:(NSDictionary *)lineItem {
    [self.data addObject:lineItem];
    [self.navigationController popToViewController:self animated:YES];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.data.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.data[indexPath.row][@"title"];
        cell.detailTextLabel.text = self.data[indexPath.row][@"price"];
    } else if (indexPath.section == 1) {
        cell.textLabel.text = self.presets[indexPath.row][@"title"];
        cell.detailTextLabel.text = self.presets[indexPath.row][@"price"];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"New Item";
    }

    
    // Configure the cell...
    
    return cell;
}


@end
