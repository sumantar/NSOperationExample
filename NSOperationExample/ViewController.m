//
//  ViewController.m
//  NSOperationExample
//
//  Created by sumantar on 12/02/15.
//  Copyright (c) 2015 sumantar. All rights reserved.
//

#import "ViewController.h"
#import "NetworkOperation.h"

//http://api.openweathermap.org/data/2.5/weather?q=london&units=metric

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?q=london&units=metric"]];
    NetworkOperation *myOperation = [[NetworkOperation alloc] initWithRequest:request];
    [[NSOperationQueue sharedOperationQueueForNetworkOperationService] addOperation:myOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation NSOperationQueue (CommonQueeue)

+(NSOperationQueue*)sharedOperationQueueForNetworkOperationService;
{
    static NSOperationQueue* sharedQueue = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedQueue = [[NSOperationQueue alloc] init];
        sharedQueue.maxConcurrentOperationCount = 1;
    });
    
    return sharedQueue;
}

@end