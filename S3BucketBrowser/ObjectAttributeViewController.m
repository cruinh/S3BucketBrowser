//
//  ObjectAttributeViewController.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "ObjectAttributeViewController.h"

#import "MBProgressHUD.h"
#import "S3ContentTypes.h"
#import "S3Manager.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ObjectAttributeViewController ()
@property CGFloat textViewYConstraintDefault;
@property BOOL hideStatusBar;
@property (nonatomic, strong) UITapGestureRecognizer *tapper;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapper;
@end

@implementation ObjectAttributeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.keyName;
    self.textView.text = self.value;
    self.textViewYConstraintDefault = self.textViewYConstraint.constant;
    
    [self _addLongTapGesture];
    [self _addDoubleTapper];
    [self _addTapper];

    [self _loadFile];
}

- (void)_addTapper
{
    self.tapper = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(_onImageTapped:)];
    [self.tapper requireGestureRecognizerToFail:self.doubleTapper];
    [self.scrollView addGestureRecognizer:self.tapper];
    [self.webView addGestureRecognizer:self.tapper];
}

- (void)_addDoubleTapper
{
    self.doubleTapper = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(_onImageDoubleTapped:)];
    self.doubleTapper.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:self.doubleTapper];
}

- (void)_onImageTapped:(UITapGestureRecognizer*)tapper
{
    [self _toggleNavBar];
}

- (void)_onImageDoubleTapped:(UITapGestureRecognizer *)tapper
{
    [self.scrollView setZoomScale:1.0f];
}

- (void)_loadFile
{
    if ([self.keyName isEqualToString:@"File"])
    {
        NSString *path = [NSString stringWithFormat:@"%@", self.value];

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [self _loadFileByCheckingMimeTypeForPath:path];
        return;
    }

    self.scrollViewHeightConstraint.constant = 0;
    self.webViewHeightConstraint.constant = 0;
}

- (void)_loadFileByCheckingMimeTypeForPath:(NSString *)path
{
    S3Manager *s3Manager = [S3Manager sharedInstance];
    __weak ObjectAttributeViewController *weakSelf = self;
    [s3Manager headObjectWithPath:path
                          success:^(NSHTTPURLResponse *response) {

                              NSLog(@"%@", response);
                              NSString *contentType = [[response allHeaderFields] objectForKey:@"Content-Type"];
                              [weakSelf _loadFileFromPath:path withMimeType:contentType];

                          } failure:^(NSError *error) {

        [weakSelf _handleS3AccessError:error];

    }];
}

- (void)_loadFileFromPath:(NSString*)path withMimeType:(NSString*)mimeType
{
    if ([[S3ContentTypes imageContentTypes] containsObject:mimeType])
    {
        [self _loadConfirmedImageFileFromPath:path];
    }
    else if ([[S3ContentTypes textContentTypes] containsObject:mimeType])
    {
        [self _loadConfirmedTextFileFromPath:path];
    }
    else if ([[S3ContentTypes webContentTypes] containsObject:mimeType])
    {
        [self _loadConfirmedWebFileFromPath:path];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Unsupported File Type"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];

        [alert show];
    }
}

- (void)_loadConfirmedTextFileFromPath:(NSString*)path
{
    S3Manager *s3Manager = [S3Manager sharedInstance];

    MBProgressHUD *hud = [[MBProgressHUD allHUDsForView:self.view] objectAtIndex:0];

    __weak ObjectAttributeViewController *weakSelf = self;
    [s3Manager getObjectWithPath:path
                        progress:^(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead) {

                            [hud setProgress:(float)(totalBytesRead/totalBytesExpectedToRead)];

                        } success:^(id responseObject, NSData *responseData) {

        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        NSString *content = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        weakSelf.textView.text = content;

        [weakSelf _showNavBar:YES];
        [weakSelf _setScrollViewHeightConstraint:0];
        [weakSelf _setWebViewHeightConstraint:0];

    } failure:^(NSError *error) {

        [weakSelf _handleS3AccessError:error];

    }];
}

