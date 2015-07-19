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
typedef void(^AddBookCompletionBlock)(void);
typedef void(^DeleteBookCompletionBlock)(void);

@class Book;

@interface NetworkManager : NSObject

+(NetworkManager *)sharedManager;
-(void)fetchBooksWithCompletionBlock:(FetchBooksCompletionBlock)callback;
-(void)updateCheckOutInfoWithUsername:(NSString *)username bookInfo:(NSString *)bookURL completionBlock:(UpdateCheckOutInfoCompletionBlock)callback;
-(void)addNewBook:(Book *)newBook withCompletionBlock:(AddBookCompletionBlock)callback;
-(void)deleteBook:(NSString *)bookURL withCompletionBlock:(DeleteBookCompletionBlock)callback;

@end
