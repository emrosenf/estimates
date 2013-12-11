//
//  ImageLineItemViewController.m
//  Estimates
//
//  Created by Nick Lane-Smith on 12/10/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "ImageLineItemViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <QuartzCore/QuartzCore.h>

#import "AFPhotoEditorController.h"
#import "AFPhotoEditorCustomization.h"
#import "AFOpenGLManager.h"
#import "AHTextFieldCell.h"


@interface ImageLineItemViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate, AFPhotoEditorControllerDelegate>

@property (nonatomic, strong) NSMutableArray *cells;
@property (strong, nonatomic) UIImageView * imagePreviewView;
@property BOOL firstViewLoad;

@property (nonatomic, strong) ALAssetsLibrary * assetLibrary;
@property (nonatomic, strong) ALAsset * currentAsset;
@property (nonatomic, strong) NSMutableArray * sessions;
@end

@implementation ImageLineItemViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Allocate Asset Library
    ALAssetsLibrary * assetLibrary = [[ALAssetsLibrary alloc] init];
    [self setAssetLibrary:assetLibrary];

    // Allocate Sessions Array
    NSMutableArray * sessions = [NSMutableArray new];
    [self setSessions:sessions];
    
    // Start the Aviary Editor OpenGL Load
    [AFOpenGLManager beginOpenGLLoad];

    
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
    [button.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    button.center = view.center;
    self.tableView.tableFooterView = view;
    
    
    // Add header view to display the image.
    UIView *headerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 260)];
    headerview.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    headerview.backgroundColor = [UIColor blueColor];
    
    //add an edit button into headerview
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    editButton.backgroundColor = UIColorFromRGB(0x667078);
    editButton.layer.cornerRadius = 8;
    [headerview addSubview:editButton];
    editButton.frame = CGRectMake(margin, 0, self.view.frame.size.width - 2*margin, 42);
    editButton.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [editButton setTitle:NSLocalizedString(@"Edit Photo", nil) forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editPhoto:) forControlEvents:UIControlEventTouchUpInside];
    CGPoint buttonCenter = headerview.center;
    buttonCenter.y = headerview.bounds.size.height - editButton.frame.size.height;
    editButton.center = buttonCenter;
    

    
    
    // Add the preview image into the headerview
    UIImageView * previewView = [UIImageView new];
    [previewView setContentMode:UIViewContentModeCenter];
    [previewView setImage:[UIImage imageNamed:@"pacific_open.png"]];
    [headerview addSubview:previewView];
    [self setImagePreviewView:previewView];

    CGRect imageRect = CGRectInset(headerview.bounds, 10.0f, 10.0f);
    imageRect.size.height -= editButton.frame.size.height;

    [[self imagePreviewView] setFrame:imageRect];
    
    self.tableView.tableHeaderView = headerview;

    self.firstViewLoad = true;

    //setup the cells
    self.cells = [NSMutableArray array];
    
    for (int i = 0; i < 2; i++) {
        AHTextFieldCell *cell = [[AHTextFieldCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        if (i == 0) {
            cell.placeholder = @"Price";
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        } else {
            cell.placeholder = @"Notes";
        }
        [self.cells addObject:cell];
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.firstViewLoad) {
        [self openImagePicker];
        self.firstViewLoad = false;
    }
}


- (void) save:(id)sender
{
    NSString *price = ((AHTextFieldCell*)self.cells[0]).textField.text;
    NSString *notes = ((AHTextFieldCell*)self.cells[1]).textField.text;

    //Grab thumbnail, turn into NSData for transport.
    UIImage *img = [UIImage imageWithCGImage:self.currentAsset.thumbnail];
    NSData *data = (NSData *)UIImageJPEGRepresentation(img, 6.0f);

    
    [self.delegate addLineItem:@{@"title": @"New Item", @"price": [NSString stringWithFormat:@"$%@", price], @"notes": notes, @"image":data}];
}

#pragma makr - Photo Editor

- (void) editPhoto:(id)sender
{
    [self launchEditorWithAsset:self.currentAsset];
}

#pragma mark - Photo Editor Launch Methods

- (void) launchEditorWithAsset:(ALAsset *)asset
{
    UIImage * editingResImage = [self editingResImageForAsset:asset];
    UIImage * highResImage = [self highResImageForAsset:asset];
    
    [self launchPhotoEditorWithImage:editingResImage highResolutionImage:highResImage];
}

- (void) launchEditorWithSampleImage
{
    UIImage * sampleImage = [UIImage imageNamed:@"Demo.png"];
    
    [self launchPhotoEditorWithImage:sampleImage highResolutionImage:nil];
}

#pragma mark - Photo Editor Creation and Presentation
- (void) launchPhotoEditorWithImage:(UIImage *)editingResImage highResolutionImage:(UIImage *)highResImage
{
    // Customize the editor's apperance. The customization options really only need to be set once in this case since they are never changing, so we used dispatch once here.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setPhotoEditorCustomizationOptions];
    });
    
    // Initialize the photo editor and set its delegate
    AFPhotoEditorController * photoEditor = [[AFPhotoEditorController alloc] initWithImage:editingResImage];
    [photoEditor setDelegate:self];
    
    // If a high res image is passed, create the high res context with the image and the photo editor.
    if (highResImage) {
        [self setupHighResContextForPhotoEditor:photoEditor withImage:highResImage];
    }
    
    // Present the photo editor.
    [self presentViewController:photoEditor animated:YES completion:nil];
}

