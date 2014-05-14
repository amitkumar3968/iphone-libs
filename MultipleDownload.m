//
//  MultipleDownload.m
//
//  Copyright 2008 Stepcase Limited.
//

#import "MultipleDownload.h"




@implementation MultipleDownload

@synthesize urls, requests, receivedDatas, finishCount;
@synthesize Oncompletion2;
@synthesize AssociatedDataArray;
@synthesize requestsArray;
- init {
    if ((self = [super init])) {
		self.finishCount = 0;
		NSMutableArray *array = [[NSMutableArray alloc] init];
		self.receivedDatas = array;
//		[array release];
        
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		self.requests = dict;
        self.requestsArray=[NSMutableArray new];
        
//		[dict release];
        
    }
    return self;
}


-(id)initWithBlock:(completionhandler2)theblock AndDataUrl:(NSArray *)thearray AndUrlArray:(NSArray *)urlArray{
    if ((self = [super init])) {
		self.finishCount = 0;
		NSMutableArray *array = [[NSMutableArray alloc] init];
		self.receivedDatas = array;
        
        
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		self.requests = dict;
        
        self.Oncompletion2=theblock;
        self.AssociatedDataArray=thearray;
           self.requestsArray=[NSMutableArray new];
        
        
        [self requestWithUrls:urlArray];
        
        
    }
    return self;
}


- (void)setDelegate:(id)val
{
    delegate = val;
}

- (id)delegate
{
    return delegate;
}


#pragma mark Methods
- (id)initWithUrls:(NSArray *)aUrls {
    if ((self = [self init]))
		[self requestWithUrls:aUrls];
	return self;
}

- (void)requestWithUrls:(NSArray *)aUrls {
    
	[receivedDatas removeAllObjects];
	[requests removeAllObjects];
    [requestsArray removeAllObjects];
//	[urls autorelease];
	urls = [aUrls copy];
    
	for(NSInteger i=0; i< [urls count]; i++){
		NSMutableData *aData = [[NSMutableData alloc] init];
		[receivedDatas addObject: aData];
//		[aData release];
        
		NSURLRequest *request = [[NSURLRequest alloc]
								 initWithURL: [NSURL URLWithString: [urls objectAtIndex:i]]
								 cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
								 timeoutInterval: 10
								 ];
		NSURLConnection *connection = [[NSURLConnection alloc]
									   initWithRequest:request
									   delegate:self];
        
		[requests setObject: [NSNumber numberWithInt: i] forKey: [NSValue valueWithNonretainedObject:connection]];
        
        [self.requestsArray addObject:connection];
        
//		[connection release];
//		[request release];
	}
}

- (NSData *)dataAtIndex:(NSInteger)idx {
	return [receivedDatas objectAtIndex:idx];
}

- (NSString *)dataAsStringAtIndex:(NSInteger)idx {
	return [[NSString alloc] initWithData:[receivedDatas objectAtIndex:idx] encoding:NSUTF8StringEncoding];
}

#pragma mark NSURLConnection Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSInteger i = [[requests objectForKey: [NSValue valueWithNonretainedObject:connection]] intValue];
    
    NSMutableData *tdata=(NSMutableData *)[receivedDatas objectAtIndex:i];
    [tdata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	NSInteger i = [[requests objectForKey: [NSValue valueWithNonretainedObject:connection]] intValue];
    [[receivedDatas objectAtIndex:i] appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSInteger i = [[requests objectForKey: [NSValue valueWithNonretainedObject:connection]] intValue];
	finishCount++;
     NSMutableData *tdata=(NSMutableData *)[receivedDatas objectAtIndex:i];
    
    NSLog(@"-----+++++++++%@",[[self.AssociatedDataArray objectAtIndex:i] objectForKey:@"filname"]);
     [tdata writeToFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]stringByAppendingFormat:@"/%@.mp3",[[self.AssociatedDataArray objectAtIndex:i] objectForKey:@"filname"]] atomically:YES];
    
    self.Oncompletion2(    [self.AssociatedDataArray objectAtIndex:i]);
    
    
//	if ([delegate respondsToSelector:@selector(didFinishDownload:)])
//        [delegate performSelector:@selector(didFinishDownload:) withObject: [NSNumber numberWithInt: i]];
//    
//	if(finishCount >= [urls count]){
//		if ([delegate respondsToSelector:@selector(didFinishAllDownload)])
//			[delegate didFinishAllDownload];
//	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	/*
    if ([delegate respondsToSelector:@selector(didFailDownloadWithError:)])
        [delegate performSelector:@selector(didFailDownloadWithError:) withObject: error];

     */
}


-(void)cancelAllrequests{
    
    NSLog(@"%@",self.requestsArray);
    for (NSURLConnection *Tconn in self.requestsArray) {
        
        [Tconn cancel];
    }
    
}
