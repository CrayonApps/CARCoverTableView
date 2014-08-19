//
//  DEMOCoverLabelCell.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/19/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOCoverLabelCell.h"

@implementation DEMOCoverLabelCell

+ (DEMOCoverLabelCell *)coverLabelCell {
	return [[NSBundle mainBundle] loadNibNamed:@"DEMOCoverLabelCell" owner:nil options:nil][0];
}

@end
