//
//  NetworkOperation.h
//  NSOperationExample
//
//  Created by sumantar on 12/02/15.
//  Copyright (c) 2015 sumantar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkOperation : NSOperation

@property (nonatomic) BOOL isExecuting;
@property (nonatomic) BOOL isFinished;

@property (nonatomic, strong)  NSURLRequest*        request;
@property (nonatomic, strong)  NSURLConnection*     connection;
@property (nonatomic, strong)  NSMutableString*     returnData;
@property (nonatomic, strong, readonly)  NSString*  errorDescription;
@property (nonatomic, readonly) NSInteger           statusCode;

- (instancetype)initWithRequest:(NSURLRequest*)request;

@end
