//
//  SSBenchmark.h
//  SSBenchmarker
//
//  Created by Sam Soffes on 4/2/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//
//  Inspired by SBStatistics. Thanks for the math Stig!
//

@interface SSBenchmark : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, assign, readonly) NSUInteger count;
@property (nonatomic, assign, readonly) double min;
@property (nonatomic, assign, readonly) double mean;
@property (nonatomic, assign, readonly) double max;
@property (nonatomic, assign, readonly) double variance;
@property (nonatomic, assign, readonly) double standardDeviation;
@property (nonatomic, strong, readonly) NSArray *numbers;
@property (nonatomic, strong, readonly) NSArray *sortedNumbers;

- (void)addDouble:(double)d;

@end
