//
//  scheduledNotif.m
//  Notification Planner NP Complete
//
//  Created by Aidi Zhang on 11/2/14.
//  Copyright (c) 2014 Roger Zou. All rights reserved.
//

#import "scheduledNotif.h"

@implementation scheduledNotif

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //encode everything
    [encoder encodeObject:self.message forKey:@"title"];
    [encoder encodeObject:self.startDate forKey:@"image"];
    [encoder encodeInt:self.frequencyInMins forKey:@"freq"];
    [encoder encodeInt:self.occurences forKey:@"occ"];
    [encoder encodeObject:self.endDate forKey:@"end"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        //decode everything
        self.message = [decoder decodeObjectForKey:@"title"];
        self.startDate = [decoder decodeObjectForKey:@"image"];
        self.endDate = [decoder decodeObjectForKey:@"end"];
        self.frequencyInMins = [decoder decodeIntForKey:@"freq"];
        self.occurences = [decoder decodeIntForKey:@"occ"];
    }
    return self;
}

@end
