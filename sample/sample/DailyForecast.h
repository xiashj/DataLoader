//
//  DailyForecast.h
//  sample
//
//  Created by Jason on 15/6/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Weather;

@interface DailyForecast : NSObject

- (NSUInteger)count;
- (void)addWeather:(Weather *)weather;
- (Weather *)weatherAtIndex:(NSUInteger)index;

@end
