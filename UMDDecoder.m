//
//  UMDDecoder.m
//  UMDTest
//
//  Created by zhongweitao on 13-8-20.
//  Copyright (c) 2013年. All rights reserved.
//

#import "UMDDecoder.h"
#import "UMD.h"
#import "NSString+MD5.h"
#import "zlib.h"

#define  MAXBUFFERSIZE 1024*32

@implementation UMDDecoder

+ (UMDDecoder *)getShareUMDDecoder
{
    static UMDDecoder *umdDecoder;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (umdDecoder == nil)
        {
            umdDecoder = [[UMDDecoder alloc] init];
        }
    });
    return umdDecoder;
}
- (id)init
{
    self = [super init];
    if (nil == self)
    {
        isStart = NO;
    }
    return self;
}
- (void)dealloc
{
    [super dealloc];
}
- (UMD *)getUMDFile:(NSString *)filePath
{
    NSString *fileName = [filePath lastPathComponent];
    
    NSData * umdData =[NSData dataWithContentsOfFile:filePath];
    Byte *umdByte = (Byte *)[umdData bytes];
    UMD *umd = [[UMD alloc] init];
    int currentIndex = 0;
    
    NSInteger header = [self getInt:umdByte + currentIndex];
    currentIndex += 4;
    if (header != -560292983)
    {
        NSLog(@"非UMD文件");
        [umd release];
        return nil;
    }
    [umd setHeader:header];
    
    BOOL flag = YES;
    NSInteger type;
    NSInteger size = 0;
    NSString *stringBuffer;
    
    //txt文件
    NSString *umdFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/umd"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:umdFolder] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:umdFolder withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *txtName;// = [NSString stringWithFormat:@"%@%@",[umd.title md5],@".txt"];//[umd.title md5]
    NSString *txtFilePath;// = [umdFolder stringByAppendingPathComponent:txtName];
    
    FILE *content = nil;// = fopen([txtFilePath UTF8String], "ab");
//    short Unicode = (short)0xFEFF;
//    fwrite(&Unicode,sizeof(short),1,content);
    //txt文件
    
    Byte funByte = umdByte[currentIndex];
    currentIndex++;
    while (flag)
    {
        switch (funByte)
        {
            case '#':
            {
                type = [self getUnsignShort:umdByte + currentIndex];
                currentIndex += 2;
                switch (type)
                {
                    case 1://类型
                    {
                        currentIndex += 2;
                        int umdType = umdByte[currentIndex];;
                        currentIndex ++;
                        [umd setUmdType:umdType];
                        
                        if (umdType != 1)
                        {
                            NSLog(@"It's not a text umd file!");
                            [umd release];
                            return nil;
                        }
                        currentIndex += 2;
                        break;
                    }
                    case 2://标题
                    {
                        currentIndex++;
                        size = umdByte[currentIndex];
                        currentIndex++;
                        
                        //NSMutableString *titleString = [[NSMutableString alloc] init];
                        NSMutableData *data = [[NSMutableData alloc] init];
                        for (int i = 0; i < (size - 5) / 2; i++)
                        {
                            [data appendBytes:umdByte + currentIndex + 1 length:1];
                            [data appendBytes:umdByte + currentIndex length:1];
                            currentIndex += 2;
                        }
                        stringBuffer = [self stringWithData:data];
                        [data release];

                        [umd setTitle:[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                        
                        //txt文件
                        txtName = [NSString stringWithFormat:@"%@%@",[[NSString stringWithFormat:@"%@%@",umd.title,fileName] md5],@".txt"];//[umd.title md5]
                        txtFilePath = [umdFolder stringByAppendingPathComponent:txtName];
                        
                        content = fopen([txtFilePath UTF8String], "ab");
                        short Unicode = (short)0xFEFF;
                        fwrite(&Unicode,sizeof(short),1,content);
                        //txt文件
                        break;
                    }
                    case 3://作者
                    {
                        currentIndex++;
                        size = umdByte[currentIndex];
                        currentIndex++;
                        
                        NSMutableData *data = [[NSMutableData alloc] init];
                        for (int i = 0; i < (size - 5) / 2; i++)
                        {
                            [data appendBytes:umdByte + currentIndex + 1 length:1];
                            [data appendBytes:umdByte + currentIndex length:1];
                            currentIndex += 2;
                        }
                        stringBuffer = [self stringWithData:data];
                        [data release];
                        
                        [umd setAuthor:[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

                        break;
                    }
                    case 4://年
                    {
                        currentIndex++;
                        size = umdByte[currentIndex];
                        currentIndex++;
                        
                        NSMutableData *data = [[NSMutableData alloc] init];
                        for (int i = 0; i < (size - 5) / 2; i++)
                        {
                            [data appendBytes:umdByte + currentIndex + 1 length:1];
                            [data appendBytes:umdByte + currentIndex length:1];
                            currentIndex += 2;
                        }
                        stringBuffer = [self stringWithData:data];
                        [data release];
                        
                        [umd setYear:[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

                        break;
                    }
                    case 5://月
                    {
                        currentIndex++;
                        size = umdByte[currentIndex];
                        currentIndex++;
                        
                        NSMutableData *data = [[NSMutableData alloc] init];
                        for (int i = 0; i < (size - 5) / 2; i++)
                        {
                            [data appendBytes:umdByte + currentIndex + 1 length:1];
                            [data appendBytes:umdByte + currentIndex length:1];
                            currentIndex += 2;
                        }
                        stringBuffer = [self stringWithData:data];
                        [data release];
                        
                        [umd setMonth:[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

                        break;
                    }
                    case 6://日
                    {
                        currentIndex++;
                        size = umdByte[currentIndex];
                        currentIndex++;
                        
                        NSMutableData *data = [[NSMutableData alloc] init];
                        for (int i = 0; i < (size - 5) / 2; i++)
                        {
                            [data appendBytes:umdByte + currentIndex + 1 length:1];
                            [data appendBytes:umdByte + currentIndex length:1];
                            currentIndex += 2;
                        }
                        stringBuffer = [self stringWithData:data];
                        [data release];
                        
                        [umd setDay:[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

                        break;
                    }
                    case 7://gender
                    {
                        currentIndex++;
                        size = umdByte[currentIndex];
                        currentIndex++;
                        
                        NSMutableData *data = [[NSMutableData alloc] init];
                        for (int i = 0; i < (size - 5) / 2; i++)
                        {
                            [data appendBytes:umdByte + currentIndex + 1 length:1];
                            [data appendBytes:umdByte + currentIndex length:1];
                            currentIndex += 2;
                        }
                        stringBuffer = [self stringWithData:data];
                        [data release];
                        
                        [umd setGender:[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

                        break;
                    }
                    case 8://出版商
                    {
                        currentIndex++;
                        size = umdByte[currentIndex];
                        currentIndex++;
                        
                        NSMutableData *data = [[NSMutableData alloc] init];
                        for (int i = 0; i < (size - 5) / 2; i++)
                        {
                            [data appendBytes:umdByte + currentIndex + 1 length:1];
                            [data appendBytes:umdByte + currentIndex length:1];
                            currentIndex += 2;
                        }
                        stringBuffer = [self stringWithData:data];
                        [data release];
                        
                        [umd setPublisher:[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

                        break;
                    }
                    case 9://Vendor
                    {
                        currentIndex++;
                        size = umdByte[currentIndex];
                        currentIndex++;
                        
                        NSMutableData *data = [[NSMutableData alloc] init];
                        for (int i = 0; i < (size - 5) / 2; i++)
                        {
                            [data appendBytes:umdByte + currentIndex + 1 length:1];
                            [data appendBytes:umdByte + currentIndex length:1];
                            currentIndex += 2;
                        }
                        stringBuffer = [self stringWithData:data];
                        [data release];
                        
                        [umd setVendor:[stringBuffer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];

                        break;
                    }
                    case 0x0b://长度
                    {
                        currentIndex += 2;
                        NSInteger length = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        [umd setContentLength:length / 2];

                        break;
                    }
                    case 0x83://章节偏移量
                    {
                        currentIndex += 2;
                        NSInteger random1 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        currentIndex ++;
                        NSInteger random2 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        if (random1 != random2)
                        {
                            NSLog(@"It's not a umd file!");
                            [umd release];
                            return nil;
                        }
                        NSInteger chapterNumber = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        [umd setChapterNumber:(chapterNumber - 9) / 4];

                       
                        NSMutableArray *offsets = [NSMutableArray arrayWithCapacity:[umd chapterNumber]];
                        
                        for (int i = 0; i < [umd chapterNumber]; i++)
                        {
                            NSInteger offset = [self getInt:umdByte + currentIndex];
                            currentIndex += 4;
                            [offsets addObject:[NSNumber numberWithInt:offset / 2]];
                        }
                        [umd setOffsets:offsets];
                        break;
                    }
                    case 0x84://章节名
                    {
                        currentIndex += 2;
                        NSInteger random1 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        currentIndex ++;
                        NSInteger random2 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        if (random1 != random2)
                        {
                            NSLog(@"It's not a umd file!");
                            [umd release];
                            return nil;
                        }
                        [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        NSMutableArray *chapterTitles = [NSMutableArray arrayWithCapacity:[umd chapterNumber]];
                        for (int i = 0; i < [umd chapterNumber]; i++)
                        {
                            NSInteger titleLength = umdByte[currentIndex];
                            currentIndex ++;
                            
                            NSMutableData *data = [[NSMutableData alloc] init];
                            for (int i = 0; i < titleLength / 2; i++)
                            {
                                [data appendBytes:umdByte + currentIndex + 1 length:1];
                                [data appendBytes:umdByte + currentIndex length:1];
                                currentIndex += 2;
                            }
                            NSString *chapterName = [self stringWithData:data];
                            [data release];
                            
                            [chapterTitles addObject:chapterName];
                            //NSLog(@"UmdchapterName: %@",chapterName);

                        }
                        [umd setChapterTitles:chapterTitles];
                        break;
                    }
                    case 0x81:
                    {
                        currentIndex += 2;
                        NSInteger random1 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        currentIndex ++;
                        NSInteger random2 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        if (random1 != random2)
                        {
                            NSLog(@"It's not a umd file!");
                            [umd release];
                            return nil;
                        }
                        NSInteger dataBlockNum = ([self getInt:umdByte + currentIndex] - 9) / 4;
                        currentIndex += 4;
                        currentIndex = currentIndex + (dataBlockNum * 4);

                        break;
                    }
                    case 0x82:
                    {
                        currentIndex += 3;
                        NSInteger random1 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        currentIndex ++;
                        NSInteger random2 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        if (random1 != random2)
                        {
                            NSLog(@"It's not a umd file!");
                            [umd release];
                            return nil;
                        }
                        NSInteger coverLength = [self getInt:umdByte + currentIndex] - 9;
                        currentIndex += 4;
                        NSData *coverImageData = [NSData dataWithBytes:umdByte + currentIndex length:coverLength];
                        currentIndex += coverLength;
                        
                        //图片存文件
                        NSString *umdFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/umd/image"];
                        //先要创建目录
                        if ([[NSFileManager defaultManager] fileExistsAtPath:umdFolder] == NO)
                        {
                            [[NSFileManager defaultManager] createDirectoryAtPath:umdFolder withIntermediateDirectories:YES attributes:nil error:nil];
                        }
                        
                        NSString *imagePath = [umdFolder stringByAppendingPathComponent:[[NSString stringWithFormat:@"%@%@",umd.title,fileName] md5]];//[umd.title md5]
                        if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath])
                        {
                            if ([coverImageData length] <= 1)
                            {
                                NSLog(@"error: coverImageData is null!");
                                [umd release];
                                return nil;
                            }
                            if([[NSFileManager defaultManager] createFileAtPath:imagePath contents:coverImageData attributes:nil])
                            {
                                NSLog(@"error:图片成功写入");
                            }
                            else
                            {
                                NSLog(@"error:图片失败写入");
                            }
                        }
                        //图片存文件
                        
                        //[umd setCovers:coverImageData];//占用内存
                        [umd setCoverPath:imagePath];
                        break;
                    }
                    case 0x87:
                    {
                        currentIndex += 4;
                        NSInteger random1 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        currentIndex ++;
                        NSInteger random2 = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        if (random1 != random2)
                        {
                            NSLog(@"It's not a umd file!");
                            [umd release];
                            return nil;
                        }
                        NSInteger offsetLength = [self getInt:umdByte + currentIndex] - 9;
                        currentIndex += 4;
                        currentIndex += offsetLength;
                        break;
                    }
                    case 0x0a:
                    {
                        currentIndex += 2;
                        NSInteger contentId = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        [umd setContentId:contentId];
                        break;
                    }
                    case 0x0c://完成
                    {
                        currentIndex += 2;
                        NSInteger fileSize = [self getInt:umdByte + currentIndex];
                        currentIndex += 4;
                        [umd setFileSize:fileSize];
                        
                        fclose(content);
                        [umd setTxtFilePath:txtFilePath];
                        flag = NO;
                        continue;
                    }
                    case 0xf1:
                    {
                        currentIndex += 2;
                        currentIndex += 16;
                        break;
                    }
                    default:
                    {
                        flag = false;
                        break;
                    }
                }
                break;
            }
                
            case 0x24:
            {
                
                currentIndex += 4;
                NSInteger dataLength = [self getInt:umdByte + currentIndex] - 9;
                currentIndex += 4;
                //NSData *contentData = [NSData dataWithBytes:umdByte + currentIndex length:dataLength];
                //currentIndex += dataLength;
                
                
                unsigned long deslen = MAXBUFFERSIZE;
                Byte BUFFER[MAXBUFFERSIZE];
                if (Z_OK == uncompress(BUFFER,&deslen,umdByte + currentIndex,dataLength))
                {
                    //EntelFilter(BUFFER,deslen);
                    unsigned short* A = (unsigned short*)BUFFER;
                    for (int i=0;i<dataLength/2;i++)
                    {
                        if (*(A+i) == 0x2029)
                        {
                            *(A+i) = 0x0D;
                        }
                    }
                    fwrite(BUFFER,1,deslen,content);
                }
                else
                {
                    NSLog(@"failed to uncompress！");
                    return nil;
                }

                
                currentIndex += dataLength;
                
                break;
            }
            default:
            {
                flag = false;
                break;
            }
        }
        funByte = umdByte[currentIndex];
        currentIndex++;
    }
    return [umd autorelease];
}

- (NSString *)stringWithData:(NSData *)data
{
     NSString *content = [[NSString alloc] initWithData:data encoding:NSUnicodeStringEncoding];
     return [content autorelease];
 }
                         
- (NSInteger)getInt:(Byte[]) b
{
    NSInteger s = 0;
    for (NSInteger i = 0; i < 3; i++)
    {
        if (b[3-i] >= 0)
        {
            s = s + b[3-i];
        } else
        {
            s = s + 256 + b[3-i];
        }
        s = s * 256;
    }
    if (b[0] >= 0)
    {
        s = s + b[0];
    }
    else
    {
        s = s + 256 + b[0];
    }
    return s;
}
- (NSInteger)getUnsignShort:(Byte[]) b
{
    NSInteger s = 0;
    if (b[1] >= 0)
    {
        s = s + b[1];
    }
    else
    {
        s = s + 256 + b[1];
    }
    s = s * 256;
    if (b[0] > 0)
    {
        s = s + b[0];
    }
    else
    {
        s = s + 256 + b[0];
    }
    return s;
}
- (char)getChar:(Byte[])b
{
    int ch2 = b[0];
    int ch1 = b[1];
    return (char) ((ch1 << 8) + (ch2 << 0));
}

@end
