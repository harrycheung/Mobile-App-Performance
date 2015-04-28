//
//  ViewController.mm
//  CPPIOS
//
//  Copyright (c) 2015 Harry Cheung. All rights reserved.
//

#import "ViewController.h"
#import "TrackLoader.h"
#include "HCMSessionManager.h"
#include "HCMPoint.h"
#include "HCMTrack.h"
#include <vector>

@interface ViewController ()

@property (retain, nonatomic) IBOutlet UILabel *label1000;
@property (retain, nonatomic) IBOutlet UILabel *label10000;

@end

@implementation ViewController {

  HCMPoint *points;
  HCMTrack *track;
  int pointsLength;
  
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
  pointsLength = (int)[lines count];
  points = new HCMPoint[pointsLength];
  for (int x = 0; x < pointsLength; x++) {
    NSString *line = lines[x];
    NSArray *parts = [line componentsSeparatedByString:@","];
    points[x].latitude = [parts[0] doubleValue];
    points[x].longitude = [parts[1] doubleValue];
    points[x].speed = [parts[2] doubleValue];
    points[x].bearing = [parts[3] doubleValue];
    points[x].hAccuracy = 5.0;
    points[x].vAccuracy = 5.0;
    points[x].timestamp = 0;
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
  track = [TrackLoader loadWithData:[json dataUsingEncoding:NSUTF8StringEncoding]];
}

- (double)run:(double)n {
  NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
  NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];
  for (int j = 0; j < n; j++) {
    HCMSessionManager::instance->start(track, [NSDate timeIntervalSinceReferenceDate]);
    for (int i = 0; i < pointsLength; i++) {
      HCMPoint point = points[i];
      HCMSessionManager::instance->gps(point.latitudeDegrees(),
                                       point.longitudeDegrees(),
                                       point.speed,
                                       point.bearing,
                                       5.0, 5.0,
                                       startTime);
      startTime++;
    }
    HCMSessionManager::instance->end();
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
  delete points;
  delete track;
  [super dealloc];
}

@end
