//
//  JPDNSParser.h
//  dns
//
//  Created by Jasper on 15/5/28.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ParserFinish)(NSString*ip);

@interface JPDNSParser : NSObject

///syn get ip, will block the thread
+ (NSString*) ipSynParseWithHost:(NSString*)host;
///asyn get ip
+ (void)ipAsynParseWithHost:(NSString*)host withComplete:(ParserFinish)finishHandler;


+ (JPDNSParser*)shareParser;
- (void)setobject:(id)obj forKeyedSubscript:(NSString*)key;
- (id)objectForKeyedSubscript:(NSString*)key;
@end
