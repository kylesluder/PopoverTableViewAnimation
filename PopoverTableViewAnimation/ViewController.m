//
//  ViewController.m
//  PopoverTableViewAnimation
//
//  Created by Kyle Sluder on 9/11/14.
//  Copyright (c) 2014 The Omni Group. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>

@interface ViewController () <UINavigationControllerDelegate>

- (IBAction)toggleUseWorkaround:(id)sender;

@end

static BOOL UseWorkaround;

@implementation ViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    if ([segue.identifier isEqualToString:@"popover"]) {
        UINavigationController *navCon = (UINavigationController *)segue.destinationViewController;
        navCon.delegate = self;
    }
    
    [super prepareForSegue:segue sender:sender];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    navigationController.preferredContentSize = viewController.preferredContentSize;
}

- (void)toggleUseWorkaround:(id)sender;
{
    UseWorkaround = ((UISwitch *)sender).on;
}

@end

@implementation TableViewController

- (void)viewDidLoad;
{
    if (_numberOfRows == 0)
        _numberOfRows = 1;
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;
{
    if ([segue.identifier isEqualToString:@"push"]) {
        TableViewController *tvc = (TableViewController *)segue.destinationViewController;
        tvc.numberOfRows = _numberOfRows + 1;
    }
    
    [super prepareForSegue:segue sender:sender];
}

- (void)viewWillAppear:(BOOL)animated;
{
    [self.tableView reloadData];
    self.preferredContentSize = (CGSize){.width = 300, .height = [self.tableView rectForSection:0].size.height};
    [super viewWillAppear:animated];
}

@end

@interface NoAnimationsTableView : UITableView
@end

@implementation NoAnimationsTableView

- (void)setFrame:(CGRect)frame;
{
    if (UseWorkaround) {
        [UIView performWithoutAnimation:^{
            [super setFrame:frame];
        }];
    } else {
        [super setFrame:frame];
    }
}

@end
