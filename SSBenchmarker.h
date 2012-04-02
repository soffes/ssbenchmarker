//
//  SSBenchmarker.h
//  SSBenchmarker
//
//  Created by Sam Soffes on 4/2/12.
//  Copyright (c) 2012 Sam Soffes. All rights reserved.
//

typedef void (^SSBenchmarkerTask)(void);

@interface SSBenchmarker : NSObject

@property (nonatomic, assign) NSUInteger numberOfIterations; // Default is 10

- (void)addTask:(SSBenchmarkerTask)task withIdentifier:(NSString *)identifier;

- (void)run;

- (NSDictionary *)results;

@end
