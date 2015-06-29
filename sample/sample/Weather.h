//
//  Weather.h
//  sample
//
//  Created by Jason on 15/6/24.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (strong, nonatomic) NSNumber *weatherId;
@property (strong, nonatomic) NSString *main;
@property (strong, nonatomic) NSString *weatherDescription;
@property (strong, nonatomic) NSString *icon;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
