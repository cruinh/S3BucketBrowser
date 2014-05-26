//
//  SortsViewController.h
//  S3BucketBrowser
//
//  Created by cruinh on 5/11/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortsViewController : UITableViewController

@property (nonatomic, strong) NSArray *sortOptions;
@property (nonatomic, strong) NSArray *sortDisplayOptions;
@property BOOL sortAscending;
@property NSInteger selectedSort;
@property (nonatomic, strong) void (^completion)(SortsViewController* sender);

@end
