# dnsparser
A custom dns parser for HTTP on iOS.

##Notice
The dns.plist is always need, don't remove it.

###Feature
* default dns（host-ip）table, which have a weight
* parse host and cache the ip
* manage host-ip cache


todo：
* I dont know now....Please give me some ideas.



####Parser Host:

```objc

    NSString *ip = [JPDNSParser ipSynParseWithHost:@"wechat.iduobao.net"];
    NSLog(@"syn ip:%@", ip);
    [JPDNSParser ipAsynParseWithHost:@"wechat.iduobao.net" withComplete:^(NSString *ip) {
        NSLog(@"asyn ip:%@", ip);
    }];

```


####Make a request:


```objc 
    NSMutableURLRequest *req = [NSMutableURLRequest JPDNS_requestWithURL:[NSURL URLWithString:@"http://wechat.iduobao.net"]];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"result:%@", str);
    }];
```


####Change the default DNS Plist
A host will have more than one ip, and every ip has a weight.You can change The dns.plist and it will be copy to the document path.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<dict>
		<key>wechat.iduobao.net</key>
		<array>
			<dict>
				<key>w</key>
				<string>10</string>
				<key>ip</key>
				<string>120.132.59.160</string>
			</dict>
		</array>
	</dict>
</array>
</plist>

```


####Use JPDNSCache

```objc
- (void)saveIPToCache:(NSString*)ip withHost:(NSString*)host;
///ip is nil -》delete all ips
- (void)delHost:(NSString*)host withIP:(NSString*)ip;
```

##License

The MIT License (MIT)

Copyright (c) 2014 Jasper @Jasper

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.