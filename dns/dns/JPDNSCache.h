//
//  JPDNSCache.h
//  dns
//
//  Created by Jasper on 15/5/29.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPDNSCache : NSObject

+ (JPDNSCache*)shareCache;

- (NSString*)ipFromCache:(NSString*)host;
- (void)saveIPToCache:(NSString*)ip withHost:(NSString*)host;
///ip is nil -》delete all ips
- (void)delHost:(NSString*)host withIP:(NSString*)ip;

@end
