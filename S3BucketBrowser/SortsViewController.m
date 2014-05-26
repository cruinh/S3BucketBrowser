//
//  SortsViewController.m
//  S3BucketBrowser
//
//  Created by cruinh on 5/11/14.
//  Copyright (c) 2014 Matthew Hayes. All rights reserved.
//

#import "SortsViewController.h"

@interface SortsViewController ()

@end

@implementation SortsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(_onDismissButtonTapped:)];
    self.navigationItem.leftBarButtonItem = closeButton;

}

- (void)_onDismissButtonTapped:(id)sender
{
    self.completion(self);
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
        default:
            return [self.sortOptions count];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Direction";
        default:
            return @"Field";
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"SortOptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                cell.textLabel.text = @"Ascending";

                if (self.sortAscending)
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                else
                    cell.accessoryType = UITableViewCellAccessoryNone;
            }
            break;
            default:
            {
                cell.textLabel.text = @"Descending";

                if (!self.sortAscending)
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                else
                    cell.accessoryType = UITableViewCellAccessoryNone;
            }
                break;
        }
    }
    else
    {
        cell.textLabel.text = [self.sortDisplayOptions objectAtIndex:(NSUInteger) indexPath.row];
        
        if (indexPath.row==self.selectedSort)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        self.sortAscending = !self.sortAscending;
    }
    else
    {
        self.selectedSort = indexPath.row;
    }

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:(NSUInteger) indexPath.section]
                                                withRowAnimation:UITableViewRowAnimationFade];
}


@end
