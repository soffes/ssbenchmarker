//
//  SSBenchmark.m
//  SSBenchmarker
//
//  Created by Sam Soffes on 4/2/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "SSBenchmark.h"

@implementation SSBenchmark {
	NSMutableArray *_numbers;
	NSArray *_sortedNumbers;
	
	double _pseudoVariance;
}

@synthesize identifier = _identifier;
@synthesize count = _count;
@synthesize min = _min;
@synthesize mean = _mean;
@synthesize max = _max;
@synthesize numbers = _numbers;
@synthesize sortedNumbers = _sortedNumbers;

- (NSArray *)numbers {
	return _numbers.copy;
}


- (NSArray *)sortedNumbers {
    if (!_sortedNumbers) {
        _sortedNumbers = [_numbers sortedArrayUsingSelector:@selector(compare:)];
	}
	
    return _sortedNumbers;
}


- (void)addDouble:(double)d {
	if (!_count) {
        _min = INFINITY;
        _max = -_min;
        _mean = 0;
    }
    
    if (d < _min) {
        _min = d;
    }
	
    if (d > _max) {
        _max = d;
    }
    
    double oldMean = _mean;
    _mean += (d - oldMean) / ++_count;
    _pseudoVariance += (d - _mean) * (d - oldMean);
	
	[_numbers addObject:[NSNumber numberWithDouble:d]];
	_sortedNumbers = nil;
}


- (double)standardDeviation {
	return sqrt(self.variance);
}


- (double)variance {
	if (_count > 1) {
        return _pseudoVariance / (double)(_count - 1);
	}
    return nan(0);
}

@end
