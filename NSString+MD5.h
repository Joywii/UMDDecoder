//
//  NSString+MD5.h
//  
//
//  Created by  on 13-7-24.
//  Copyright (c) 2013年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)
- (NSString *) md5;
@end

@interface NSData (MD5)
- (NSString*)md5;
@end