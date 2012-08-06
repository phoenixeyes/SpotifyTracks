//
//  Artist.h
//  SpotifyTracks
//
//  Created by Alex Gordillo on 8/3/12.
//  Copyright (c) 2012 Alex Gordillo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artist : NSObject

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSMutableArray *tracksArray;
@end
