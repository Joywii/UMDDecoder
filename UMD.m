//
//  UMD.m
//  UMDTest
//
//  Created by zhongweitao on 13-8-20.
//  Copyright (c) 2013年. All rights reserved.
//

#import "UMD.h"

@implementation UMD

-(id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (self) {
        self.contentId = [coder decodeIntegerForKey:@"contentId"];
        self.header = [coder decodeIntegerForKey:@"header"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.author = [coder decodeObjectForKey:@"author"];
        self.year = [coder decodeObjectForKey:@"year"];
        self.month = [coder decodeObjectForKey:@"month"];
        self.day = [coder decodeObjectForKey:@"day"];
        self.gender = [coder decodeObjectForKey:@"gender"];
        self.publisher = [coder decodeObjectForKey:@"publisher"];
        self.vendor = [coder decodeObjectForKey:@"vendor"];
        self.contentLength = [coder decodeIntegerForKey:@"contentLength"];
        self.offsets = [coder decodeObjectForKey:@"offsets"];
        self.chapterNumber = [coder decodeIntegerForKey:@"chapterNumber"];
        self.chapterTitles = [coder decodeObjectForKey:@"chapterTitles"];
        self.content = [coder decodeObjectForKey:@"content"];
        self.fileSize = [coder decodeIntegerForKey:@"fileSize"];
        self.umdType = [coder decodeIntegerForKey:@"umdType"];
        self.coverPath = [coder decodeObjectForKey:@"coverPath"];
        self.txtFilePath = [coder decodeObjectForKey:@"txtFilePath"];
        
        NSString *txtFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/umd"];
        //self.filePath = [[txtFolder stringByAppendingPathComponent:self.fileName] stringByAppendingPathExtension:@"txt"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder*)coder
{
    if (coder) {
        [coder encodeInteger:self.contentId forKey:@"contentId"];
        [coder encodeInteger:self.header forKey:@"header"];
        [coder encodeObject:self.title forKey:@"title"];
        [coder encodeObject:self.author forKey:@"author"];
        [coder encodeObject:self.year forKey:@"year"];
        [coder encodeObject:self.month forKey:@"month"];
        [coder encodeObject:self.day forKey:@"day"];
        [coder encodeObject:self.gender forKey:@"gender"];
        [coder encodeObject:self.publisher forKey:@"publisher"];
        [coder encodeObject:self.vendor forKey:@"vendor"];
        [coder encodeInteger:self.contentLength forKey:@"contentLength"];
        [coder encodeObject:self.offsets forKey:@"offsets"];
        [coder encodeInteger:self.chapterNumber forKey:@"chapterNumber"];
        [coder encodeObject:self.chapterTitles forKey:@"chapterTitles"];
        [coder encodeObject:self.content forKey:@"content"];
        [coder encodeInteger:self.fileSize forKey:@"fileSize"];
        [coder encodeInteger:self.umdType forKey:@"umdType"];
        [coder encodeObject:self.coverPath forKey:@"coverPath"];
        [coder encodeObject:self.txtFilePath forKey:@"txtFilePath"];

    }
}

@end
