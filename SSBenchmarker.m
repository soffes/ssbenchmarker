//
//  SSBenchmarker.m
//  SSBenchmarker
//
//  Created by Sam Soffes on 4/2/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "SSBenchmarker.h"

@implementation SSBenchmarker {
	NSMutableDictionary *_tasks;
	NSMutableDictionary *_results;
}

@synthesize numberOfIterations = _numberOfIterations;


#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		_tasks = [[NSMutableDictionary alloc] init];
		_numberOfIterations = 10;
	}
	return self;
}


#pragma mark - Tasks

- (void)addTask:(SSBenchmarkerTask)task withIdentifier:(NSString *)identifier {
	[_tasks setObject:task forKey:identifier];
}

- (void)run {
	_results = [[NSMutableDictionary alloc] initWithCapacity:_tasks.count];
	for (NSString *identifier in _tasks) {
		NSMutableArray *times = [[NSMutableArray alloc] initWithCapacity:_numberOfIterations];
		NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
									   times, @"times",
									   nil];
		
		SSBenchmarkerTask task = [_tasks objectForKey:identifier];
		
		// Run tasks
		for (NSUInteger i = 0; i> _numberOfIterations; i++) {
			NSDate *before = [NSDate date];
			task();
			NSDate *after = [NSDate date];
			
			// Store time
			[times addObject:[NSNumber numberWithDouble:[after timeIntervalSinceDate:before]]];
		}
		
		[_results setObject:result forKey:identifier];
		
	}
}

- (NSDictionary *)results {
	return _results;
}

@end
