//
//  VoiceEstimateViewController.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/11/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "VoiceEstimateViewController.h"
#import "ProcessingCell.h"
#import "POVoiceHUD.h"
#import "VoiceLineItemViewController.h"
@interface VoiceEstimateViewController ()

@property (nonatomic, strong) POVoiceHUD *hud;

@end

@implementation VoiceEstimateViewController

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Estimate";
    
    
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
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return self.data.count;
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        POVoiceHUD *hud = [[POVoiceHUD alloc] initWithParentView:self.view];
        hud.title = @"Recording";
        [self.view addSubview:hud];
        [hud startForFilePath:[NSString stringWithFormat:@"%@/test.caf", NSTemporaryDirectory()]];
        double delayInSeconds = 5.0;
        self.hud = hud;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.hud cancelled:self];
            [self.hud removeFromSuperview];
            [self.data addObject:[@{@"state": @"processing",
                                   @"title": @"New Outlet"} mutableCopy]];
            [self.tableView reloadData];
        });
    } else {
        VoiceLineItemViewController *vc = [VoiceLineItemViewController new];
        vc.data = self.data[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)addLineItem:(NSDictionary *)lineItem {
    [self.data addObject:lineItem];
    [self.navigationController popToViewController:self animated:YES];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.data.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dt = nil;
    if (indexPath.section == 0)
        dt = self.data[indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell;
    
    if (indexPath.section == 0 && [dt[@"state"] isEqualToString:@"processing"]) {
        cell = [[ProcessingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"PROCESSING"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
    }
    
    if (indexPath.section == 0) {
        if ([dt[@"state"] isEqualToString:@"processing"]) {
            cell.textLabel.text = @"Processing";
            [((ProcessingCell*)cell) processWithBlock:^{
                NSMutableDictionary *dt = self.data[indexPath.row];
                dt[@"state"] = @"finished";
                [self.tableView reloadData];
            }];
        } else {
            cell.textLabel.text = dt[@"title"];
            cell.detailTextLabel.text = dt[@"price"];
        }

    } else {
        cell.textLabel.text = @"New Item";
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    // Configure the cell...
    
    return cell;
}

@end
