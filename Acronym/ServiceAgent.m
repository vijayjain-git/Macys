//
//  ServiceAgent.m
//  Acronym
//
//  Created by Vijay Jain on 11/15/16.
//  Copyright © 2016 Vijay Jain. All rights reserved.
//

#import "ServiceAgent.h"
#import "AFNetworking.h"

@implementation ServiceAgent



- (void) downloadAcronymValues:(NSString *) acronym errorHandler:(void(^)(NSError *error))errorHandler completionHandler:(void (^)())completion
{
    static NSString * const baseURLString = @"https://www.nactem.ac.uk/software/acromine/dictionary.py?sf=%@";
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:baseURLString, acronym]];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    
    //[manager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    [manager setResponseSerializer:[AFHTTPResponseSerializer serializer]];

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error != nil)
        {
            errorHandler(error);
        }
        else
        {
            NSError *err = nil;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseObject options: NSJSONReadingMutableContainers error: &err];
            
            if (!jsonArray)
            {
                NSLog(@"Error parsing JSON: %@", err);
            } else
            {
                NSMutableArray *theAcronymValues = [[NSMutableArray alloc] init];
                for(NSDictionary *item in jsonArray)
                {
                    NSArray *array = [item valueForKey:@"lfs"];
                    for(NSDictionary *ifsItem in array)
                    {
                        
                        NSString *value = [ifsItem valueForKey:@"lf"];
                        //NSString *value = [valueArray objectAtIndex:0];
                        NSLog(@"Value: %@", value);
                        if ([theAcronymValues indexOfObject:value] == NSNotFound)
                        {
                            [theAcronymValues addObject:value];
                        }
                    }
                }
                self.acronymValues = theAcronymValues;
                completion();
            }
        }
        // Process Response Object
    }] resume];
}

@end
