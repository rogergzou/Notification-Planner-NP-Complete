//
//  notifViewController.m
//  Notification Planner NP Complete
//
//  Created by Aidi Zhang on 11/2/14.
//  Copyright (c) 2014 Roger Zou. All rights reserved.
//

#import "notifViewController.h"
#import "scheduledNotif.h"

@interface notifViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *scheduledNotifArray;
@end

@implementation notifViewController
@synthesize myTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.scheduledNotifArray = [[NSArray alloc] initWithObjects:[[scheduledNotif alloc] init],nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView Delegate/DataSource
ount];
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.scheduledNotifArray c
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    // retrieves cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] init];
    }
    return cell;
}

// End of UITableView

@end
