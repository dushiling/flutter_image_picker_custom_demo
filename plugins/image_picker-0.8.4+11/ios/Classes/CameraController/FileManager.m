//
//  FileManager.m
//  Runner
//
//  Created by Macos on 2019/10/24.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

/***图片存储到本地Document目录下，ImageName是图片的唯一标识符*/

+(NSString *)storeImage:(NSData *)imageData withImageName:(NSString *)ImageName {

    if (imageData && ImageName.length > 0 && ImageName) {
        NSFileManager *fileManage=[NSFileManager defaultManager];
        //把图片存储在沙盒中，首先获取沙盒路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
        //在Documents下面创建一个Image的文件夹的路径
        NSString *createPath=[NSString stringWithFormat:@"%@/Images",documentsDirectory];
        //没有这个文件夹的话就创建这个文件夹
        if(![fileManage fileExistsAtPath:createPath]){
            [fileManage createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
            NSLog(@"已创建文件夹");
        }
        //把数据以.jpg的形式存储在沙盒中，路径为可变路径
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.jpg",createPath,ImageName];
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:imageData attributes:nil];
         NSLog(@"%@",filePath);
        return filePath;
    }
    return @"";
}


+(NSData *)getImageWithImageName:(NSString *)ImageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSString *filePath = [NSString stringWithFormat:@"%@/Images/%@.jpg",documentsDirectory,ImageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *imageData;
    //如果存在存储图片的文件，则根据路径取出图片
    if ([fileManager fileExistsAtPath:filePath]) {
        imageData = [NSData dataWithContentsOfFile:filePath];
    }
    return imageData;
}


+(BOOL)deleteImageWithImageName:(NSString *)imageName{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSString *filePath = [NSString stringWithFormat:@"%@/Images/%@.jpg",documentsDirectory,imageName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}

+(BOOL)deletePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];//Documents目录
    NSString *filePath = [NSString stringWithFormat:@"%@/Images",documentsDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filePath error:nil];
}

@end
