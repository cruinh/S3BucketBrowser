//
//  ObjectAttributeViewController.h
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectAttributeViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) NSString *keyName;
@property (nonatomic, strong) NSString *value;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *textViewYConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *webViewHeightConstraint;

@end
