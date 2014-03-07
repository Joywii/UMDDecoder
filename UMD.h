//
//  UMD.h
//  UMDTest
//
//  Created by zhongweitao on 13-8-20.
//  Copyright (c) 2013年. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMD : NSObject <NSCoding>
{
}

@property (nonatomic, assign) NSInteger contentId;
@property (nonatomic, assign) NSInteger header;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *year;
@property (nonatomic, retain) NSString *month;
@property (nonatomic, retain) NSString *day;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *publisher;
@property (nonatomic, retain) NSString *vendor;
@property (nonatomic, assign) NSInteger contentLength;
@property (nonatomic, retain) NSMutableArray *offsets;
@property (nonatomic, assign) NSInteger chapterNumber;
@property (nonatomic, retain) NSMutableArray *chapterTitles;
@property (nonatomic, retain) NSMutableArray *chapterContents; //没用
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSData *covers;//要节省内存 不赋值
@property (nonatomic, assign) NSInteger fileSize;
@property (nonatomic, assign) NSInteger umdType;
@property (nonatomic, retain) NSString *coverPath;
@property (nonatomic, retain) NSString *zipFilePath; //没用
@property (nonatomic, retain) NSString *txtFilePath;


@end
