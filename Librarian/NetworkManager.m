//
//  NetworkManager.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "NetworkManager.h"
#import "Constants.h"
#import "Book.h"

@implementation NetworkManager

+(NetworkManager *)sharedManager{
    
    static NetworkManager *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[NetworkManager alloc]init];
    });
    return _sharedManager;
}

-(void)addNewBook:(Book *)newBook withCompletionBlock:(AddBookCompletionBlock)callback
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/books", ENDPOINT_URL]];
    
    NSMutableString *dataString = [[NSMutableString alloc]init];
    [dataString appendFormat:@"author=%@", newBook.author];
    [dataString appendFormat:@"&categories=%@", newBook.categories];
    [dataString appendFormat:@"&title=%@", newBook.bookTitle];
    [dataString appendFormat:@"&publisher=%@", newBook.publisher];
    
    NSDate *theDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSString *dateString = [dateFormatter stringFromDate:theDate];
    
    [dataString appendFormat:@"&lastCheckedOut=%@", dateString];
    [dataString appendFormat:@"&lastCheckedOutBy=Default"];
    
    NSData *userData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:userData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:userData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"POSTED DICT: %@", dataDict);
            callback();
        }
    }];
    
    [uploadTask resume];
}

-(void)updateCheckOutInfoWithUsername:(NSString *)username bookInfo:(NSString *)bookURL completionBlock:(UpdateCheckOutInfoCompletionBlock)callback{
    
    NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", ENDPOINT_URL, bookURL]];
    
    NSString *dataString = [NSString stringWithFormat:@"lastCheckedOutBy=%@", username];
    NSData *userData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:theURL];
    
    [theRequest setHTTPMethod:@"PUT"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:userData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:theRequest fromData:userData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            
            NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            callback(dataDict);
        }
    }];
    [uploadTask resume];
}

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
