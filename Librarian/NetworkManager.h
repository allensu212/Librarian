//
//  NetworkManager.h
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FetchBooksCompletionBlock)(NSArray *dataArray);
typedef void(^UpdateCheckOutInfoCompletionBlock)(NSDictionary *dataDict);


@interface NetworkManager : NSObject

+(NetworkManager *)sharedManager;
-(void)fetchBooksWithCompletionBlock:(FetchBooksCompletionBlock)callback;
-(void)updateCheckOutInfoWithUsername:(NSString *)username bookInfo:(NSString *)bookURL completionBlock:(UpdateCheckOutInfoCompletionBlock)callback;

@end
