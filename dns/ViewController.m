//
//  ViewController.m
//  dns
//
//  Created by Jasper on 15/5/28.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import "ViewController.h"
#import "JPDNSParser.h"
#import "NSMutableURLRequest+JPDNS.h"
#import "JPDNSCache.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)req{
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://120.132.59.160"]];
//    [req addValue:@"wechat.iduobao.net" forHTTPHeaderField:@"Host"];
//    [[JPDNSCache shareCache]delHost:@"wechat.iduobao.net" withIP:@"120.132.59.160"];
    
    NSMutableURLRequest *req = [NSMutableURLRequest JPDNS_requestWithURL:[NSURL URLWithString:@"http://wechat.iduobao.net"]];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result:%@", str);
    }];
    
//    NSString *ip = [JPDNSParser ipSynParseWithHost:@"wechat.iduobao.net"];
//    NSLog(@"syn ip:%@", ip);
//    [JPDNSParser ipAsynParseWithHost:@"wechat.iduobao.net" withComplete:^(NSString *ip) {
//        NSLog(@"asyn ip:%@", ip);
//    }];

}
@end
