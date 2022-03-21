//
//  CameraVC.m
//  Runner
//
//  Created by Macos on 2019/8/5.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "CameraVC.h"
#import <Photos/Photos.h>


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//屏幕size
#define kScreenS [UIScreen mainScreen].bounds.size
//屏幕宽度
#define kScreenW [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kScreenH [UIScreen mainScreen].bounds.size.height
//字体适配
#define ADAPTFOUNT_SIZE(size) KIS_iPhone_6 ? size : ((KIS_iPhone_6Plus || KIS_iPhoneXSerie)? size + floor(size / 10) : size - floor(size / 10))
//宽度适配
#define ADAPTFOUNT_WIDTH(width) (kScreenW/375.0)*width
//高度适配
#define ADAPTFOUNT_HEIGHT(height) (kScreenH/677.0)*height


#pragma mark ============= WEAKSELF STRONGSELF =============
#define WEAKSELF __weak typeof(self) weakSelf = self;
#define STRONGSELF __strong typeof(weakSelf) strongSelf = weakSelf;


#pragma mark ============= 机型 =============
//判断是否是ipad
#define KIS_Pad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define KIS_iPhone_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !KIS_Pad : NO)
//判断iPhone5系列
#define KIS_iPhone_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !KIS_Pad : NO)
//判断iPhone6系列
#define KIS_iPhone_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !KIS_Pad : NO)
//判断iphone6+系列
#define KIS_iPhone_6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !KIS_Pad : NO)
//判断iPhoneX
#define KIS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !KIS_Pad : NO)
//判断iPHoneXr
#define KIS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !KIS_Pad : NO)
//判断iPhoneXs
#define KIS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !KIS_Pad : NO)
//判断iPhoneXs Max
#define KIS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !KIS_Pad : NO)
//判断是否为 iPhoneXS  Max，iPhoneXS，iPhoneXR，iPhoneX
//#define KIsiPhoneX ((int)((kScreenH/kScreenW)*100) == 216)?YES:NO
#define KIS_iPhoneXSerie (KIS_IPHONE_X || KIS_IPHONE_Xr || KIS_IPHONE_Xs || KIS_IPHONE_Xs_Max)?YES:NO

//iPhoneX系列  navBar和tabBar的判断
#define Height_StatusBar ((KIS_IPHONE_X == YES || KIS_IPHONE_Xr == YES || KIS_IPHONE_Xs == YES || KIS_IPHONE_Xs_Max == YES) ? 44.0 : 20.0)
#define Height_NavBar ((KIS_IPHONE_X == YES || KIS_IPHONE_Xr == YES || KIS_IPHONE_Xs == YES || KIS_IPHONE_Xs_Max == YES) ? 88.0 : 64.0)
#define Height_TabBar ((KIS_IPHONE_X == YES || KIS_IPHONE_Xr == YES || KIS_IPHONE_Xs == YES || KIS_IPHONE_Xs_Max == YES) ? 83.0 : 49.0)


@interface CameraVC ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate,CAAnimationDelegate>

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;
//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
//输出
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
//设备
@property (nonatomic, strong)AVCaptureDevice *deveice;
//拍照
@property (nonatomic, strong) UIButton *PhotoButton;
//取消
@property (nonatomic, strong) UIButton *cancleButton;
//切换摄像头
@property (nonatomic, strong) UIButton *changeButton;
//确定选择当前照片
@property (nonatomic, strong) UIButton *selectButton;
//重新拍照
@property (nonatomic, strong) UIButton *reCamButton;
//闪光灯
@property (nonatomic, strong) UIButton *flashButton;
//取消返回
@property (nonatomic, strong) UIButton *backButton;
//照片加载视图
@property (nonatomic, strong) UIImageView *imageView;
//对焦区域
@property (nonatomic, strong) UIImageView *focusView;
//上方功能区
@property (nonatomic, strong) UIView *topView;
//下方功能区
@property (nonatomic, strong) UIView *bottomView;
//拍到的照片
@property (nonatomic, strong) UIImage *image;
//照片的信息
@property (nonatomic, strong) NSDictionary *imageDict;
//是否可以拍照
@property (nonatomic, assign) BOOL canCa;
//是否打开闪光灯
@property (nonatomic, assign) BOOL torchIsOn;
//闪光灯模式
@property (nonatomic, assign) AVCaptureFlashMode flahMode;
//前后摄像头
@property (nonatomic, assign) AVCaptureDevicePosition cameraPosition;

