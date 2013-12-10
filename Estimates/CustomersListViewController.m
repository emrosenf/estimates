//
//  CustomersTableViewController.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "CustomersListViewController.h"
#import "CustomerTableViewController.h"
#import "NewCustomerTableViewController.h"

@interface CustomersListViewController ()

@end

@implementation CustomersListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data = [@[
                   @{
                       @"name": @"John Smith",
                       @"estimates": [NSMutableArray array],
                    },
                   @{
                       @"name": @"Sally Jones",
                       @"estimates": [NSMutableArray array],
                       },
                   @{
                       @"name": @"Bob Green",
                       @"estimates": [NSMutableArray array],
                       },
                   @{
                       @"name": @"Charles Harris",
                       @"estimates": [NSMutableArray array],
                       }
                   ] mutableCopy];
                   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.title = @"Customers";
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void) actionAdd:(id)sender {
    NewCustomerTableViewController *vc = [NewCustomerTableViewController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) createCustomerWithName:(NSString *)name email:(NSString *)email {
    [self.data addObject:@{@"name": name, @"email": email, @"estimates": [NSMutableArray array]}];
    [self.navigationController popToRootViewControllerAnimated:NO];
    CustomerTableViewController *vc = [CustomerTableViewController new];
    vc.data = self.data.lastObject;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.data[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.data[indexPath.row][@"status"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerTableViewController *vc = [CustomerTableViewController new];
    vc.data = self.data[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
