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
    
    //    if (error) {
    //      NSLog(@"json parsing unsuccessful. %@", error.localizedDescription);
    //
    //    } else {
    //      NSDictionary* infoDict = JSONDictionary[@"info"];
    //
    //      if ([infoDict[@"count"] isEqual: @"0"]) {
    //
    //        Beat *newBeat = [[Beat alloc] initWithName:@"Nothing Found"];
    //        [beats addObject:newBeat];
    //
    //
    //      } else {
    //        NSArray *arrayOfEntry = JSONDictionary[@"data"];
    //        NSDictionary *data = arrayOfEntry[0];
    //        if ([data[@"type"] isEqual: @"playlist"]) {
    //          for (NSDictionary *searchDictionary in arrayOfEntry) {
    //            NSString *name = searchDictionary[@"name"];
    //            Beat *newBeat = [[Beat alloc] initWithName:name];
    //            [beats addObject:newBeat];
    //          }
    //      }
    //    }
    //    return beats;
    //    }
    //  return nil;
    //  }
    
    
    if (error != nil) {
        NSLog(@"json parsing unsuccessful. %@", error.localizedDescription);
    } else {
        NSLog(@"%@", JSONDictionary);
        NSArray *arrayOfEntry = JSONDictionary[@"data"];
        NSDictionary *data = arrayOfEntry[0];
        if ([data[@"type"] isEqual: @"playlist"]) {
            for (NSDictionary *searchDictionary in arrayOfEntry) {
                NSString *name = searchDictionary[@"name"];
                Beat *newBeat = [[Beat alloc] initWithName:name];
                [beats addObject:newBeat];
            }
        } else {
            for (NSDictionary *searchDictionary in arrayOfEntry) {
                NSString *name = searchDictionary[@"display"];
                Beat *newBeat = [[Beat alloc] initWithName:name];
                [beats addObject:newBeat];
            }
        }
        return beats;
    }
    return nil;
}

@end