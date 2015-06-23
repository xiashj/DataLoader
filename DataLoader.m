//
//  DataLoader.m
//  
//
//  Created by Jason on 15/6/23.
//
//

#import "DataLoader.h"

@interface DataLoader ()

@property (nonatomic, strong) NSMutableData *activeLoad;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSString *HTTPMethod;
@property (nonatomic, strong) NSData *HTTPBody;

@end

@implementation DataLoader

- (instancetype)initWithURLString:(NSString *)urlString
{
    self = [super init];
    
    if (self)
    {
        _urlString = urlString;
    }
    
    return self;
}

- (instancetype)initWithURLString:(NSString *)urlString HTTPBody:(NSData *)httpBody
{
    self = [super init];
    
    if (self)
    {
        _urlString = urlString;
        _HTTPBody = httpBody;
    }
    
    return self;
}

- (void)startLoad
{
    [self cancelLoad];
    self.activeLoad = [NSMutableData data];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [request setValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    
    if (self.HTTPMethod)
    {
        [request setHTTPMethod:self.HTTPMethod];
    }
    
    if (self.HTTPBody)
    {
        request.HTTPBody = self.HTTPBody;
        [request setHTTPMethod:@"POST"];
    }
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)cancelLoad
{
    [self.connection cancel];
    self.connection = nil;
    self.activeLoad = nil;
}

- (NSData *)cachedData
{
    NSURLCache *sharedURLCache = [NSURLCache sharedURLCache];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    NSCachedURLResponse *cachedURLResponse = [sharedURLCache cachedResponseForRequest:request];
    
    if (cachedURLResponse)
    {
        return [cachedURLResponse data];
    }
    
    return nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeLoad appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.activeLoad = nil;
    self.connection = nil;
    
    if (self.completionHandler)
    {
        self.completionHandler(nil, error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.connection = nil;
    
    if (self.completionHandler)
    {
        self.completionHandler(self.activeLoad, nil);
    }
    
    self.activeLoad = nil;
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

@end
