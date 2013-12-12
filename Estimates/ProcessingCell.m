//
//  ProcessingCell.m
//  Estimates
//
//  Created by Evan Rosenfeld on 12/11/13.
//  Copyright (c) 2013 Everpilot. All rights reserved.
//

#import "ProcessingCell.h"

@interface ProcessingCell()

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation ProcessingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(110, 20, 160, 10)];
        self.progressView.progress = 0;
        [self.contentView addSubview:self.progressView];
    }
    return self;
}

- (void)processWithBlock:(void (^)())doneBlock {
    if (self.progressView.progress < 1) {
        self.progressView.progress += 0.1;
        double delayInSeconds = 0.15;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self processWithBlock:doneBlock];
        });
    } else {
        doneBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