@property (nonatomic, strong) UIImageView *kuangImgView;//橘色边框

@property (nonatomic, strong) UILabel *tishiLabel;//提示字
@property(nonatomic,strong) UIView *backImageView; //背景色
//@property(nonatomic,strong) UIImageView *squareImageView; //方框

@end
CGFloat cardW = 0.0;
CGFloat cardH = 0.0;
@implementation CameraVC


#pragma mark - 上方功能区
-(UIView *)topView{
    if (!_topView ) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Height_NavBar)];
        [_topView addSubview:self.cancleButton];
    }
    return _topView;
}
#pragma mark - 取消
-(UIButton *)cancleButton{
    if (_cancleButton == nil) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(ScreenWidth-40, Height_NavBar-40, 30, 30);
        [_cancleButton setImage:[UIImage imageNamed:@"cameraClose"] forState:(UIControlStateNormal)];
        [_cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
        _cancleButton.alpha=0;
    }
    return  _cancleButton ;
}

//退出
-(void)dismissView{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - 下方功能区

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-80, ScreenWidth, 80)];
//        _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [_bottomView addSubview:self.reCamButton];
        [_bottomView addSubview:self.PhotoButton];
        [_bottomView addSubview:self.selectButton];

        [_bottomView addSubview:self.flashButton];
        [_bottomView addSubview:self.backButton];
    }
    return _bottomView;
}
-(UIButton *)reCamButton{
    if (_reCamButton == nil) {
        _reCamButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reCamButton.frame = CGRectMake(40, 10, 40, 40);
        [_reCamButton addTarget:self action:@selector(reCam) forControlEvents:UIControlEventTouchUpInside];
        [_reCamButton setImage:[UIImage imageNamed:@"cameraResultCancel"] forState: UIControlStateNormal];
        _reCamButton.transform = CGAffineTransformMakeRotation(M_PI/2);
        [_reCamButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _reCamButton.alpha = 0;
    }
    return _reCamButton;
}
-(UIButton *)PhotoButton{
    if (_PhotoButton == nil) {
        _PhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _PhotoButton.frame = CGRectMake(ScreenWidth/2.0-30,  10, 60, 60);
        [_PhotoButton setImage:[UIImage imageNamed:@"cameraTake"] forState: UIControlStateNormal];
        [_PhotoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PhotoButton;
}
-(UIButton *)selectButton{
    if (_selectButton == nil) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(ScreenWidth-70, 10, 40, 40);
        [_selectButton addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
        [_selectButton setImage:[UIImage imageNamed:@"cameraResultOk"] forState: UIControlStateNormal];
        _selectButton.transform=CGAffineTransformMakeRotation(M_PI/2);
        [_selectButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _selectButton.alpha = 0;
    }
    return _selectButton;
}
-(UIButton *)flashButton{
    if (_flashButton == nil) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashButton.frame = CGRectMake(ScreenWidth-70, 10, 40, 40);
        [_flashButton addTarget:self action:@selector(reCam) forControlEvents:UIControlEventTouchUpInside];
        [_flashButton setImage:[UIImage imageNamed: self.torchIsOn == YES? @"cameraFlashOn":@"cameraFlashOff"] forState: UIControlStateNormal];
        _flashButton.transform = CGAffineTransformMakeRotation(M_PI/2);
        [_flashButton addTarget:self action:@selector(turnTorchOn) forControlEvents:UIControlEventTouchUpInside];
        _flashButton.alpha = 1;
    }
    return _flashButton;
}
-(UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(40, 10, 40, 40);
        [_backButton addTarget:self action:@selector(reCam) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:[UIImage imageNamed:@"cameraClose"] forState: UIControlStateNormal];
        _backButton.transform = CGAffineTransformMakeRotation(M_PI/2);
        [_backButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];

        _backButton.alpha = 1;
    }
    return _backButton;
}
#pragma mark - 加载照片的视图
-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];

        //这里要注意，图片填充方式的选择让图片不要变形了

        [_imageView setContentMode:UIViewContentModeScaleAspectFill];

        _imageView.clipsToBounds = YES;

        _imageView.image = _image;
    }
    return _imageView;
}
#pragma mark - 对焦区域
-(UIImageView *)focusView{
    if (_focusView == nil) {
        _focusView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.image = [UIImage imageNamed:@"foucs"];
        _focusView.hidden = YES;
    }
    return _focusView;
}

