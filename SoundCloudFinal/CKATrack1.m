//
//  CKATrack1.m
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/30/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import "CKATrack1.h"

@implementation CKATrack1
@synthesize name;

+ (id) name:(NSDictionary *)name
{
    CKATrack1 *newTrack = [[self alloc] init];
    newTrack.name = name;
    return newTrack;
}

@end
