//
//  Weather.m
//  sample
//
//  Created by Jason on 15/6/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "Weather.h"

@implementation Weather

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        if (dict && [dict isKindOfClass:[NSDictionary class]])
        {
            id weatherId = dict[@"id"];
            
            if (weatherId && [weatherId isKindOfClass:[NSNumber class]])
            {
                _weatherId = weatherId;
            }
            
            id main = dict[@"main"];
            
            if (main && [main isKindOfClass:[NSString class]])
            {
                _main = main;
            }
            
            id weatherDescription = dict[@"description"];
            
            if (weatherDescription && [weatherDescription isKindOfClass:[NSString class]])
            {
                _weatherDescription = weatherDescription;
            }
            
            id icon = dict[@"icon"];
            
            if (icon && [icon isKindOfClass:[NSString class]])
            {
                _icon = icon;
            }
        }
    }
    
    return self;
}

@end
