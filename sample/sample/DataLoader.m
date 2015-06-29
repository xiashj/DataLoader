//
//  DataLoader.m
//  
//
//  Created by Jason on 15/6/23.
//
//

#import "DataLoader.h"
#import "Weather.h"
#import "DailyForecast.h"
#import "HttpURLString.h"

NSString * const DataErrorDomain = @"DataErrorDomain";

#pragma mark - Current weather data loader

@interface CurrentWeatherDataLoader : DataLoader

@property (nonatomic, copy) void (^cachedDataHandler)(Weather *cachedCurrentWeather);
@property (nonatomic, copy) void (^dataHandler)(Weather *currentWeather, NSError *error);

- (Weather *)convertData:(NSData *)data dataError:(NSError *__autoreleasing *)dataError;

@end

@implementation CurrentWeatherDataLoader

- (Weather *)convertData:(NSData *)data dataError:(NSError *__autoreleasing *)dataError
{
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    if (!dict)
    {
        *dataError = error;
        return nil;
    }

    if (![dict isKindOfClass:[NSDictionary class]])
    {
        *dataError = [[NSError alloc] initWithDomain:DataErrorDomain code:0 userInfo:nil];
        return nil;
    }
    
    NSArray *weatherArray = dict[@"weather"];
    
    if (!weatherArray || ![weatherArray isKindOfClass:[NSArray class]] || [weatherArray count] == 0)
    {
        *dataError = [[NSError alloc] initWithDomain:DataErrorDomain code:0 userInfo:nil];
        return nil;
    }
    
    NSDictionary *weatherDict = weatherArray[0];
    
    if (!weatherDict || ![weatherDict isKindOfClass:[NSDictionary class]])
    {
        *dataError = [[NSError alloc] initWithDomain:DataErrorDomain code:0 userInfo:nil];
        return nil;
    }
    
    return [[Weather alloc] initWithDict:weatherDict];
}

@end

#pragma mark - Daily forecast data loader

@interface DailyForecastDataLoader : DataLoader

@property (nonatomic, copy) void (^cachedDataHandler)(DailyForecast *dailyForecast);
@property (nonatomic, copy) void (^dataHandler)(DailyForecast *dailyForecast, NSError *error);

- (DailyForecast *)convertData:(NSData *)data dataError:(NSError *__autoreleasing *)dataError;

@end

@implementation DailyForecastDataLoader

- (DailyForecast *)convertData:(NSData *)data dataError:(NSError *__autoreleasing *)dataError
{
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (!dict)
    {
        *dataError = error;
        return nil;
    }
    
    if (![dict isKindOfClass:[NSDictionary class]])
    {
        *dataError = [[NSError alloc] initWithDomain:DataErrorDomain code:0 userInfo:nil];
        return nil;
    }

    NSArray *listArray = dict[@"list"];
    
    if (!listArray || ![listArray isKindOfClass:[NSArray class]])
    {
        *dataError = [[NSError alloc] initWithDomain:DataErrorDomain code:0 userInfo:nil];
        return nil;
    }
    
    DailyForecast *dailyForecast = [[DailyForecast alloc] init];
    
    for (NSDictionary *dailyForecastDict in listArray)
    {
        if (![dailyForecastDict isKindOfClass:[NSDictionary class]])
        {
            break;
        }
        
        NSArray *weatherArray = dailyForecastDict[@"weather"];
        
        if (!weatherArray || ![weatherArray isKindOfClass:[NSArray class]] || [weatherArray count] == 0)
        {
            break;
        }
        
        NSDictionary *weatherDict = weatherArray[0];
        
        if (!weatherDict || ![weatherDict isKindOfClass:[NSDictionary class]])
        {
            break;
        }
        
        Weather *weather = [[Weather alloc] initWithDict:weatherDict];
        [dailyForecast addWeather:weather];
    }
    
    return dailyForecast;
}

@end

@interface DataLoader ()

@property (nonatomic, strong) NSMutableData *activeLoad;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSString *HTTPMethod;
@property (nonatomic, strong) NSData *HTTPBody;

@end

@implementation DataLoader

+ (instancetype)dataLoaderForCurrentWeatherWithCityName:(NSString *)cityName cachedDataHandler:(void (^)(Weather *cachedCurrentWeather))cachedDataHandler dataHandler:(void (^)(Weather *currentWeather, NSError *error))dataHandler
{
    NSString *httpURLString = [HttpURLString httpURLStringForCurrentWeatherWithCityName:cityName];
    CurrentWeatherDataLoader *dataLoader = [[CurrentWeatherDataLoader alloc] initWithURLString:httpURLString];
    
    if (dataLoader)
    {
        dataLoader.dataHandler = dataHandler;

        NSData *cachedData = [dataLoader cachedData];
        Weather *cachedCurrentWeather;

        if (cachedData)
        {
            NSError *dataError;
            cachedCurrentWeather = [dataLoader convertData:cachedData dataError:&dataError];
        }
        
        if (cachedDataHandler)
        {
            cachedDataHandler(cachedCurrentWeather);
        }
        
        __weak CurrentWeatherDataLoader *weakDataLoader = dataLoader;
        dataLoader.completionHandler = ^(NSData *data, NSError *error) {
            if (data)
            {
                NSError *dataError;
                Weather *currentWeather = [weakDataLoader convertData:data dataError:&dataError];
                weakDataLoader.dataHandler(currentWeather, dataError);
            }
            else
            {
                weakDataLoader.dataHandler(nil, error);
            }
        };
    }
    
    return dataLoader;
}

+ (instancetype)dataLoaderForDailyForecastWithCityName:(NSString *)cityName cachedDataHandler:(void (^)(DailyForecast *cachedDailyForecast))cachedDataHandler dataHandler:(void (^)(DailyForecast *dailyForecast, NSError *error))dataHandler
{
    NSString *httpURLString = [HttpURLString httpURLStringForDailyForecastWithCityName:cityName];
    DailyForecastDataLoader *dataLoader = [[DailyForecastDataLoader alloc] initWithURLString:httpURLString];
    
    if (dataLoader)
    {
        dataLoader.dataHandler = dataHandler;
        
        NSData *cachedData = [dataLoader cachedData];
        DailyForecast *cachedDailyForecast;
        
        if (cachedData)
        {
            NSError *dataError;
            cachedDailyForecast = [dataLoader convertData:cachedData dataError:&dataError];
        }
        
        if (cachedDataHandler)
        {
            cachedDataHandler(cachedDailyForecast);
        }
        
        __weak DailyForecastDataLoader *weakDataLoader = dataLoader;
        dataLoader.completionHandler = ^(NSData *data, NSError *error) {
            if (data)
            {
                NSError *dataError;
                DailyForecast *dailyForecast = [weakDataLoader convertData:data dataError:&dataError];
                weakDataLoader.dataHandler(dailyForecast, dataError);
            }
            else
            {
                weakDataLoader.dataHandler(nil, error);
            }
        };
    }
    
    return dataLoader;
    
}

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
