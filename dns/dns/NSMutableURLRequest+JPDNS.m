//
//  NSMutableURLRequest+JPDNS.m
//  dns
//
//  Created by Jasper on 15/5/28.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import "NSMutableURLRequest+JPDNS.h"
#import <objc/runtime.h>
#import "JPDNSParser.h"

@implementation NSMutableURLRequest (JPDNS)

//+ (void)load {
//    Method ori_Method = class_getInstanceMethod([NSMutableURLRequest class], @selector(initWithURL:cachePolicy:timeoutInterval:));
//    Method my_Method = class_getInstanceMethod([NSMutableURLRequest class], @selector(JPDNS_initWithURL:cachePolicy:timeoutInterval:));
//    method_exchangeImplementations(ori_Method, my_Method);
//}

- (instancetype)JPDNS_initWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval {
    NSString *ip = [JPDNSParser shareParser][URL.host];
    NSString *urlString = [URL absoluteString];
    if (ip) {
        [urlString stringByReplacingOccurrencesOfString:URL.host withString:ip];
    }
    
    NSURL *targetURL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:targetURL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
    if (ip) {
        [req addValue:URL.host forHTTPHeaderField:@"Host"];
    }
    return req;
}

+ (instancetype)JPDNS_requestWithURL:(NSURL *)URL cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval {
    return [[NSMutableURLRequest alloc]JPDNS_initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
}

+ (instancetype)JPDNS_requestWithURL:(NSURL *)URL {
    return [[NSMutableURLRequest alloc]JPDNS_initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0f];
}

@end
