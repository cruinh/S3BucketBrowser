//
//  BucketObjectTableViewController.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "BucketObjectTableViewController.h"
#import "ObjectAttributeViewController.h"
#import "BucketObject.h"

@interface BucketObjectTableViewController ()

@end

@implementation BucketObjectTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = self.bucketObject.key;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"BucketObjectAttributeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    switch(indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Key";
            cell.detailTextLabel.text = self.bucketObject.key;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 1:
            cell.textLabel.text = @"LastModified";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.bucketObject.lastModified];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 2:
            cell.textLabel.text = @"ETag";
            cell.detailTextLabel.text = self.bucketObject.eTag;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 3:
            cell.textLabel.text = @"Size";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",self.bucketObject.size];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 4:
            cell.textLabel.text = @"Owner";
            cell.detailTextLabel.text = self.bucketObject.owner;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 5:
            cell.textLabel.text = @"StorageClass";
            cell.detailTextLabel.text = self.bucketObject.storageClass;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        case 6:
            cell.textLabel.text = @"Show File";
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell*)sender
{
    ObjectAttributeViewController *destination = [segue destinationViewController];
    if ([sender.textLabel.text isEqualToString:@"Show File"])
    {
        destination.keyName = @"File";
        destination.value = self.bucketObject.key;
    }
    else
    {
        destination.keyName = sender.textLabel.text;
        destination.value = sender.detailTextLabel.text;
    }
}

@end
