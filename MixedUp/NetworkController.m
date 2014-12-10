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
  NSString *loginURL = [NSString stringWithFormat: @"%@?response_type=%@&redirect_uri=%@&client_id=%@", oAuthURL, response_type, redirectURL, clientID];
  NSURL* url = [NSURL URLWithString:loginURL];
  
  [[UIApplication sharedApplication]openURL:url];
}


-(void)handleOAuthURL: (NSURL*) callbackURL {
  NSURL* query = callbackURL.query;
  
  NSLog(@"%@", callbackURL.query);


}

  

@end
