//
//  DailyForecast.m
//  sample
//
//  Created by Jason on 15/6/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "DailyForecast.h"
#import "Weather.h"

@interface DailyForecast ()

@property (strong, nonatomic) NSMutableArray *weatherArray;

@end

@implementation DailyForecast

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _weatherArray = [NSMutableArray array];
    }
    
    return self;
}

- (NSUInteger)count
{
    return [self.weatherArray count];
}

- (void)addWeather:(Weather *)weather
{
    if (!weather || ![weather isKindOfClass:[Weather class]])
    {
        return;
    }
    
    [self.weatherArray addObject:weather];
}

- (Weather *)weatherAtIndex:(NSUInteger)index
{
    if (index >= [self count])
    {
        return nil;
    }
    
    return [self.weatherArray objectAtIndex:index];
}

@end
