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

+ (NSMutableArray *)parseJSONIntoBeats:(NSData *)rawJSONData {
  NSMutableArray *beats = [[NSMutableArray alloc] init];
  
  NSError *error = nil;
  NSDictionary *JSONDictionary = [NSJSONSerialization JSONObjectWithData:rawJSONData options:0 error:&error];
  
  if (error != nil) {
    NSLog(@"json parsing unsuccessful. %@", error.localizedDescription);
  } else {
    NSArray *arrayOfEntry = JSONDictionary[@"data"];
    for (NSDictionary *searchDictionary in arrayOfEntry) {
      NSString *name = searchDictionary[@"display"];
      Beat *newBeat = [[Beat alloc] initWithName:name];
      [beats addObject:newBeat];
    }
    return beats;
  }
  return nil;
}

@end