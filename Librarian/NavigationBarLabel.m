//
//  NavigationBarLabel.m
//  Librarian
//
//  Created by 蘇偉綸 on 2015/7/21.
//  Copyright (c) 2015年 allensu. All rights reserved.
//

#import "NavigationBarLabel.h"

#define NAV_CONTROLLER_LABEL_WIDTH 20.0f
#define NAV_CONTROLLER_LABEL_HEIGHT 44.0f

@implementation NavigationBarLabel

-(instancetype)initWithText:(NSString *)theText{
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, NAV_CONTROLLER_LABEL_WIDTH, NAV_CONTROLLER_LABEL_HEIGHT);
        self.text = theText;
        
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont fontWithName:@"Futura" size:21.0f];
        self.textColor = [UIColor darkGrayColor];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

@end
