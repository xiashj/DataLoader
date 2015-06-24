//
//  DataLoader.h
//  
//
//  Created by Jason on 15/6/23.
//
//

#import <Foundation/Foundation.h>

@interface DataLoader : NSObject

@property (nonatomic, copy) void (^completionHandler)(NSData *data, NSError *error);
@property (nonatomic, copy) NSString *urlString;

- (instancetype)initWithURLString:(NSString *)urlString;
- (instancetype)initWithURLString:(NSString *)urlString HTTPBody:(NSData *)httpBody;
- (void)startLoad;
- (void)cancelLoad;
- (NSData *)cachedData;

@end
