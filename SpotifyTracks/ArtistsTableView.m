//
//  ViewController.m
//  SpotifyTracks
//
//  Created by Alex Gordillo on 8/2/12.
//  Copyright (c) 2012 Alex Gordillo. All rights reserved.
//

#import "ArtistsTableView.h"
#import "Artist.h"
#import	"Track.h"

#define kSearchString @"http://ws.spotify.com/search/1/track?q="

@interface ArtistsTableView ()

@end

@implementation ArtistsTableView

-(NSArray *)tracksSearchArray
{
	if (!_tracksSearchArray)
	{
		self.tracksSearchArray = [[NSArray alloc] initWithObjects:@"Metallica", nil];
	}
	return _tracksSearchArray;
}

-(NSMutableDictionary *)tracksDictionary
{
	if (!_tracksDictionary)
	{
		_tracksDictionary = [[NSMutableDictionary alloc] init];
	}
	return _tracksDictionary;
}

-(NSMutableData *)receivedData
{
	if (!_receivedData)
	{
		self.receivedData = [[NSMutableData alloc] init];
	}
	return _receivedData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	for (NSString *artist in self.tracksSearchArray)
	{
		NSString *artistSearchString = [kSearchString stringByAppendingString:artist];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:artistSearchString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
		NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
		
		if (connection)
		{
			self.receivedData = [NSMutableData data];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Data could not be retrieved" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
			[alert show];
		}
	}
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - NSURLConnectionData delegate methods

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSString *errorString = [NSString stringWithFormat:@"The URL: %@ produced the following error: %@", [[error userInfo] objectForKey:NSURLErrorFailingURLErrorKey], [error localizedDescription]];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:errorString delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
	[errorAlert show];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	self.receivedData.length = 0;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"Succeeded! Received %d bytes of data",[self.receivedData length]);
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.receivedData];
	parser.delegate = self;
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	[parser parse];
	
	[self.tableView reloadData];
}

#pragma mark - NSXMLParser Delegate methods

-(void)parserDidStartDocument:(NSXMLParser *)parser
{
	NSLog(@"Parser began parsing, %@", parser);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//	NSLog(@"elementName: %@", elementName);
	
	if ([elementName isEqualToString:@"track"])
	{
		self.currentAttribute = elementName;
		Track *newTrack = [[Track alloc] init];
		self.currentTrack = newTrack;
		return;
	}

	if ([elementName isEqualToString:@"artist"])
	{
		self.currentAttribute = elementName;
		return;
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//	NSLog(@"%@", self.charactersSoFar);
	NSString *smallerString = [self.charactersSoFar stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([elementName isEqualToString:@"track"])
	{
		if (![self.tracksDictionary objectForKey:self.currentTrack.artistName] )
		{
			[self.tracksDictionary setValue:[NSMutableArray arrayWithObject:self.currentTrack] forKey:self.currentTrack.artistName];
		}
		else
		{
			[[self.tracksDictionary objectForKey:self.currentTrack.artistName] addObject:self.currentTrack];
		}
	}
	
	if ([elementName isEqualToString:@"name"])
	{
		if ([self.currentAttribute isEqualToString:@"track"])
		{
			self.currentTrack.name = smallerString;
			return;
		}
		
		if ([self.currentAttribute isEqualToString:@"artist"])
		{
			self.currentTrack.artistName = smallerString;
			return;
		}
	}
	
	if ([elementName isEqualToString:@"artist"])
	{
		self.currentTrack.artistName = smallerString;
		return;
	}

	// Reset accumulated element characters once an element finished
	self.charactersSoFar = nil;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	// Keep track of characters so far
	if (!self.charactersSoFar)
	{
		self.charactersSoFar = [[NSMutableString alloc] init];
	}
	[self.charactersSoFar appendString:string];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	NSLog(@"Parser: %@, encountered an error: %@", parser, [parseError localizedDescription]);
}

-(void)parserDidEndDocument:(NSXMLParser *)parser
{
	NSLog(@"Parser finished parsing, %@", parser);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.tracksDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ArtistCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.textLabel.text = [[self.tracksDictionary allKeys] objectAtIndex:indexPath.row];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"artistTrackList"])
	{
		UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
		[[segue.destinationViewController valueForKey:@"tracksArray"] setArray:[self.tracksDictionary objectForKey:selectedCell.textLabel.text]];
	}
}

@synthesize tracksSearchArray = _tracksSearchArray, receivedData = _receivedData, charactersSoFar = _charactersSoFar, tracksDictionary = _tracksDictionary;
@synthesize currentAttribute = _currentAttribute;
@end
