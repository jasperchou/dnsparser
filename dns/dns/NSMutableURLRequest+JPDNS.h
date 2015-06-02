//
//  NSMutableURLRequest+JPDNS.h
//  dns
//
//  Created by Jasper on 15/5/28.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (JPDNS)

- (instancetype)JPDNS_initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval;

+ (instancetype)JPDNS_requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval;

+ (instancetype)JPDNS_requestWithURL:(NSURL *)URL;

@end
