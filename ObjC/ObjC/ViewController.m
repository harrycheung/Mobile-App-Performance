//
//  ViewController.m
//  ObjC
//
//  Created by harry on 2/27/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "ViewController.h"
#import "HCMSessionManager.h"
#import "HCMPoint.h"
#import "HCMTrack.h"

@interface ViewController ()

@property (retain, nonatomic) IBOutlet UILabel *label1000;
@property (retain, nonatomic) IBOutlet UILabel *label10000;

@end

@implementation ViewController {

  NSMutableArray *points;
  HCMTrack *track;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSError *error = nil;
  NSString *lapsFilePath = [[NSBundle mainBundle] pathForResource:@"multi_lap_session"
                                                           ofType:@"csv"
                                                      inDirectory:@"Data"];
  NSString *contents = [NSString stringWithContentsOfFile:lapsFilePath
                                                 encoding:NSUTF8StringEncoding
                                                    error:&error];
  NSArray *lines = [contents componentsSeparatedByString:@"\n"];
  points = [[[NSMutableArray alloc] initWithCapacity:[lines count]] retain];
  for (int x = 0; x < [lines count]; x++) {
    NSString *line = lines[x];
    NSArray *parts = [line componentsSeparatedByString:@","];
    points[x] = [[HCMPoint alloc] initWithLatitude:[parts[0] doubleValue]
                                         longitude:[parts[1] doubleValue]
                                             speed:[parts[2] doubleValue]
                                           bearing:[parts[3] doubleValue]
                                horizontalAccuracy:5.0
                                  verticalAccuracy:5.0
                                      timestamp:0];
  }
  
  NSString *json = @"" \
  "{" \
    "\"track\": {" \
      "\"id\": \"1000\"," \
      "\"name\": \"Test Raceway\"," \
      "\"gates\": [" \
        "{" \
        "\"gate_type\": \"SPLIT\"," \
        "\"split_number\": \"1\"," \
        "\"latitude\": \"37.451775\"," \
        "\"longitude\": \"-122.203657\"," \
        "\"bearing\": \"136\"" \
        "}," \
        "{" \
        "\"gate_type\": \"SPLIT\"," \
        "\"split_number\": \"2\"," \
        "\"latitude\": \"37.450127\"," \
        "\"longitude\": \"-122.205499\"," \
        "\"bearing\": \"326\"" \
        "}," \
        "{" \
        "\"split_number\": \"3\"," \
        "\"gate_type\": \"START_FINISH\"," \
        "\"latitude\": \"37.452602\"," \
        "\"longitude\": \"-122.207069\"," \
        "\"bearing\": \"32\"" \
        "}" \
      "]" \
    "}" \
  "}";
  track = [[HCMTrack alloc] initWithData:[json dataUsingEncoding:NSUTF8StringEncoding]];
}

- (double)run:(double)n {
  NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
  NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
  for (int j = 0; j < n; j++) {
    @autoreleasepool {
      [[HCMSessionManager instance] startSessionWithTrack:self->track];
      for (int i = 0; i < [points count]; i++) {
        HCMPoint *point = points[i];
        [[HCMSessionManager instance] gpsWithLatitude:[point latitudeDegrees]
                                            longitude:[point longitudeDegrees]
                                                speed:point->speed
                                              bearing:point->bearing
                                   horizontalAccuracy:5.0
                                     verticalAccuracy:5.0
                                            timestamp:startTime];
        startTime++;
      }
      [[HCMSessionManager instance] endSession];
    }
  }
  
  return [NSDate timeIntervalSinceReferenceDate] - start;
}

- (IBAction)run1000:(id)sender {
//  NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
//  for (int i = 0; i < 10000; i++) {
//    @autoreleasepool {
//      NSMutableArray *aList = [[[NSMutableArray alloc] init] autorelease];
//      for (int j = 0; j < [points count]; j++) {
//        HCMPoint *point = points[j];
//        [aList addObject:[[[HCMPoint alloc] initWithLatitude:[point latitudeDegrees] longitude:[point longitudeDegrees]] autorelease]];
//      }
//      for (int k = 0; k < [points count]; k++) {
//        HCMPoint *dummy = aList[k];
//      }
//    }
//  }
//  _label1000.text = [NSString stringWithFormat:@"%.3f", [NSDate timeIntervalSinceReferenceDate] - start];
  _label1000.text = [NSString stringWithFormat:@"%.3f", [self run:1000]];  
}

- (IBAction)run10000:(id)sender {
  _label10000.text = [NSString stringWithFormat:@"%.3f", [self run:10000]];
}

- (void)dealloc {
  [_label1000 release];
  [_label10000 release];
  [points release];
  [track release];
  [super dealloc];
}

@end
