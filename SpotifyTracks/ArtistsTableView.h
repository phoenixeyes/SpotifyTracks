//
//  ViewController.h
//  SpotifyTracks
//
//  Created by Alex Gordillo on 8/2/12.
//  Copyright (c) 2012 Alex Gordillo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Track;

@interface ArtistsTableView : UITableViewController <NSURLConnectionDataDelegate, NSXMLParserDelegate>

@property (nonatomic, strong) NSArray *tracksSearchArray;
@property (nonatomic, strong) NSMutableDictionary *tracksDictionary;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSMutableString *charactersSoFar;
@property (nonatomic, strong) NSString *currentAttribute;
@property (nonatomic, strong) Track *currentTrack;
@end
