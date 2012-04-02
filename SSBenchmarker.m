//
//  SSBenchmarker.m
//  SSBenchmarker
//
//  Created by Sam Soffes on 4/2/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

#import "SSBenchmarker.h"

@interface SSBenchmarker ()
@property (nonatomic, assign, readwrite) CGFloat progress;
@end

@implementation SSBenchmarker {
	NSMutableDictionary *_tasks;
	NSMutableDictionary *_results;
	NSMutableArray *_taskIdentifiers;
	dispatch_queue_t _queue;
}

@synthesize delegate = _delegate;
@synthesize taskIdentifiers = _taskIdentifiers;
@synthesize progress = _progress;
@synthesize numberOfIterations = _numberOfIterations;


- (void)setProgress:(CGFloat)progress {
	[self willChangeValueForKey:@"progress"];
	_progress = progress;
	[self didChangeValueForKey:@"progress"];
	
	if (_delegate && [_delegate respondsToSelector:@selector(benchmarker:didUpdateProgress:)]) {
		[_delegate benchmarker:self didUpdateProgress:progress];
	}
}

#pragma mark - NSObject

- (id)init {
	if ((self = [super init])) {
		_tasks = [[NSMutableDictionary alloc] init];
		_numberOfIterations = 10;
		_queue = dispatch_queue_create("com.samsoffes.benchmarker", DISPATCH_QUEUE_SERIAL);
	}
	return self;
}


- (void)dealloc {
	dispatch_release(_queue);
}


#pragma mark - Tasks

- (void)addTask:(SSBenchmarkerTask)task withIdentifier:(NSString *)identifier {
	[_tasks setObject:task forKey:identifier];
}

- (void)run {
	if (_delegate && [_delegate respondsToSelector:@selector(benchmarkerDidStart:)]) {
		[_delegate benchmarkerDidStart:self];
	}
	
	NSUInteger numberOfTasks = _tasks.count;
	_results = [[NSMutableDictionary alloc] initWithCapacity:numberOfTasks];
	
	for (NSString *identifier in _tasks) {
		dispatch_async(_queue, ^{
			if (_delegate && [_delegate respondsToSelector:@selector(benchmarker:didStartTaskWithIdentifier:)]) {
				[_delegate benchmarker:self didStartTaskWithIdentifier:identifier];
			}
			
			SSBenchmarkerTask task = [_tasks objectForKey:identifier];
			SSBenchmark *benchmark = [[SSBenchmark alloc] init];
			benchmark.identifier = identifier;
			
			// Run tasks
			for (NSUInteger i = 0; i < _numberOfIterations; i++) {
				
				NSDate *before = [NSDate date];
				task();
				NSDate *after = [NSDate date];
				
				// Store time
				[benchmark addDouble:[after timeIntervalSinceDate:before] * 1000.0];
				
				// Update progress
				self.progress += (1.0 / (CGFloat)numberOfTasks) * (1.0 / (CGFloat)_numberOfIterations);
			}
			
			[_results setObject:benchmark forKey:identifier];
			
			if (_delegate && [_delegate respondsToSelector:@selector(benchmarker:didFinishTaskWithBenchmark:)]) {
				[_delegate benchmarker:self didFinishTaskWithBenchmark:benchmark];
			}
		});		
	}
	
	dispatch_async(_queue, ^{
		if (_delegate && [_delegate respondsToSelector:@selector(benchmarkerDidFinish:)]) {
			[_delegate benchmarkerDidFinish:self];
		}
	});
}

- (NSDictionary *)results {
	return _results;
}

@end
