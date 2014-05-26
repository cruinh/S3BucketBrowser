//
//  AppDelegate.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/10/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityLogger.h"
#import "CoreData+MagicalRecord.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    [MagicalRecord setupCoreDataStack];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
}

@end
