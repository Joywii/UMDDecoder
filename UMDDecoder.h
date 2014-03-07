//
//  UMDDecoder.h
//  UMDTest
//
//  Created by zhongweitao on 13-8-20.
//  Copyright (c) 2013年. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UMD;
@interface UMDDecoder : NSObject
{
    BOOL isStart;
}
+ (UMDDecoder *)getShareUMDDecoder;
- (UMD *)getUMDFile:(NSString *)filePath;
@end
