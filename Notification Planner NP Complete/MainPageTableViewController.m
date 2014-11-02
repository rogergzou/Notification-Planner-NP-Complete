//
//  MainPageTableViewController.m
//  Notification Planner NP Complete
//
//  Created by Roger on 11/2/14.
//  Copyright (c) 2014 Roger Zou. All rights reserved.
//

#import "MainPageTableViewController.h"
#import "scheduledNotif.h"
#import "CustomCell.h"

@interface MainPageTableViewController ()

@property (nonatomic, strong) NSArray *arrOfNotifs;

@end

@implementation MainPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSLog(@":/");
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"hi");
    self.arrOfNotifs = nil;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)myAddNotifSegueCallback:(UIStoryboardSegue *)segue
{
//    UIViewController *sourceVC = segue.sourceViewController;
    [self.tableView reloadData];
}*/

//lazy instn
- (NSArray *)arrOfNotifs
{
    if (!_arrOfNotifs) {
        NSMutableArray *holder = [NSMutableArray array];
        NSArray *store = [[NSUserDefaults standardUserDefaults] arrayForKey:@"notifArray"];
        if (!store || ![store count]) {
            _arrOfNotifs = [NSArray array];
        } else {
            for (NSData *data in store) {
                [holder addObject:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
                //gets scheduleNotifs
            }
            _arrOfNotifs = [NSArray arrayWithArray:holder];
        }
    }
    NSLog(@"%@", _arrOfNotifs);
    return _arrOfNotifs;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"%lu rows", (unsigned long)[self.arrOfNotifs count]);
    return [self.arrOfNotifs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if ([cell isKindOfClass:[CustomCell class]]) {
        CustomCell *custCell = (CustomCell *)cell;
        scheduledNotif *notif = self.arrOfNotifs[indexPath.row];
        custCell.notifLabel.text = notif.message;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
        
        //Optionally for time zone conversions
        [formatter setTimeZone:[NSTimeZone defaultTimeZone]];
        
        custCell.dateLabel.text = [formatter stringFromDate:notif.startDate];
        custCell.frequencyLabel.text = [self convertFrequencyToString: notif.frequencyInMins];
        return custCell;
    }
    // Configure the cell...
    
    return cell;
}

- (NSString *)convertFrequencyToString: (unsigned)mins {
    if (mins < 60)
        return [NSString stringWithFormat:@"Every %i minutes", mins];
    else if (mins < 180) {
        //int rem = (mins % 60) / 6; // * 10 / 60
        if (mins % 60)
            return [NSString stringWithFormat:@"Every %.1f hours", mins/60.0];
        else
            return (mins == 60) ? @"Every hour" : [NSString stringWithFormat:@"Every %i hours", mins/60];
    }
    else if (mins < 1440)
        return [NSString stringWithFormat:@"Every %i hours", mins/60];
    else if (mins == 2160)
        return [NSString stringWithFormat:@"Every 1.5 days"];
    else if (mins < 10080)
        return (mins == 1440) ? @"Every day" : [NSString stringWithFormat:@"Every %i days", mins/1440];
    else
        return (mins == 10080) ? @"Every week" : [NSString stringWithFormat:@"Every %i weeks", mins/10080];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
