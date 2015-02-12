//
//  ViewController.h
//  NSOperationExample
//
//  Created by sumantar on 12/02/15.
//  Copyright (c) 2015 sumantar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end


@interface NSOperationQueue (CommonQueeue)

+(NSOperationQueue*)sharedOperationQueueForNetworkOperationService;

@end

