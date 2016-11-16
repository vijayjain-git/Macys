//
//  ServiceAgent.h
//  Acronym
//
//  Created by Vijay Jain on 11/15/16.
//  Copyright © 2016 Vijay Jain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceAgent : NSObject

@property (nonatomic, retain) NSArray *acronymValues;

- (void) downloadAcronymValues:(NSString *) acronym errorHandler:(void(^)(NSError *error))errorHandler completionHandler:(void (^)())completion;

@end
