//
//  DEMOCoverImageCell.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/19/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOCoverImageCell.h"

@implementation DEMOCoverImageCell

+ (DEMOCoverImageCell *)coverImageCell {
	return [[NSBundle mainBundle] loadNibNamed:@"DEMOCoverImageCell" owner:nil options:nil][0];
}

@end
