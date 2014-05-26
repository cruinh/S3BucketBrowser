//
//  BucketConfigurationViewController.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "BucketConfigurationViewController.h"

#import "BucketViewController.h"
#import "S3Manager.h"

@interface BucketConfigurationViewController ()
@property (nonatomic, weak) IBOutlet UITextField *bucketNameField;
@property (nonatomic, weak) IBOutlet UITextField *accessKeyField;
@property (nonatomic, weak) IBOutlet UITextField *secretField;
@end

#define BUCKET_NAME @"BUCKET_NAME"
#define ACCESS_KEY @"ACCESS_KEY"
#define ACCESS_SECRET @"ACCESS_SECRET"

@implementation BucketConfigurationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"S3 Bucket Access Configuration";

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    self.bucketNameField.text = [userDefaults objectForKey:BUCKET_NAME];
    self.accessKeyField.text = [userDefaults objectForKey:ACCESS_KEY];
    self.secretField.text = [userDefaults objectForKey:ACCESS_SECRET];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    S3Manager *s3Manager = [S3Manager createSharedInstanceWithAccessKeyID:self.accessKeyField.text
                                                                andSecret:self.secretField.text];
    s3Manager.bucketName = self.bucketNameField.text;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.bucketNameField.text forKey:BUCKET_NAME];
    [userDefaults setObject:self.accessKeyField.text forKey:ACCESS_KEY];
    [userDefaults setObject:self.secretField.text forKey:ACCESS_SECRET];
    [userDefaults synchronize];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSegueWithIdentifier:@"ConfigurationToBucketViewSegue" sender:self];
    return NO;
}

@end
