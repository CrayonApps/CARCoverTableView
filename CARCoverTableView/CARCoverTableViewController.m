//
//  CARCoverScrollViewController.m
//  CARCoverTableViewDemo
//
//  Created by Yamazaki Mitsuyoshi on 7/11/14.
//  Copyright (c) 2014 CrayonApps Inc. All rights reserved.
//

#import "CARCoverTableViewController.h"

@interface CARCoverTableViewController ()

@property (nonatomic, assign, getter = isScrolling) BOOL scrolling;

@end

@implementation CARCoverTableViewController

@dynamic coverTableView;

- (void)loadView {
	
	self.view = [[CARCoverTableView alloc] init];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	self.tableView = self.view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.coverScrollView.roughPagingEnabled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[self.coverScrollView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessor
- (CARCoverTableView *)coverTableView {
	NSAssert([self.tableView isKindOfClass:[CARCoverTableView class]], @"");
	return (CARCoverTableView *)self.tableView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	[self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	[self doesNotRecognizeSelector:_cmd];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end
