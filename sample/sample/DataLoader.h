//
//  DataLoader.h
//  
//
//  Created by Jason on 15/6/23.
//
//

#import <Foundation/Foundation.h>

extern NSString * const DataErrorDomain;

@class Weather;
@class DailyForecast;

@interface DataLoader : NSObject

@property (nonatomic, copy) void (^completionHandler)(NSData *data, NSError *error);
@property (nonatomic, copy) NSString *urlString;

+ (instancetype)dataLoaderForCurrentWeatherWithCityName:(NSString *)cityName cachedDataHandler:(void (^)(Weather *cachedCurrentWeather))cachedDataHandler dataHandler:(void (^)(Weather *currentWeather, NSError *error))dataHandler;
+ (instancetype)dataLoaderForDailyForecastWithCityName:(NSString *)cityName cachedDataHandler:(void (^)(DailyForecast *cachedDailyForecast))cachedDataHandler dataHandler:(void (^)(DailyForecast *dailyForecast, NSError *error))dataHandler;

- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithURLString:(NSString *)urlString HTTPBody:(NSData *)httpBody;
- (void)startLoad;
- (void)cancelLoad;
- (NSData *)cachedData;

@end
