//
//  DEMOCoverImageCell.h
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/19/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOCoverDefaultCell.h"

@interface DEMOCoverImageCell : DEMOCoverDefaultCell

@property (nonatomic, weak) IBOutlet UIImageView *imageView;

+ (DEMOCoverImageCell *)coverImageCell;

@end
