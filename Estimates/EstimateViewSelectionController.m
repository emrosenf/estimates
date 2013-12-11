//
//  EstimateViewSelectionController.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "EstimateViewSelectionController.h"
#import "ListEstimateTableViewController.h"
#import "ImageEstimateTableViewController.h"
#import "DrillDownPrimaryViewController.h"
#import "EstimateInputMethod.h"

@interface EstimateViewSelectionController ()

@property (nonatomic, strong) NSArray *rows;

@end

@implementation EstimateViewSelectionController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rows = @[
                  @{@"title": @"List Entry",
                    @"class": [ListEstimateTableViewController class]},
                  @{@"title": @"Drill Down",
                    @"class": [DrillDownPrimaryViewController class]},
                  @{@"title": @"Voice Entry"},
                  @{@"title": @"Image Entry",
                    @"class": [ImageEstimateTableViewController class]}
                  ];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.rows.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.rows[indexPath.section][@"title"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class cls = self.rows[indexPath.section][@"class"];
    if (cls) {
        UIViewController<EstimateInputMethod> *vc = [cls new];
        vc.data = self.data;
        vc.delegate = self.delegate;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
