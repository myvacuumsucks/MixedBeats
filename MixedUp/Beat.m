//
//  Beat.m
//  MixedUp
//
//  Created by Kori Kolodziejczak on 12/10/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

#import "Beat.h"

@implementation Beat

- (instancetype) initWithName:(NSString *)name {
  
  self = [super init];
  
  if (self) {
    self.name = name;
  }
  return self;
}

+ (NSDictionary *)parseJSONIntoBeats:(NSData *)rawJSONData {
    NSDictionary *beats = [[NSDictionary alloc] init];
    
    NSError *error = nil;
    NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:rawJSONData options:0 error:&error];
    
  
  if (error != nil) {
    NSLog(@"json parsing unsuccessful. %@", error.localizedDescription);
  } else {
    NSLog(@"%@", JSONDictionary);
      
    NSArray *dataArray = JSONDictionary[@"data"];
    NSMutableArray* artistArray = [[NSMutableArray alloc]init];
    NSMutableArray* albumArray = [[NSMutableArray alloc]init];
    NSMutableArray* trackArray = [[NSMutableArray alloc]init];

      for (NSDictionary* item in dataArray) {
          NSString* resultType = item[@"result_type"];
        
          if ([resultType  isEqual: @"artist"]) {
              
              [artistArray addObject:(item)];
          } else if ([resultType  isEqual: @"album"]) {
              
              [albumArray addObject:(item)];
          } else if ([resultType  isEqual: @"track"]) {
                            [trackArray addObject:(item)];
          } else {
              
          }
      
      
      
      }
      
      
      
      beats = @{@"artists" : artistArray,
                @"albums" : albumArray,
                @"tracks" : trackArray
                };
      
  }
    return beats;
  }



@end