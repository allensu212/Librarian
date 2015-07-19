//
//  NetworkManager.h
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/18.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FetchBooksCompletionBlock)(NSArray *dataArray);

@interface NetworkManager : NSObject

-(void)fetchBooksWithCompletionBlock:(FetchBooksCompletionBlock)callback;

@end
