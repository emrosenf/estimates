//
//  DrillDownPrimaryViewController.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "DrillDownPrimaryViewController.h"
#import "DrillDownSecondaryViewController.h"

@interface DrillDownPrimaryViewController ()

@property (nonatomic, strong) NSMutableArray *rows;

@end

@implementation DrillDownPrimaryViewController
- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data = [NSMutableArray new];
    self.rows = @[
                  @{@"title": @"Outlet",
                    @"options": @[
                            @[@"Recessed", @"Surface Mount"],
                            @[@"Existing Circuit", @"New Circuit", @"Needs Conduit"]
                            ]
                    },
                  
                  @{@"title": @"Lighting"},
                  @{@"title": @"Switches"},
                  @{@"title": @"Boxes"},
                  
                  ];
    
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

- (void) save:(id)sender {
    [self.delegate addEstimate:self.data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (void)addItem:(NSDictionary *)item {
    [self.data addObject:item];
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:YES];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.data.count;
    } else {
        return self.rows.count;;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = self.data[indexPath.row][@"title"];
        cell.detailTextLabel.text = self.data[indexPath.row][@"details"];
    } else {
        cell.textLabel.text = self.rows[indexPath.row][@"title"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        DrillDownSecondaryViewController *vc = [DrillDownSecondaryViewController new];
        vc.data = self.rows[indexPath.row][@"options"];
        vc.delegate = self;
        vc.title = self.rows[indexPath.row][@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





@end