- (UIImageView *)kuangImgView {
    if (_kuangImgView == nil) {
        _kuangImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  cardW, cardH)];
        _kuangImgView.center = self.view.center;
        _kuangImgView.image = [UIImage imageNamed:self.isBack == true?@"cameraIdcardBack":@"cameraIdcardFront"];
}
    return _kuangImgView;
}

- (UILabel *)tishiLabel {

    if (_tishiLabel == nil) {
        _tishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(-(ScreenWidth*0.5)/2+30, ScreenHeight/2, ScreenWidth*0.5, 30)];
//        _tishiLabel.center = self.view.center;
        _tishiLabel.text = @"Touch screen focusing";
        _tishiLabel.textColor = [UIColor grayColor];
        _tishiLabel.numberOfLines = 0;
        _tishiLabel.textAlignment = NSTextAlignmentCenter;
        _tishiLabel.font = [UIFont systemFontOfSize:17];
        _tishiLabel.transform = CGAffineTransformMakeRotation(M_PI_2);

    }

    return _tishiLabel;
}

-(UIView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _backImageView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _backImageView;
}

#pragma mark - 使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        _previewLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return  _previewLayer;
}
-(AVCaptureStillImageOutput *)ImageOutPut{
    if (_ImageOutPut == nil) {
        _ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    }
    return _ImageOutPut;
}
#pragma mark - 初始化输入
-(AVCaptureDeviceInput *)input{
    if (_input == nil) {

        _input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    }
    return _input;
}
#pragma mark - 初始化输出
-(AVCaptureMetadataOutput *)output{
    if (_output == nil) {

        _output = [[AVCaptureMetadataOutput alloc]init];
    }
    return  _output;
}
#pragma mark - 使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
-(AVCaptureDevice *)device{
    if (_device == nil) {

        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

#pragma mark - 当前视图控制器的初始化
- (instancetype)init
{
    self = [super init];
    if (self) {
        _canCa = [self canUserCamear];
    }
    return self;
}

#pragma mark - 检查相机权限
- (BOOL)canUserCamear{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}
#pragma mark - 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor clearColor];
    self.torchIsOn=false;

    cardW = ADAPTFOUNT_WIDTH(265.0);
//    cardH = ADAPTFOUNT_HEIGHT(431.0);
    cardH = ((ADAPTFOUNT_WIDTH(265.0)) * (431.0/265.0));
    if (_canCa) {
        [self customCamera];
        [self customUI];
    }else{
        return;
    }

//    if (self.isNew == NO) {
//        self.kuangImgView.image = [UIImage imageNamed:@"square"];
//    }
}
#pragma mark - 自定义视图
- (void)customUI {
    if (self.isBack == true) {
        //背面
        [self.view addSubview:self.backImageView];
        [self.view addSubview:self.kuangImgView];
        [self.view addSubview:self.topView];
        [self.view addSubview:self.bottomView];
        [self.backImageView addSubview:self.tishiLabel];
//        [self.view addSubview:self.focusView];
    }else if (self.isHandWithCard == true) {
        //手持身份证
        [self.view addSubview:self.topView];
        [self.view addSubview:self.bottomView];
        [self.view addSubview:self.focusView];

    }else{
        //正面
        [self.view addSubview:self.backImageView];
        [self.view addSubview:self.kuangImgView];
        [self.view addSubview:self.topView];
        [self.view addSubview:self.bottomView];
        [self.backImageView addSubview:self.tishiLabel];
//        [self.view addSubview:self.focusView];
    }

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];

    //抠掉中间区域透明
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenW, kScreenH)];
    [path appendPath:[[UIBezierPath bezierPathWithRect:self.kuangImgView.frame] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.backImageView.layer setMask:shapeLayer];
}
#pragma mark - 自定义相机
- (void)customCamera{

    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }

    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }

    [self.view.layer addSublayer:self.previewLayer];

    //开始启动
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }

        [self.device unlockForConfiguration];
    }

}

