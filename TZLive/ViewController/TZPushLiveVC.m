//
//  TZPushLiveVC.m
//  TZLive
//
//  Created by Xin Chen on 17/2/15.
//  Copyright © 2017年 重庆香樟树. All rights reserved.
//

#import "TZPushLiveVC.h"

@interface TZPushLiveVC ()<LFLiveSessionDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *liveViewW;
//推流地址
@property (weak, nonatomic) IBOutlet UITextField *rtmpUrl;
//美颜状态描述
@property (weak, nonatomic) IBOutlet UILabel *beautifulLB;
//摄像头状态描述
@property (weak, nonatomic) IBOutlet UILabel *cameraLB;
//直播按钮
@property (weak, nonatomic) IBOutlet UIButton *liveBtn;
//直播状态描述
@property (weak, nonatomic) IBOutlet UITextView *stautsTextView;
//直播画面
@property (weak, nonatomic) IBOutlet UIView *liveView;

@property (weak, nonatomic) IBOutlet UIView *PullView;
/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;


@property (nonatomic, strong) LFLiveSession *session;
@end

@implementation TZPushLiveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //开启后置摄像头
    self.session.captureDevicePosition = AVCaptureDevicePositionBack;
    
    _liveViewW.constant = _liveView.bounds.size.height  * 320 / 568;
}

- (LFLiveSession*)session{
    if(!_session){
//        /**    自己定制高质量音频128K 分辨率设置为720*1280 方向竖屏 */
//        
//        LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
//        audioConfiguration.numberOfChannels = 2;
//        audioConfiguration.audioBitrate = LFLiveAudioBitRate_128Kbps;
//        audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
//        
//        LFLiveVideoConfiguration *videoConfiguration = [LFLiveVideoConfiguration new];
//        videoConfiguration.videoSize = CGSizeMake(720, 1280);
//        videoConfiguration.videoBitRate = 800*1024;
//        videoConfiguration.videoMaxBitRate = 1000*1024;
//        videoConfiguration.videoMinBitRate = 500*1024;
//        videoConfiguration.videoFrameRate = 30;
//        videoConfiguration.videoMaxKeyframeInterval = 60;
//        videoConfiguration.outputImageOrientation = UIInterfaceOrientationPortrait;
//        videoConfiguration.sessionPreset = LFCaptureSessionPreset720x1280;
//        
//        
//       
//        _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:videoConfiguration];
        
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfigurationForQuality:LFLiveAudioQuality_VeryHigh]  videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_High3]];
        
        // 设置代理
        _session.delegate = self;
        _session.running = YES;
        _session.beautyFace = NO;
        _session.preView = self.liveView;
        _session.showDebugInfo = YES;
        [_session.preView setBounds:self.liveView.bounds];
    }
    return _session;
}
#pragma mark -- LFStreamingSessionDelegate
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSString *tempStatus;
    switch (state) {
        case LFLiveReady:
            tempStatus = @"准备中";
            break;
        case LFLivePending:
            tempStatus = @"连接中";
            break;
        case LFLiveStart:
            tempStatus = @"已连接";
            [self.liveBtn setTitle:@"结束直播" forState:UIControlStateNormal];
            break;
        case LFLiveStop:
            tempStatus = @"已断开";
            [self.liveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
            break;
        case LFLiveError:
            tempStatus = @"连接出错";
            [self.liveBtn setTitle:@"开始直播" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    //音频
    NSString *audio = [NSString stringWithFormat:@"音频声道数：%ld", self.session.streamInfo.audioConfiguration.numberOfChannels];
    NSString *audioRate = [NSString stringWithFormat:@"音频采样率：%lu", (unsigned long)self.session.streamInfo.audioConfiguration.audioSampleRate];
    NSString *audioBitrate = [NSString stringWithFormat:@"音频码率：%lu", (unsigned long)self.session.streamInfo.audioConfiguration.audioBitrate];
    //视频
    NSString *videoSize = [NSString stringWithFormat:@"视频分辨率：%.0f x %.0f", self.session.streamInfo.videoConfiguration.videoSize.width,self.session.streamInfo.videoConfiguration.videoSize.height];
    NSString *videoFrameRate = [NSString stringWithFormat:@"视频的帧率：%ld", self.session.streamInfo.videoConfiguration.videoFrameRate];
    NSString *videoBitRate = [NSString stringWithFormat:@"视频码率：%ld", self.session.streamInfo.videoConfiguration.videoBitRate];
    NSString *sessionPreset = [NSString stringWithFormat:@"分辨率：%lu", (unsigned long)self.session.streamInfo.videoConfiguration.sessionPreset];

    self.stautsTextView.text = [NSString stringWithFormat:@"状态: %@\n推流地址: %@\n%@\n%@\n%@\n%@\n%@\n%@\n%@", tempStatus, self.rtmpUrl.text,audio,audioRate,audioBitrate,videoSize,videoFrameRate,videoBitRate ,sessionPreset];
    
    
    
}
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug *)debugInfo{
    NSLog(@"%@", debugInfo);
}

//美颜开关
- (IBAction)beautifulSW:(UISwitch *)sender {
    if (sender.on){
        self.session.beautyFace = YES;
        self.beautifulLB.text = @"美颜开关：开";
    }else{
        self.session.beautyFace = NO;
        self.beautifulLB.text = @"美颜开关：关";
    }
}
//摄像头切换开关
- (IBAction)cameraSW:(UISwitch *)sender {
    
    if (sender.on) {
        self.session.captureDevicePosition = AVCaptureDevicePositionFront;
        self.cameraLB.text = @"摄像头切换：前";
    }else{
        self.session.captureDevicePosition = AVCaptureDevicePositionBack;
        self.cameraLB.text = @"摄像头切换：后";
    }
    
}
//直播按钮点击事件
- (IBAction)liveBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) { // 开始直播
        
        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
        // 如果是跟我blog教程搭建的本地服务器, 记得填写你电脑的IP地址
        stream.url = self.rtmpUrl.text;
        
        [self.session startLive:stream];
    }else{
        [self.session stopLive];
        
    }
    
}
//退出直播事件
- (IBAction)outBtn:(UIButton *)sender {
    if (self.session.state == LFLivePending || self.session.state == LFLiveStart){
        [self.session stopLive];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)PullBtn:(UIButton *)sender {
    IJKFFOptions *option = [IJKFFOptions optionsByDefault];
    [option setPlayerOptionValue:@"1" forKey:@"an"];
    // 开启硬解码
    [option setPlayerOptionValue:@"1" forKey:@"videotoolbox"];
    [option setFormatOptionIntValue:1  forKey:@"reconnect"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.rtmpUrl.text withOptions:option];
    
    moviePlayer.view.frame = self.PullView.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放
    moviePlayer.shouldAutoplay = YES;
    
    [self.PullView addSubview:moviePlayer.view];
    
    [moviePlayer prepareToPlay];
    self.moviePlayer = moviePlayer;
    
}

@end
