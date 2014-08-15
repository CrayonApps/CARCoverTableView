//
//  DEMOCoverScrollViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 8/13/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "DEMOCoverScrollViewController.h"

@interface DEMOCoverView : UIView

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;

+ (DEMOCoverView *)coverView;

@end

@interface DEMOCoverScrollViewController ()

@end

@implementation DEMOCoverScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CARCoverScrollViewDataSource
- (UIView *)scrollView:(CARCoverScrollView *)scrollView viewAtIndex:(NSInteger)index {

	DEMOCoverView *view = [scrollView dequeReusableView];
	if (view == nil) {
		view = [DEMOCoverView coverView];
	}
	
	UIViewController *childViewController = self.childViewControllers[0];
	
	view.imageView.image = [UIImage imageNamed:@"image001"];
	view.titleLabel.text = childViewController.title; //[NSString stringWithFormat:@"Cover %02d", index];
	
	return view;
}

#pragma mark - CARCoverScrollViewDelegate
/*
 - (void)scrollView:(CARCoverScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index {
 NSLog(@"CARCoverScrollView did select item at index: %ld", (long)index);
 }
 */

@end

@implementation DEMOCoverView

+ (DEMOCoverView *)coverView {
	return [[NSBundle mainBundle] loadNibNamed:@"DEMOCoverView" owner:nil options:nil][0];
}

@end