//
//  BucketObjectTableViewController.h
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BucketObject;

@interface BucketObjectTableViewController : UITableViewController
@property (nonatomic, strong) BucketObject *bucketObject;
@end
