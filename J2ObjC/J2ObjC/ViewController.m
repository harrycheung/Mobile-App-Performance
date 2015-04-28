//
//  ViewController.m
//  J2ObjC
//
//  Created by harry on 2/15/15.
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "ViewController.h"
#import "SessionManager.h"
#import "Track.h"
#import "Point.h"
#import "IOSObjectArray.h"

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
  NSString *lapsFilePath = [[NSBundle mainBundle] pathForResource:@"multi_lap_session" ofType:@"csv" inDirectory:@"Data"];
  NSString *contents = [NSString stringWithContentsOfFile:lapsFilePath encoding:NSUTF8StringEncoding error:&error];
  NSArray *lines = [contents componentsSeparatedByString:@"\n"];
  points = [[[NSMutableArray alloc] initWithCapacity:[lines count]] retain];
  for (int x = 0; x < [lines count]; x++) {
    NSString *line = lines[x];
    NSArray *parts = [line componentsSeparatedByString:@","];
    points[x] = [[HCMPoint alloc] initWithDouble:[parts[0] doubleValue]
                                      withDouble:[parts[1] doubleValue]
                                      withDouble:[parts[2] doubleValue]
                                      withDouble:[parts[3] doubleValue]
                                      withDouble:5.0
                                      withDouble:5.0
                                      withDouble:0];
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
  track = [[HCMTrack_load__WithNSString_(json) objectAtIndex:0] retain];
}

- (double)run:(double)n {
  NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
  NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
  for (int j = 0; j < n; j++) {
    @autoreleasepool {
      [[HCMSessionManager getInstance] startSessionWithHCMTrack:self->track];
      for (int i = 0; i < [points count]; i++) {
        HCMPoint *point = points[i];
        [[HCMSessionManager getInstance] gpsWithDouble:[point getLatitudeDegrees]
                                            withDouble:[point getLongitudeDegrees]
                                            withDouble:point->speed_
                                            withDouble:point->bearing_
                                            withDouble:5.0
                                            withDouble:5.0
                                            withDouble:startTime];
        startTime++;
      }
      [[HCMSessionManager getInstance] endSession];
    }
  }
  
  return [NSDate timeIntervalSinceReferenceDate] - start;
}

- (IBAction)run1000:(id)sender {
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
