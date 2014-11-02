//
//  scheduledNotif.h
//  Notification Planner NP Complete
//
//  Created by Aidi Zhang on 11/2/14.
//  Copyright (c) 2014 Roger Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// This declares myCustomCell to be an NSObject; table view cells are not NSObjects
// This is MODEL in MVC framework
@interface scheduledNotif: NSObject
@property (weak, nonatomic) NSString *notifToBeSent;
@property (weak, nonatomic) NSDate *dateSent;
@property (nonatomic) int *frequencyInMins;
@property (nonatomic) bool *notifDeleted;

@end
