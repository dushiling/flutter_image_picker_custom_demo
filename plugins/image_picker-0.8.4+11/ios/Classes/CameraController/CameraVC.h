//
//  CameraVC.h
//  Runner
//
//  Created by Macos on 2019/8/5.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ImageBlock)(UIImage *image);
@interface CameraVC : UIViewController
@property (nonatomic, copy) ImageBlock imageblock;
@property (nonatomic,assign) BOOL isNew;   //新款身份证
@property (nonatomic,assign) BOOL isBack; //背面
@property (nonatomic,assign) BOOL isHandWithCard; //手持身份证
-(void)dismissView;
@end

NS_ASSUME_NONNULL_END
