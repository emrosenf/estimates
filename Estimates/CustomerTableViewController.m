//
//  CustomerTableViewController.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "CustomerTableViewController.h"
#import "ListEstimateTableViewController.h"
#import "EstimateViewSelectionController.h"

@interface CustomerTableViewController ()

@end

@implementation CustomerTableViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.title = self.data[@"name"];
}

- (void) actionAdd:(id)sender {
    EstimateViewSelectionController *vc = [EstimateViewSelectionController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)addEstimate:(NSArray *)estimate {
    [self.data[@"estimates"] addObject:@{@"name": @"Estimate", @"lineItems": estimate, @"status": @"Sent"}];
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Approval" message:[NSString stringWithFormat:@"%@ has approved your estimate", self.title] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [self.data[@"estimates"] count];
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.data[@"estimates"][indexPath.row][@"name"];
        cell.detailTextLabel.text = self.data[@"estimates"][indexPath.row][@"status"];
    } else {
        cell.textLabel.text = @"New Estimate";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        EstimateViewSelectionController *vc = [EstimateViewSelectionController new];
        vc.delegate = self;
        vc.data = self.data[@"estimates"][indexPath.row][@"lineItems"];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self actionAdd:nil];
    }
}


@end