- (void) setupHighResContextForPhotoEditor:(AFPhotoEditorController *)photoEditor withImage:(UIImage *)highResImage
{
    // Capture a reference to the editor's session, which internally tracks user actions on a photo.
    __block AFPhotoEditorSession *session = [photoEditor session];
    
    // Add the session to our sessions array. We need to retain the session until all contexts we create from it are finished rendering.
    [[self sessions] addObject:session];
    
    // Create a context from the session with the high res image.
    AFPhotoEditorContext *context = [session createContextWithImage:highResImage];
    
    __block ImageLineItemViewController * blockSelf = self;
    
    // Call render on the context. The render will asynchronously apply all changes made in the session (and therefore editor)
    // to the context's image. It will not complete until some point after the session closes (i.e. the editor hits done or
    // cancel in the editor). When rendering does complete, the completion block will be called with the result image if changes
    // were made to it, or `nil` if no changes were made. In this case, we write the image to the user's photo album, and release
    // our reference to the session.
    [context render:^(UIImage *result) {
        if (result) {
            UIImageWriteToSavedPhotosAlbum(result, nil, nil, NULL);
        }
        
        [[blockSelf sessions] removeObject:session];
        
        blockSelf = nil;
        session = nil;
        
    }];
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void) photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    [[self imagePreviewView] setImage:image];
    [[self imagePreviewView] setContentMode:UIViewContentModeScaleAspectFit];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Photo Editor Customization

- (void) setPhotoEditorCustomizationOptions
{
    // Set Tool Order
    NSArray * toolOrder = @[kAFCrop, kAFDraw, kAFText];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    // Set Custom Crop Sizes
    [AFPhotoEditorCustomization setCropToolOriginalEnabled:NO];
    [AFPhotoEditorCustomization setCropToolCustomEnabled:YES];
    NSDictionary * fourBySix = @{kAFCropPresetHeight : @(4.0f), kAFCropPresetWidth : @(6.0f)};
    NSDictionary * fiveBySeven = @{kAFCropPresetHeight : @(5.0f), kAFCropPresetWidth : @(7.0f)};
    NSDictionary * square = @{kAFCropPresetName: @"Square", kAFCropPresetHeight : @(1.0f), kAFCropPresetWidth : @(1.0f)};
    [AFPhotoEditorCustomization setCropToolPresets:@[fourBySix, fiveBySeven, square]];
    
    // Set Supported Orientations
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSArray * supportedOrientations = @[@(UIInterfaceOrientationPortrait), @(UIInterfaceOrientationPortraitUpsideDown), @(UIInterfaceOrientationLandscapeLeft), @(UIInterfaceOrientationLandscapeRight)];
        [AFPhotoEditorCustomization setSupportedIpadOrientations:supportedOrientations];
    }
}


#pragma mark - Image Picker

- (void)openImagePicker
{
    UIImagePickerController *imagePicker = [UIImagePickerController new];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSURL * assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    [[self assetLibrary] assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        if (asset){
            [self setCurrentAsset:asset];
            UIImage *newImage = [self editingResImageForAsset:asset];
            [[self imagePreviewView] setImage:newImage];
            [[self imagePreviewView] setContentMode:UIViewContentModeScaleAspectFit];
        }
    } failureBlock:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enable access to your device's photos." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // price & notes.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cells[indexPath.row];
}


#pragma mark - ALAssets Helper Methods

- (UIImage *)editingResImageForAsset:(ALAsset*)asset
{
    CGImageRef image = [[asset defaultRepresentation] fullScreenImage];
    
    return [UIImage imageWithCGImage:image scale:1.0 orientation:UIImageOrientationUp];
}

- (UIImage *)highResImageForAsset:(ALAsset*)asset
{
    ALAssetRepresentation * representation = [asset defaultRepresentation];
    
    CGImageRef image = [representation fullResolutionImage];
    UIImageOrientation orientation = [representation orientation];
    CGFloat scale = [representation scale];
    
    return [UIImage imageWithCGImage:image scale:scale orientation:orientation];
}

@end
