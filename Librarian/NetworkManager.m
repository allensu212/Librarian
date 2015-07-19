//
//  NetworkManager.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "NetworkManager.h"
#import "Constants.h"

@implementation NetworkManager

-(void)fetchBooksWithCompletionBlock:(FetchBooksCompletionBlock)callback{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/books", ENDPOINT_URL]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            callback(jsonArray);
        }
    }];
    
    [dataTask resume];
}

@end
