//
//  NetworkController.m
//  MixedBeats
//
//  Created by Brian Mendez on 12/9/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

#import "NetworkController.h"
#import "Beat.h"

@implementation NetworkController

NSString *OAuthClientSecret = @"Amg4eHtxe4Wt2QANTwHzHa8m";

+ (NetworkController *)sharedManager {
    static NetworkController *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (void)searchTerm:(NSString *)name completionHandler: (void(^)(NSError *error, NSMutableArray *beats))completionHandler {
    NSString *urlWithSearchTerm = [[NSString alloc] init];
    urlWithSearchTerm = [NSString stringWithFormat:@"https://partner.api.beatsmusic.com/v1/api/search?type=artist&q=%@+&client_id=t3uz7rxmzq2a57hnqdxjzwbh", name];

    
    NSURL *url = [[NSURL alloc] initWithString:urlWithSearchTerm];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
                if (httpURLResponse.statusCode >= 200 && httpURLResponse.statusCode <= 299) {
                    NSLog(@"success! code: %lu", httpURLResponse.statusCode);
                    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"The JSON: %@", json);
                    NSMutableArray *beats = [Beat parseJSONIntoBeats:data];
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{completionHandler(nil, beats);
                    }];
                }
            }
        }
        
    }];
    
    [dataTask resume];
}

@end