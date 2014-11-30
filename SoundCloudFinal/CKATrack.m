//
//  CKATrack.m
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/29/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import "CKATrack.h"

@implementation CKATrack
@synthesize name;

+ (id) name:(NSDictionary *)name
{
    CKATrack *newTrack = [[self alloc] init];
    newTrack.name = name;
    return newTrack;
}

@end
