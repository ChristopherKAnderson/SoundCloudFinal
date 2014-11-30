//
//  CKATrack1.h
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/30/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKATrack1 : NSDictionary {
    NSDictionary *name;
}

@property (nonatomic, copy) NSDictionary *name;

+ (id) name:(NSDictionary*)name;

@end
