//
//  FileManager.h
//  Runner
//
//  Created by Macos on 2019/10/24.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileManager : NSObject
/*** 存储图片到本地*/
+(NSString *)storeImage:(NSData *)imageData withImageName:(NSString *)ImageName;

/*** 获取本地图片*/
+(NSData *)getImageWithImageName:(NSString *)ImageName;

/*** 删除本地图片*/
+(BOOL)deleteImageWithImageName:(NSString *)imageName;

/*** 删除路径*/
+(BOOL)deletePath;

@end

NS_ASSUME_NONNULL_END
