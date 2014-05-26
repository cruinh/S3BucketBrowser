//
//  BucketViewController.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "BucketViewController.h"
#import "MBProgressHUD.h"
#import "AFAmazonS3Manager.h"
#import "AFOnoResponseSerializer.h"
#import "BucketObjectTableViewController.h"
#import "BucketObjectTableViewCell.h"
#import "S3Manager.h"
#import "BucketObject.h"
#import "NSManagedObject+MagicalRecord.h"
#import "Bucket.h"
#import "NSManagedObject+MagicalFinders.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalSaves.h"
#import "SortsViewController.h"

#import <MagicalRecord/MagicalRecord.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Ono/ONOXMLDocument.h>

@interface BucketViewController ()
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *sortOptions;
@property (nonatomic, strong) NSArray *sortDisplayOptions;
@property BOOL sortAscending;
@property NSInteger selectedSort;
@end

@implementation BucketViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sortAscending = YES;
    self.selectedSort = 0;
    self.sortOptions = @[@"key",@"lastModified",@"size"];
    self.sortDisplayOptions = @[@"Key",@"Last Modified",@"Size"];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStyleBordered target:self action:@selector(_onSortButtonTapped:)];
    self.navigationItem.rightBarButtonItem = rightButton;

    self.fetchedResultsController = [self _fetchedResultsControllerForBucket:[S3Manager sharedInstance].bucketName];

    [self _queryS3];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    NSString *bucketName = [S3Manager sharedInstance].bucketName;
    self.navigationItem.title = bucketName;
}

- (void)_onSortButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:@"BucketToSortsSegue" sender:self];
}

-(NSFetchedResultsController *)_fetchedResultsControllerForBucket:(NSString*)bucketName
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bucket.name=%@",bucketName];
    NSFetchedResultsController *fetchedResultsController = [BucketObject MR_fetchAllGroupedBy:nil
                                                                                withPredicate:predicate
                                                                                     sortedBy:[self.sortOptions objectAtIndex:(NSUInteger) self.selectedSort]
                                                                                    ascending:self.sortAscending];
    return fetchedResultsController;
}

- (void)_queryS3
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'";
    
    S3Manager *s3Manager = [S3Manager sharedInstance];

    [Bucket MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"name=%@",s3Manager.bucketName]];

    Bucket *bucket = [Bucket MR_createEntity];
    bucket.name = s3Manager.bucketName;

    __weak BucketViewController *weakSelf = self;
    [s3Manager getServiceWithSuccess:^(ONOXMLDocument *document) {

        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        for (ONOXMLElement *object in [document.rootElement childrenWithTag:@"Contents"])
        {
            NSLog(@"%@",object);
            BucketObject *bucketObject = [BucketObject MR_createEntity];
            bucketObject.bucket = bucket;

            ONOXMLElement *keyElement = [object firstChildWithTag:@"Key"];
            ONOXMLElement *lastModifiedElement = [object firstChildWithTag:@"LastModified"];
            ONOXMLElement *eTagElement = [object firstChildWithTag:@"ETag"];
            ONOXMLElement *sizeElement = [object firstChildWithTag:@"Size"];
            ONOXMLElement *ownerElement = [object firstChildWithTag:@"Owner"];
            ONOXMLElement *storageClassElement = [object firstChildWithTag:@"StorageClass"];

            bucketObject.key = [keyElement stringValue];
            NSString *lastModifiedDateString = [lastModifiedElement stringValue];
            bucketObject.lastModified = [formatter dateFromString:lastModifiedDateString];
            bucketObject.eTag = [eTagElement stringValue];
            bucketObject.size = [sizeElement numberValue];
            bucketObject.owner = [ownerElement stringValue];
            bucketObject.storageClass = [storageClassElement stringValue];
        }

        [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfWithCompletion:^(BOOL success, NSError *error) {
            weakSelf.fetchedResultsController = [weakSelf _fetchedResultsControllerForBucket:s3Manager.bucketName];
            [weakSelf.tableView reloadData];
        }];

    } failure:^(NSError *error) {

        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        NSString *localizedDescription = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"%@",error);

    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController.sections count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"BucketObjectCell";
    BucketObjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[BucketObjectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    BucketObject *bucketObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.bucketObject = bucketObject;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(BucketObjectTableViewCell*)sender
{
    UIViewController *destination = [segue destinationViewController];

    if ([destination isKindOfClass:[BucketObjectTableViewController class]])
    {
        ((BucketObjectTableViewController*)destination).bucketObject = sender.bucketObject;
    }
    else if([destination isKindOfClass:[UINavigationController class]])
    {
        UIViewController *rootVC = ((UINavigationController*)destination).topViewController;
        if([rootVC isKindOfClass:[SortsViewController class]])
        {
            SortsViewController* sortsVC = (SortsViewController *) rootVC;
            sortsVC.sortOptions = self.sortOptions;
            sortsVC.sortDisplayOptions = self.sortDisplayOptions;
            sortsVC.sortAscending = self.sortAscending;
            sortsVC.selectedSort = self.selectedSort;

            __weak BucketViewController *weakSelf = self;
            sortsVC.completion = ^(SortsViewController* sortsViewController){
                weakSelf.sortOptions = sortsViewController.sortOptions;
                weakSelf.sortDisplayOptions = sortsViewController.sortDisplayOptions;
                weakSelf.sortAscending = sortsViewController.sortAscending;
                weakSelf.selectedSort = sortsViewController.selectedSort;

                NSString *bucketName = [S3Manager sharedInstance].bucketName;
                weakSelf.fetchedResultsController = [weakSelf _fetchedResultsControllerForBucket:bucketName];
                [weakSelf.tableView reloadData];
            };
            [sortsVC.tableView reloadData];
        }
    }
}

@end