- (void)_loadConfirmedWebFileFromPath:(NSString*)path
{
    S3Manager *s3Manager = [S3Manager sharedInstance];

    MBProgressHUD *hud = [[MBProgressHUD allHUDsForView:self.view] objectAtIndex:0];

    __weak ObjectAttributeViewController *weakSelf = self;
    [s3Manager getObjectWithPath:path
                        progress:^(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead) {

                            [hud setProgress:(float)(totalBytesRead/totalBytesExpectedToRead)];

                        } success:^(id responseObject, NSData *responseData) {

        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

        [weakSelf.webView loadData:responseData
                          MIMEType:@"text/html"
                  textEncodingName:@"utf-8"
                           baseURL:nil];

        [weakSelf _showNavBar:YES];
        [weakSelf _setScrollViewHeightConstraint:0];
        [weakSelf _setWebViewHeightConstraint:weakSelf.view.bounds.size.height - 64];

    } failure:^(NSError *error) {

        [weakSelf _handleS3AccessError:error];

    }];
}

- (void)_loadConfirmedImageFileFromPath:(NSString*)path
{
    S3Manager *s3Manager = [S3Manager sharedInstance];

    MBProgressHUD *hud = [[MBProgressHUD allHUDsForView:self.view] objectAtIndex:0];

    __weak ObjectAttributeViewController *weakSelf = self;
    [s3Manager getObjectWithPath:path
                        progress:^(NSUInteger bytesRead, long long int totalBytesRead, long long int totalBytesExpectedToRead) {

                            [hud setProgress:(float)(totalBytesRead/totalBytesExpectedToRead)];

                        } success:^(id responseObject, NSData *responseData) {

                            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                            UIImage *image = [UIImage imageWithData:responseData];
                            weakSelf.imageView.image = image;
                            weakSelf.imageView.frame = CGRectMake(0,0,image.size.width,image.size.height);
                            weakSelf.scrollView.contentSize = weakSelf.imageView.image.size;
                            
                            [weakSelf _showNavBar:NO];
                            [weakSelf _setScrollViewHeightConstraint:self.view.bounds.size.height-64];
                            [weakSelf _setWebViewHeightConstraint:0];
                            
                        } failure:^(NSError *error) {
                            
                            [weakSelf _handleS3AccessError:error];
                            
                        }];
}

- (void)_handleS3AccessError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSString *localizedDescription = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:localizedDescription
                                                   delegate:nil
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];

    [alert show];
    NSLog(@"%@", error);
}

- (void)_toggleNavBar
{
    self.hideStatusBar = !self.hideStatusBar;
    [self _showNavBar:self.hideStatusBar];

}

- (void)_showNavBar:(BOOL)state
{
//    [self.navigationController setNavigationBarHidden:!state animated:YES];
//    [self setNeedsStatusBarAppearanceUpdate];
//
//    if (!state)
//        [self _setTextViewYConstraint:0];
//    else
//        [self _setTextViewYConstraint:self.textViewYConstraintDefault];
}

- (void)_setWebViewHeightConstraint:(CGFloat)value
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0
                     animations:^{
                         self.webViewHeightConstraint.constant = value;
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (void)_setScrollViewHeightConstraint:(CGFloat)value
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0
                     animations:^{
                         self.scrollViewHeightConstraint.constant = value;
                         [self.view layoutIfNeeded]; // Called on parent view
                     }];
}

- (void)_setTextViewYConstraint:(CGFloat)value
{
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0
                         animations:^{
                             self.textViewYConstraint.constant = value;
                             [self.view layoutIfNeeded]; // Called on parent view
                         }];
}

- (BOOL)prefersStatusBarHidden {
    return self.hideStatusBar;
}

- (void)_addLongTapGesture
{
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                             action:@selector(_onTextViewLongPress:)];
    [self.textView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)_onTextViewLongPress:(UILongPressGestureRecognizer*)gestureRecognizer
{
    [self.textView selectAll:self];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)viewDidLayoutSubviews
{
    [self.scrollView setContentSize:self.imageView.image.size];
}

@end
