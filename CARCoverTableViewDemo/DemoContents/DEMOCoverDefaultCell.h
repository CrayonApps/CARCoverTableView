//
//  DEMOCoverDefaultCell.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/19/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverScrollView.h"

@interface DEMOCoverDefaultCell : CARCoverScrollViewCell

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;

@end
