//
//  HttpURLString.h
//  sample
//
//  Created by Jason on 15/6/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpURLString : NSObject

+ (NSString *)httpURLStringForCurrentWeatherWithCityName:(NSString *)cityName;
+ (NSString *)httpURLStringForDailyForecastWithCityName:(NSString *)cityName;

- (instancetype)initWithHost:(NSString *)host path:(NSString *)path;
- (NSString *)urlString;
- (NSString *)createQueryStringWithDict:(NSDictionary *)dict;

@end
