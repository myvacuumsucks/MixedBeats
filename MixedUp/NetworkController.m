//
//  NetworkController.m
//  MixedUp
//
//  Created by Kori Kolodziejczak on 12/5/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

#import "NetworkController.h"

@interface NetworkController ()
@property (strong, nonatomic) NSString* client_secret;

@end




@implementation NetworkController


NSString* clientID = @"3nbxp96juh7spx6j9srkknhs";
NSString* clientSecret = @"uSbQFBHZtJEvBxjg2dc2fhRs";
NSString* oAuthURL = @"https://partner.api.beatsmusic.com/v1/oauth2/authorize";
NSString* response_type = @"token";
NSString* redirectURL = @"somefancyname://test";


+ (NetworkController*)sharedInstance
{
  static NetworkController *_sharedInstance = nil;
  static dispatch_once_t oncePredicate;
  dispatch_once(&oncePredicate, ^{
    _sharedInstance = [[NetworkController alloc] init];
  });
  return _sharedInstance;
}


-(void)requestOAuthAccess {
//Making URL string with callback URL so Beats knows where to go back to
  NSString *loginURL = [NSString stringWithFormat: @"%@?response_type=%@&redirect_uri=%@&client_id=%@", oAuthURL, response_type, redirectURL, clientID];
  NSURL* url = [NSURL URLWithString:loginURL];
  //step 2, leaves app and presents user with webpage
  [[UIApplication sharedApplication]openURL:url];
}


-(void)handleOAuthURL: (NSURL*) callbackURL {
    //everything passed the question mark of the URL is the query string (contains perameters)
//cut the URL up in to pieces until you have token
    NSString *query = callbackURL.query;
  NSString *components = query;
  NSArray* comp1Array= [components componentsSeparatedByString:@"access_token="];
  NSString* comp1 = [comp1Array lastObject];
  NSArray* comp2Array= [comp1 componentsSeparatedByString:@"&"];
  NSString* token = [comp2Array firstObject];
  

  NSLog(@"Token: %@", token);
  
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
