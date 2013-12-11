//
//  LineItemTableViewController.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/3/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "LineItemTableViewController.h"
#import "AHTextFieldCell.h"

@interface LineItemTableViewController ()
@property (nonatomic, strong) NSMutableArray *cells;
@end

@implementation LineItemTableViewController

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
    
    for (int i = 0; i < 3; i ++) {
        
        AHTextFieldCell *cell = [[AHTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        switch (i) {
            case 0: {
                MLPAutoCompleteTextField *tf = [[MLPAutoCompleteTextField alloc] initWithFrame:cell.textField.frame];
                cell.textField = tf;
                tf.autoCompleteTableAppearsAsKeyboardAccessory = YES;
                tf.autoCompleteDataSource = self;
                tf.autoCompleteFontSize = 16.;
                tf.autoCompleteDelegate = self;
                tf.autoCompleteTableCellBackgroundColor = [UIColor whiteColor];
                cell.placeholder = @"Title";
                break;
            }
            case 1:
                cell.placeholder = @"Price";
                cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                break;
            case 2:
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
    NSString *title = ((AHTextFieldCell*)self.cells[0]).textField.text;
    NSString *price = ((AHTextFieldCell*)self.cells[1]).textField.text;
    NSString *notes = ((AHTextFieldCell*)self.cells[2]).textField.text;
    [self.delegate addLineItem:@{@"title": title, @"price": [NSString stringWithFormat:@"$%@", price], @"notes": notes}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Autocomplete


//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    
    NSArray *completions = @[@"20A circuit", @"30A circuit", @"Wall Plate", @"4-prong outlet", @"Dimmer wwitch"];
    
    handler(completions);
}

#pragma mark - MLPAutoCompleteTextField Delegate


- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{

}



#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.cells.count - 1) {
        UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
        cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        cameraUI.allowsEditing = NO;
        
        cameraUI.delegate = self;
        
        [self.navigationController presentViewController: cameraUI animated: YES completion:nil];
    }
}

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
