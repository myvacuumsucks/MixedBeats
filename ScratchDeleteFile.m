//
//  ScratchDeleteFile.m
//  MixedUp
//
//  Created by Brian Mendez on 2/15/15.
//  Copyright (c) 2015 Kori Kolodziejczak. All rights reserved.
//

#import <Foundation/Foundation.h>

//This was the last method on the network controller.

//- (void) playSelectedBeat:(NSString *)trackID{
//  NSString *beatsPlaybackURL = [[NSString alloc] init];
//  beatsPlaybackURL = [NSString stringWithFormat:@"https://partner.api.beatsmusic.com/v1/api/tracks/tr61032803/audio?bitrate=highest&acquire=1&access_token=%@", self.token];
//
//  NSURL *url = [[NSURL alloc] initWithString:beatsPlaybackURL];
//  NSData *_objectData = [NSData dataWithContentsOfURL:[NSURL URLWithString:beatsPlaybackURL]];
//  NSError *error;

//  AVPlayer *player = [[AVPlayer alloc] init];
//  app.
//
//  app.audioPlayer = [[AVAudioPlayer alloc] initWithData:_objectData error:&error];
//  app.audioPlayer.numberOfLoops = 0;
//  app.audioPlayer.volume = 1.0f;
//  [app.audioPlayer prepareToPlay];
//
//  if (app.audioPlayer == nil)
//    NSLog(@"%@", [error description]);
//  else
//    [app.audioPlayer play];

//  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
//  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//    if (error) {
//      NSLog(@"%@", error.localizedDescription);
//    } else {
//      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
//        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
//        if (httpURLResponse.statusCode >= 200 && httpURLResponse.statusCode <= 299) {
//          NSLog(@"Succes! code: %lu", httpURLResponse.statusCode);
//          NSDictionary *beats = [Beat parseJSONIntoBeats:data];
//          [[NSOperationQueue mainQueue] addOperationWithBlock:^{completionHander(nil, beats);
//          }];
//        }
//      }
//    }
//
//  }];
//  [dataTask resume];

//}