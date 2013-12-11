//
//  DrillDownSecondaryViewController.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "DrillDownSecondaryViewController.h"

@interface DrillDownSecondaryViewController ()

@property (nonatomic, strong) NSMutableArray *indexes;

@end

@implementation DrillDownSecondaryViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.indexes = [NSMutableArray new];


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
    
    
}

- (void) save:(id)sender {
    NSMutableArray *arr = [NSMutableArray new];
    for (NSIndexPath *path in self.indexes) {
        [arr addObject:self.data[path.section][path.row]];
    }
    [self.delegate addItem:@{@"title": self.title,
                             @"details": [arr componentsJoinedByString:@", "]}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.data.count;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *title = self.data[indexPath.section][indexPath.row];
    if ([self.indexes containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = title;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if ([self.indexes containsObject:indexPath]) {
        [self.indexes removeObject:indexPath];
    } else {
        [self.indexes addObject:indexPath];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
