//
//  Artist.m
//  SpotifyTracks
//
//  Created by Alex Gordillo on 8/3/12.
//  Copyright (c) 2012 Alex Gordillo. All rights reserved.
//

#import "Artist.h"

@implementation Artist

-(NSMutableArray *)tracksArray
{
	if (!_tracksArray)
	{
		_tracksArray = [[NSMutableArray alloc] init];
	}
	return _tracksArray;
}

-(NSString *)description
{
	NSString *string = [NSString stringWithFormat:@"Artist Name: %@ Track Names: %@", self.artistName, [self.tracksArray description]];
	return string;
}
@synthesize artistName = _artistName, tracksArray = _tracksArray;
@end
