//
//  TrackTableViewViewController.m
//  SpotifyTracks
//
//  Created by Alex Gordillo on 8/2/12.
//  Copyright (c) 2012 Alex Gordillo. All rights reserved.
//

#import "TrackTableViewController.h"

@interface TrackTableViewController ()

@end

@implementation TrackTableViewController

-(NSArray *)tracksArray
{
	if (!_tracksArray)
	{
		_tracksArray = [[NSMutableArray alloc] init];
	}
	return _tracksArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tracksArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TrackCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[self.tracksArray objectAtIndex:indexPath.row] valueForKey:@"name"];
    
    return cell;
}

@synthesize tracksArray = _tracksArray;
@end
