//
//  StopsViewController.m
//  UMBus
//
//  Created by Jonah Grant on 12/18/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopsViewController.h"
#import "StopsViewControllerModel.h"
#import "StopViewController.h"
#import "Stop.h"
#import "StopCell.h"
#import "StopCellModel.h"

@interface StopsViewController ()

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation StopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.model = [[StopsViewControllerModel alloc] init];
    
    self.navigationItem.title = @"University of Michigan";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self.model action:@selector(fetchData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [RACObserve(self.model, stops) subscribeNext:^(NSArray *stops) {
        if (stops) {
            if (self.refreshControl.isRefreshing) [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.stops.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Stops being serviced";
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.model.stops.count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoneCell" forIndexPath:indexPath];
        
        cell.textLabel.text = @"NO STOPS BEING SERVICED";
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        StopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        Stop *stop = self.model.stops[indexPath.row];
        StopCellModel *stopCellModel = [[StopCellModel alloc] initWithStop:stop];
        cell.model = stopCellModel;
        
        return cell;
    }
    
    return nil;
}

#pragma UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:UMSegueStop sender:self];
}

#pragma UIStoryboard

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:UMSegueStop]) {
        StopViewController *controller = (StopViewController *)segue.destinationViewController;
        Stop *stop = self.model.stops[[self.tableView indexPathForSelectedRow].row];
        controller.stop = stop;
    }
}

@end
