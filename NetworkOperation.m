//
//  NetworkOperation.m
//  NSOperationExample
//
//  Created by sumantar on 12/02/15.
//  Copyright (c) 2015 sumantar. All rights reserved.
//

#import "NetworkOperation.h"

NSString *const kExecuting		                = @"isExecuting";
NSString *const kFinished		                = @"isFinished";

@implementation NetworkOperation

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    if ([key isEqualToString:@"isExecuting"] ||
        [key isEqualToString:@"isFinished"])
    {
        return YES;
    }
    return [super automaticallyNotifiesObserversForKey:key];
}

- (instancetype)initWithRequest:(NSURLRequest*)request {
    self = [super init];
    if (self) {
        _isExecuting = NO; //Default Values
        _isFinished = YES; //Default Values
        
        _request = request;
    }
    return self;
}

- (void) longRunningTask {
    if ([NSThread isMainThread]) {
        NSLog(@"Running on main thread");
    }
    else {
        NSLog(@"Running on background thread");
    }
}

#pragma mark Overriding NSOperation Methods
//Set concurrency flag
- (BOOL)isConcurrent{
    return YES;
}

//Set execution flag
- (BOOL)isExecuting{
    return _isExecuting;
}

//Set finish flag
- (BOOL)isFinished{
    return _isFinished;
}

//Set start of this operation
- (void)start{
    if (![self isCancelled]){
        [self setValue:@YES forKey:kExecuting];
        [self setValue:@NO forKey:kFinished];
        [self longRunningTask];
        
        self.returnData = [NSMutableString string];
        self.connection = [NSURLConnection connectionWithRequest:_request delegate:self];
        
        /*
         But once the NSURLConnection is launched in a seperate thread, the delegate methods do not get triggered anymore. This probably because the thread is finished before our class actually executed all it’s code. After we initialized the NSURLConnection object, we actually need to put the class in an infinite loop to make sure the class is still alive when the delegate methods are hit.
         */
        while(!_isFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        [self.connection scheduleInRunLoop:[NSRunLoop currentRunLoop]
                              forMode:NSRunLoopCommonModes];
        [self.connection start];
        
        /*
        if (![NSThread isMainThread])
        {
            [self performSelectorOnMainThread:@selector(start)
                                   withObject:nil waitUntilDone:NO];
            return;
        }
        */
    }
}

//Cancel Operation
- (void)cancel{
    
    [self.connection cancel];
    self.connection = nil;
    
    [self setValue:@NO forKey:kExecuting];
    [self setValue:@YES forKey:kFinished];
    
    self.returnData = nil;
    
    [super cancel];
}

#pragma mark -- NSURLConnection delegate
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    _statusCode = [((NSHTTPURLResponse *)response) statusCode];
    if ([NSThread isMainThread]) {
        NSLog(@"didReceiveResponse Running on main thread");
    }
    else {
        NSLog(@"didReceiveResponse Running on background thread");
    }
    if (_isFinished) {
        NSLog(@"Not finished");
    }
    else {
        NSLog(@"Is finished");
    }
}

- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData*)data
{
    NSString* retStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if(retStr != nil)
    {
        [self.returnData appendString:retStr];
    }
    
    if ([NSThread isMainThread]) {
        NSLog(@"didReceiveData Running on main thread");
    }
    else {
        NSLog(@"didReceiveData Running on background thread");
    }
    
    if (_isFinished) {
        NSLog(@"Not finished");
    }
    else {
        NSLog(@"Is finished");
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    self.connection = nil;
    [self setValue:@NO forKey:kExecuting];
    [self setValue:@YES forKey:kFinished];
    NSLog(@"Done: %@", self.returnData);
    if ([NSThread isMainThread]) {
        NSLog(@"connectionDidFinishLoading Running on main thread");
    }
    else {
        NSLog(@"connectionDidFinishLoading Running on background thread");
    }
    if (_isFinished) {
        NSLog(@"Not finished");
    }
    else {
        NSLog(@"Is finished");
    }
}

- (void)connection:(NSURLConnection*)connection
  didFailWithError:(NSError*)error
{
    //_errorDescription = [[[[error userInfo] objectForKey:@"NSUnderlyingError"] userInfo] objectForKey:@"NSLocalizedDescription"];
    
    _errorDescription = error.localizedDescription;
    
    self.connection = nil;
    [self setValue:@NO forKey:kExecuting];
    [self setValue:@YES forKey:kFinished];
    
    if ([NSThread isMainThread]) {
        NSLog(@"didFailWithError Running on main thread");
    }
    else {
        NSLog(@"didFailWithError Running on background thread");
    }
    if (_isFinished) {
        NSLog(@"Not finished");
    }
    else {
        NSLog(@"Is finished");
    }
}

@end
