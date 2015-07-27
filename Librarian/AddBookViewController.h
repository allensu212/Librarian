//
//  AddBookViewController.h
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/19.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddBookViewController;

@protocol AddBookViewControllerDelegate <NSObject>

-(void)userDidUpdateBookInformationWithDict:(NSDictionary *)bookDict;

@end

@interface AddBookViewController : UIViewController
@property (nonatomic, assign) BOOL updatingBookInfo;
@property (nonatomic, strong) NSDictionary *currentBookDict;
@property (nonatomic, weak) id<AddBookViewControllerDelegate>delegate;

@end
