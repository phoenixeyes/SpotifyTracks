//
//  Track.h
//  SpotifyTracks
//
//  Created by Alex Gordillo on 8/5/12.
//  Copyright (c) 2012 Alex Gordillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Track : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *albumName;
@end
