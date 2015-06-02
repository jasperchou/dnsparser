//
//  JPDNSCache.m
//  dns
//
//  Created by Jasper on 15/5/29.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import "JPDNSCache.h"
@interface JPDNSCache()

@property (nonatomic, strong) NSMutableArray   *dnsTable;
@property (nonatomic, strong) NSMutableDictionary   *quickDnsTable;

@end

@implementation JPDNSCache

+ (JPDNSCache*)shareCache {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [JPDNSCache new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dnsTable = [self defaultDnsTable];
        _quickDnsTable = [NSMutableDictionary new];
    }
    return self;
}

- (void)saveToDocument:(NSArray*)arr
{
    if (arr) {
        NSString *home = NSHomeDirectory();
        NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
        NSString *path = [docPath stringByAppendingPathComponent:@"dns_table.plist"];
        [arr writeToFile:path atomically:YES];
    }
}

- (NSArray*)readFromDocument {
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filepath = [docPath stringByAppendingPathComponent:@"dns_table.plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:filepath];
    
    if (!arr) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dns" ofType:@"plist"];
        arr = [NSArray arrayWithContentsOfFile:path];
        if (arr) {
            [self saveToDocument:arr];
        }
    }
    return arr;
}

- (NSMutableArray*)defaultDnsTable {
    NSArray *arr = [self readFromDocument];
    if (arr) {
        return [NSMutableArray arrayWithArray:arr];
    } else {
        return [NSMutableArray new];
    }
}

- (NSString*)ipFromCache:(NSString*)host {
    //find from quick dnstable
    @synchronized(self) {
        NSString *ip = [self.quickDnsTable objectForKey:host];
        if (ip) {
            return ip;
        } else {
            //find from file dnstable
            for (NSDictionary *dns in self.dnsTable) {
                NSArray *ips = [dns objectForKey:host];
                if (ips) {
                    int maxW = -1;
                    NSDictionary *targetItem;
                    for (int i = 0; i < [ips count]; ++i) {
                        NSDictionary *item = [ips objectAtIndex:i];
                        int w = [[item objectForKey:@"w"] intValue];
                        if (w > maxW) {
                            maxW = w;
                            targetItem = item;
                        }
                    }
                    if (targetItem) {
                        // find it and then cache
                        ip = [targetItem objectForKey:@"ip"];
                        [self.quickDnsTable setValue:ip forKey:host];
                        return ip;
                    } else {
                        return nil;
                    }
                    //only one IPs
                    break;
                }
            }
        }
    }
    return nil;
}

- (void)saveIPToCache:(NSString*)ip withHost:(NSString*)host {
    @synchronized(self) {
        [self.quickDnsTable setValue:ip forKey:host];
        
        if (self.dnsTable) {
            //find from file dnstable
            for (NSDictionary *dns in self.dnsTable) {
                NSArray *ips = [dns objectForKey:host];
                if (ips) {
                    for (int i = 0; i < [ips count]; ++i) {
                        NSDictionary *item = [ips objectAtIndex:i];
                        if ([[item objectForKey:@"ip"] isEqualToString:ip]) {
                            ///exist
                            return;
                        }
                    }
                    
                    NSDictionary *ipItem = @{
                                             @"ip":ip,
                                             @"w":@1
                                             };
                    NSMutableArray *nowIPs = [NSMutableArray arrayWithArray:ips];
                    [nowIPs addObject:ipItem];
                    [self.dnsTable removeObject:dns];
                    [self.dnsTable addObject:@{host:nowIPs}];
                    [self saveToDocument:self.dnsTable];
                    //only one IPs
                    return;
                }
            }
            
            //can not find exist IPs
            NSDictionary *ipItem = @{
                                     @"ip":ip,
                                     @"w":@1
                                     };
            NSMutableArray *nowIPs = [NSMutableArray new];
            [nowIPs addObject:ipItem];
            [self.dnsTable addObject:@{host:nowIPs}];
            [self saveToDocument:self.dnsTable];
            return;
        }
    }
}

- (void)delHost:(NSString*)host withIP:(NSString*)ip {
    @synchronized(self) {
        [self.quickDnsTable removeObjectForKey:host];
        
        if (self.dnsTable) {
            //find from file dnstable
            for (NSDictionary *dns in self.dnsTable) {
                NSArray *ips = [dns objectForKey:host];
                if (ips) {
                    if (!ip) {
                        [self.dnsTable removeObject:dns];
                        [self saveToDocument:self.dnsTable];
                        return;
                    } else {
                        for (int i = 0; i < [ips count]; ++i) {
                            NSDictionary *item = [ips objectAtIndex:i];
                            if ([[item objectForKey:@"ip"] isEqualToString:ip]) {
                                ///exist
                                NSMutableArray *nowIPs = [NSMutableArray arrayWithArray:ips];
                                [nowIPs removeObject:item];
                                [self.dnsTable removeObject:dns];
                                if ([nowIPs count] > 0) {
                                    [self.dnsTable addObject:@{host:nowIPs}];
                                }
                                [self saveToDocument:self.dnsTable];
                                return;
                            }
                        }
                    }
                    
                    //only one IPs
                    break;
                }
            }
        }
    }
}
@end