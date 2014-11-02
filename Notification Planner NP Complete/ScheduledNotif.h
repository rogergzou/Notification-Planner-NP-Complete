//
//  ScheduledNotif.h
//  Notification Planner NP Complete
//
//  Created by Roger on 11/2/14.
//  Copyright (c) 2014 Roger Zou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduledNotif : NSObject

@property (nonatomic) unsigned long occurences;
@property (nonatomic) unsigned long frequency;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end
