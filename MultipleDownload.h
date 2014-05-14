typedef void (^completionhandler2)(NSDictionary *);

@interface MultipleDownload : NSObject {
	NSMutableArray *urls;
	NSMutableDictionary *requests;
    NSMutableArray *requestsArray;
	NSMutableArray *receivedDatas;
	NSInteger finishCount;
	id delegate;
}
@property(nonatomic,copy)completionhandler2 Oncompletion2;
@property(nonatomic,strong)NSArray *AssociatedDataArray;

@property (nonatomic,strong)    NSMutableArray *requestsArray;


@property (nonatomic,retain) NSMutableArray *urls;
@property (nonatomic,retain) NSMutableDictionary *requests;
@property (nonatomic,retain) NSMutableArray *receivedDatas;
@property NSInteger finishCount;
@property (retain) id delegate;

-(id)initWithBlock:(completionhandler2)theblock AndDataUrl:(NSArray *)thearray AndUrlArray:(NSArray *)urlArray;
- (id)initWithUrls:(NSArray *)aUrls;
- (void)requestWithUrls:(NSArray *)aUrls;
- (NSData *)dataAtIndex:(NSInteger)idx;
- (NSString *)dataAsStringAtIndex:(NSInteger)idx;
- (void)setDelegate:(id)val;
- (id)delegate;
-(void)cancelAllrequests;
@end
