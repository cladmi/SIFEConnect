- (NSString *)stringWithUrl:(NSURL *)url
{
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                    timeoutInterval:30];
    	// Fetch the JSON response
	NSData *urlData;
	NSURLResponse *response;
	NSError *error;
 
	// Make synchronous request
	urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                        returningResponse:&amp;response
                                                    error:&amp;error];
 
 	// Construct a String around the Data from the response
	return [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
}

- (id) objectWithUrl:(NSURL *)url
{
	SBJSON *jsonParser = [SBJSON new];
	NSString *jsonString = [self stringWithUrl:url];
 
	// Parse the JSON into an Object
	return [jsonParser objectWithString:jsonString error:NULL];
}


/*
{
    "title" : "Jaiku | Latest Public Jaikus",
    "url": "http:\/\/jaiku.com",
    "stream": [
        {
        "id": "47163562",
        "title": "Lol....nope",
        "content": "",
        "icon": "http:\/\/jaiku.com\/images\/icons\/jaiku-sms.gif",
        "url": "http:\/\/vicious00013.jaiku.com\/presence\/47163562",
        "created_at": "2008-10-20T18:22:50 GMT",
        "created_at_relative": "1 minute ago",
        "comments": "0",
        "user":
            {
            "avatar": "http:\/\/jaiku.com\/image\/4\/avatar_52304_t.jpg",
            "first_name": "Ronnie",
            "last_name": "Beckett",
            "nick": "vicious00013",
            "url": "http:\/\/vicious00013.jaiku.com"
            }
        },
        {
        "id": "47163407",
        "title": "Nice, so HP refuses to (or can't) sell us the drive carriers for their servers.",
        "content": "",
        "icon": "",
        "url": "http:\/\/randomfrequency.jaiku.com\/presence\/47163407",
        "created_at": "2008-10-20T18:21:16 GMT",
        "created_at_relative": "3 minutes ago",
        "comments": "3",
        "user":
            {
            "avatar": "http:\/\/jaiku.com\/image\/36\/avatar_47586_t.jpg",
            "first_name": "Vincent",
            "last_name": "Janelle",
            "nick": "randomfrequency",
            "url": "http:\/\/randomfrequency.jaiku.com"
            }
        }   ]
}
*/

- (NSDictionary *) downloadPublicJaikuFeed 
{
	id response = [self objectWithUrl:[NSURL URLWithString:@"http://jaiku.com/feed/json"]];
 
	NSDictionary *feed = (NSDictionary *)response;
	return feed;
}


NSDictionary *feed = [self downloadPublicJaikuFeed];
NSLog(@"Here is the title of the feed: %@", [feed valueForKey:@"title"]);



NSDictionary *feed = [self downloadPublicJaikuFeed];
 
// get the array of "stream" from the feed and cast to NSArray
NSArray *streams = (NSArray *)[feed valueForKey:@"stream"];
 
// loop over all the stream objects and print their titles
int ndx;
NSDictionary *stream;
for (ndx = 0; ndx &lt; stream.count; ndx++) {
	NSDictionary *stream = (NSDictionary *)[streams objectAtIndex:ndx];
	NSLog(@"This is the title of a stream: %@", [stream valueForKey:@"title"]); 
}