#pragma mark - 聚焦
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1-point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {

        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }

        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }

        [self.device unlockForConfiguration];
        self.focusView.center = point;
        _focusView.hidden = NO;

        //        self.focusView.alpha = 1;
        [UIView animateWithDuration:0.2 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25f, 1.25f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                self.focusView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                [self hiddenFocusAnimation];
            }];
        }];
    }

}
#pragma mark - 拍照
- (void)shutterCamera
{

    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        return;
    }

    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];

        self.imageDict = @{@"image":self.image,@"info":@{@"PHImageFileUTIKey":@".jpeg"}};
        [self.session stopRunning];

        if (self.isHandWithCard == true) {
            [self.view insertSubview:self.imageView belowSubview:self.topView];
        }else{
            [self.view insertSubview:self.imageView belowSubview:self.backImageView];
        }
        NSLog(@"image size = %@",NSStringFromCGSize(self.image.size));
        self.cancleButton.alpha = 1;
        self.PhotoButton.alpha = 0;
        self.kuangImgView.alpha = 0;
        self.tishiLabel.alpha = 0;
        self.reCamButton.alpha = 1;
        self.selectButton.alpha = 1;
        self.flashButton.alpha=0;
        self.backButton.alpha=0;
        _backImageView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    }];
}
//-
#pragma - 保存至相册
- (void)saveImageToPhotoAlbum:(UIImage*)savedImage
{

    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);

}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if(error != NULL){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                        message:@"保存图片失败"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
//-
#pragma mark - 取消 返回上级
-(void)cancle{
    [self.imageView removeFromSuperview];
    [self.session stopRunning];
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {

        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

        if([[UIApplication sharedApplication] canOpenURL:url]) {

            [[UIApplication sharedApplication] openURL:url];

        }
    }
}
#pragma mark - 重新拍照
- (void)reCam{
    self.imageView.image = nil;
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    self.cancleButton.alpha = 0;
    self.PhotoButton.alpha = 1;
    self.kuangImgView.alpha = 1;
    self.tishiLabel.alpha = 1;
    self.reCamButton.alpha = 0;
    self.selectButton.alpha = 0;
    self.flashButton.alpha = 1;
    self.backButton.alpha = 1;
    _backImageView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

//#warning 这里是重点

#pragma mark - 选择照片 返回上级
- (void)selectImage{

    UIImage *image1 = self.image;

    CGImageRef cgRef = image1.CGImage;

    CGFloat widthScale = image1.size.width / ScreenWidth;
    CGFloat heightScale = image1.size.height / ScreenHeight;

    //其实是横屏的
    //多减掉50是因为最后的效果图片的高度有偏差，不知道原因
    CGFloat orignWidth = cardW-50;//226
    CGFloat orginHeight = cardH;//360

    //我们要裁剪出实际边框内的图片，但是实际的图片和我们看见的屏幕上的img，size是不一样，可以打印一下image的size看看起码好几千的像素，要不然手机拍的照片怎么都是好几兆的呢？
    CGFloat x = (ScreenHeight - orginHeight) * 0.5 * heightScale;
    CGFloat y = (ScreenWidth - orignWidth) * 0.5 * widthScale;
    CGFloat width = orginHeight * heightScale;
    CGFloat height = orignWidth * widthScale;

    CGRect r = CGRectMake(x, y, width, height);

    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, r);

    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    //
    image1 = thumbScale;

    self.image = image1;

    //返回的时候把图片传回去
    if (self.imageblock) {
        self.imageblock(self.image);
    }

    [self dismissView];

}


- (void)focusDidFinsh{
    self.focusView.hidden = YES;
    self.focusView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
}

- (void)startFocusAnimation{
    self.focusView.hidden = NO;
    self.focusView.transform = CGAffineTransformMakeScale(1.25f, 1.25f);//将要显示的view按照正常比例显示出来
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];

    [UIView setAnimationDidStopSelector:@selector(hiddenFocusAnimation)];
    [UIView setAnimationDuration:0.5f];//动画时间
    self.focusView.transform = CGAffineTransformIdentity;//先让要显示的view最小直至消失
    [UIView commitAnimations]; //启动动画
    //相反如果想要从小到大的显示效果，则将比例调换

}
- (void)hiddenFocusAnimation{
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];

    [UIView setAnimationDelay:3];
    self.focusView.alpha = 0;
    [UIView setAnimationDuration:0.5f];//动画时间
    [UIView commitAnimations];

}
- (void)hiddenFoucsView{
    self.focusView.alpha = !self.focusView.alpha;
}

- (void) turnTorchOn {

Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
if (captureDeviceClass != nil) {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){

        [device lockForConfiguration:nil];
        if ( self.torchIsOn==false) {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
            self.torchIsOn = YES;
            [_flashButton setImage:[UIImage imageNamed: @"cameraFlashOn"] forState: UIControlStateNormal];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
            self.torchIsOn = NO;
            [_flashButton setImage:[UIImage imageNamed: @"cameraFlashOff"] forState: UIControlStateNormal];
        }
        [device unlockForConfiguration];
    }
}
}



@end
