//
//  CKATrack.h
//  SoundCloudFinal
//
//  Created by Christopher Kelley Anderson on 11/29/14.
//  Copyright (c) 2014 WSU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CKATrack : NSObject {
    NSDictionary *name;
}

@property (nonatomic, copy) NSDictionary *name;

+ (id) name:(NSDictionary*)name;

@end
