//
//  SSBenchmarker.h
//  SSBenchmarker
//
//  Created by Sam Soffes on 4/2/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "SSBenchmark.h"

typedef void (^SSBenchmarkerTask)(void);

@protocol SSBenchmarkerDelegate;

@interface SSBenchmarker : NSObject

@property (nonatomic, assign) id<SSBenchmarkerDelegate> delegate;
@property (nonatomic, strong, readonly) NSArray *taskIdentifiers;
@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, assign) NSUInteger numberOfIterations; // Default is 10

- (void)addTask:(SSBenchmarkerTask)task withIdentifier:(NSString *)identifier;

- (void)run;

- (NSDictionary *)results;

@end


@protocol SSBenchmarkerDelegate <NSObject>

@optional

- (void)benchmarkerDidStart:(SSBenchmarker *)benchmarker;
- (void)benchmarker:(SSBenchmarker *)benchmarker didStartTaskWithIdentifier:(NSString *)identifier;
- (void)benchmarker:(SSBenchmarker *)benchmarker didFinishTaskWithBenchmark:(SSBenchmark *)benchmark;
- (void)benchmarker:(SSBenchmarker *)benchmarker didUpdateProgress:(CGFloat)progress;
- (void)benchmarkerDidFinish:(SSBenchmarker *)benchmarker;

@end
