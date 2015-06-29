//
//  HttpURLString.m
//  sample
//
//  Created by Jason on 15/6/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "HttpURLString.h"
#import "HttpURLConstant.h"

@interface HttpURLString ()

@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSString *path;

@end

@implementation HttpURLString

+ (NSString *)httpURLStringForCurrentWeatherWithCityName:(NSString *)cityName
{
    HttpURLString *httpURLString = [[HttpURLString alloc] initWithHost:OpenWeatherMapHost path:CurrentWeatherPath];
    NSDictionary *dict = @{@"q":cityName};
    return [[httpURLString urlString] stringByAppendingString:[httpURLString createQueryStringWithDict:dict]];
}

+ (NSString *)httpURLStringForDailyForecastWithCityName:(NSString *)cityName
{
    HttpURLString *httpURLString = [[HttpURLString alloc] initWithHost:OpenWeatherMapHost path:DailyForecastPath];
    NSDictionary *dict = @{@"q":cityName, @"cnt":[NSNumber numberWithInteger:10]};
    return [[httpURLString urlString] stringByAppendingString:[httpURLString createQueryStringWithDict:dict]];
}

- (instancetype)initWithHost:(NSString *)host path:(NSString *)path
{
    self = [super init];
    
    if (self)
    {
        _host = host;
        _path = path;
    }
    
    return self;
}

- (NSString *)urlString
{
    if (self.path)
    {
        return [NSString stringWithFormat:@"http://%@%@", self.host, self.path];
    }
    else
    {
        return [NSString stringWithFormat:@"http://%@/", self.host];
    }
}

- (NSString *)createQueryStringWithDict:(NSDictionary *)dict
{
    NSEnumerator *enumerator = [dict keyEnumerator];
    id key;
    NSMutableString *string = [NSMutableString string];
    
    while ((key = [enumerator nextObject]))
    {
        if (0 == string.length)
        {
            [string appendString:[NSString stringWithFormat:@"?%@=%@", key, dict[key]]];
        }
        else
        {
            [string appendString:[NSString stringWithFormat:@"&%@=%@", key, dict[key]]];
        }
    }
    
    return string;
}

@end
