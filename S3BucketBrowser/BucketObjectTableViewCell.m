//
//  BucketObjectTableViewCell.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "BucketObjectTableViewCell.h"
#import "BucketObject.h"

@implementation BucketObjectTableViewCell

- (void)setBucketObject:(BucketObject *)bucketObject
{
    _bucketObject = bucketObject;
    self.textLabel.text = bucketObject.key;
}

@end
