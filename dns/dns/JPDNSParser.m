//
//  JPDNSParser.m
//  dns
//
//  Created by Jasper on 15/5/28.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import "JPDNSParser.h"
#import "JPDNSCache.h"

const static NSString *DNSPOD_URL = @"http://119.29.29.29/d?dn=";

#define DNSPodURL(host) [NSString stringWithFormat:@"%@%@",DNSPOD_URL, host]

@implementation JPDNSParser

+ (NSString*) ipSynParseWithHost:(NSString*)host {
    if (!host) {
        return nil;
    }
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:DNSPodURL(host)]];
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:NULL];
    if (response.statusCode != 200) {
        return nil;
    }
    if (data && [data length] > 0) {
        NSString *ip = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        return ip;
    }
    return nil;
}


+ (void)ipAsynParseWithHost:(NSString*)host withComplete:(ParserFinish)finishHandler {
    if (!host) {
        if (finishHandler) {
            finishHandler(nil);
            return;
        }
    }
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:DNSPodURL(host)]];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *ip = nil;
        if (connectionError) {
            finishHandler(ip);
            return;
        }
        ip = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        finishHandler(ip);
    }];
}


+ (JPDNSParser*)shareParser {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    return instance;
}

- (void)setobject:(id)obj forKeyedSubscript:(NSString*)key {
    if (obj && [obj isKindOfClass:[NSString class]]
        && key && [key length] > 0) {
        [[JPDNSCache shareCache] saveIPToCache:(NSString*)obj withHost:key];
    }
}

- (id)objectForKeyedSubscript:(NSString*)key {
    __block NSString *host = (NSString*)key;
    NSString *ip = [[JPDNSCache shareCache] ipFromCache:host];
    if (ip) {
        return ip;
    } else {
        ///syn query ip
//        ip = [[self class] ipSynParseWithHost:host];
//        [[JPDNSCache shareCache] saveIPToCache:ip withHost:host];
//        return ip;
        ///asyn query ip
        [[self class] ipAsynParseWithHost:host withComplete:^(NSString *ip) {
            [[JPDNSCache shareCache] saveIPToCache:ip withHost:host];
        }];
        return nil;
    }
}
@end
