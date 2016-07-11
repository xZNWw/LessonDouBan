//
//  ViewController.m
//  LessonSenior_16_音乐播放器
//
//  Created by lanou3g on 16/4/25.
//  Copyright © 2016年 邢晓伟. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "MusicInfo.h"
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

// 播放类型
typedef enum musicPlayState{
    MusicPlayStateOrder, // 顺序播放
    MusicPlayStateRandom, // 随机播放
    MusicPlayStateSingleCycle, // 单曲循环
}MusicPlayState;


@interface ViewController ()<AVAudioPlayerDelegate>

/**
 *  音乐播放器主体：支持本地音源播放的播放器
 *  具有良好的控制性能，支持绝大多数音频格式。
 */
@property (strong,nonatomic) AVAudioPlayer *player;

/**
 *  存放Model的容器
 */
@property (strong,nonatomic) NSMutableArray *musicArray;
// 播放列表
@property (strong,nonatomic) NSMutableArray *musicList;
// 控件
@property (strong,nonatomic) UIImageView *backImageView; // 模糊背景
@property (strong,nonatomic) UIImageView *albumImageView; // 专辑图片
@property (strong,nonatomic) UISlider *progressView; // 音乐进度条
@property (strong,nonatomic) UILabel *leftLabel; // 左侧时间label
@property (strong,nonatomic) UILabel *rightLabel; // 右侧时间label
@property (strong,nonatomic) UILabel *nameLabel; // 歌曲名称label
@property (strong,nonatomic) UILabel *albumLabel;// 专辑名称label
@property (strong,nonatomic) NSTimer *timer;

// 音乐是否播放
@property BOOL isPlaying;
// 播放方式
@property MusicPlayState state;
// 当前播放的音乐
@property (strong,nonatomic) MusicInfo *music;
@property (strong,nonatomic) UIButton *button;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 解析数据
    NSString *path = [[NSBundle mainBundle]pathForResource:@"MusicList.plist" ofType:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    self.musicArray = [NSMutableArray arrayWithCapacity:8];
    for ( NSDictionary *dict in array) {
        MusicInfo *music = [MusicInfo new];
        [music setValuesForKeysWithDictionary:dict];
        [self.musicArray addObject:music];
    }
    
    // UI布局 (不传数据)
    // 背景模糊图
    self.backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.backImageView];
    
    // 专辑
#define kAlbumCenterX KScreenWidth/2
#define kAlbumCenterY KScreenHeight*0.3
#define kAlbumSide (KScreenWidth - 100)
    self.albumImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kAlbumSide, kAlbumSide)];
    self.albumImageView.center = CGPointMake(kAlbumCenterX, kAlbumCenterY);
    self.albumImageView.layer.cornerRadius = kAlbumSide/2;
    self.albumImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.albumImageView];
    
    // 模糊效果
#define kEffectOrigionY KScreenHeight * 0.6
#define kEffectHeight KScreenHeight * 0.4
    // 模糊效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    // 模糊视图
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    // 大小必须得给
    visualEffectView.frame = CGRectMake(0, kEffectOrigionY, KScreenWidth, KScreenHeight);
    [self.view addSubview:visualEffectView];
    
    // 进度条
    self.progressView = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 34)];
    self.progressView.center = CGPointMake(KScreenWidth/2, kEffectOrigionY);
    [self.progressView setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    self.progressView.minimumTrackTintColor = [UIColor magentaColor];
    [self.progressView addTarget:self action:@selector(makeProgress:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.progressView];
    
    // 时间label
    self.leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 60, 15)];
    self.leftLabel.font = [UIFont systemFontOfSize:15];
    self.leftLabel.text = @"0:00";
    [visualEffectView addSubview:self.leftLabel];
    
    self.rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 70, 20, 60, 15)];
    self.rightLabel.font = [UIFont systemFontOfSize:15];
    self.rightLabel.text = @"9:99";
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [visualEffectView addSubview:self.rightLabel];
    
    // 歌曲信息
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.nameLabel.center = CGPointMake(KScreenWidth/2, 40);
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.font = [UIFont systemFontOfSize:20];
    [visualEffectView addSubview:self.nameLabel];
    
    self.albumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 100, 15)];
    self.albumLabel.center = CGPointMake(KScreenWidth/2, 60);
    self.albumLabel.font = [UIFont systemFontOfSize:15];
    self.albumLabel.textAlignment = NSTextAlignmentCenter;
    [visualEffectView addSubview:self.albumLabel];
    
    // 按钮
    // 上一首
    UIButton *lastMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    lastMusic.frame = CGRectMake(0, 0, 30, 30);
    lastMusic.center = CGPointMake(KScreenWidth/2-100, CGRectGetMaxY(self.albumLabel.frame) + 40);
    [lastMusic setImage:[UIImage imageNamed:@"rewind"] forState:UIControlStateNormal];
    [lastMusic setImage:[UIImage imageNamed:@"rewind_h"] forState:UIControlStateHighlighted];
    [lastMusic addTarget:self action:@selector(lastMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    [visualEffectView addSubview:lastMusic];
    
    // 播放/暂停
    UIButton *playOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button = playOrPause;
    playOrPause.frame = CGRectMake(0, 0, 30, 30);
    playOrPause.center = CGPointMake(KScreenWidth/2, CGRectGetMaxY(self.albumLabel.frame) + 40);
    [playOrPause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playOrPause setImage:[UIImage imageNamed:@"play_h"] forState:UIControlStateHighlighted];
    [playOrPause addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    [visualEffectView addSubview:playOrPause];
    
    // 下一首
    UIButton *nextMusic = [UIButton buttonWithType:UIButtonTypeCustom];
    nextMusic.frame = CGRectMake(0, 0, 30, 30);
    nextMusic.center = CGPointMake(KScreenWidth/2+100, CGRectGetMaxY(self.albumLabel.frame) + 40);
    [nextMusic setImage:[UIImage imageNamed:@"forward"] forState:UIControlStateNormal];
    [nextMusic setImage:[UIImage imageNamed:@"forward_h"] forState:UIControlStateHighlighted];
    [nextMusic addTarget:self action:@selector(nextMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    [visualEffectView addSubview:nextMusic];
    
    // 音量
    UISlider *volumeSlider = [[UISlider alloc]initWithFrame:CGRectMake(0, 0, 250, 34)];
    volumeSlider.center = CGPointMake(KScreenWidth/2, CGRectGetMaxY(playOrPause.frame)+50);
    volumeSlider.minimumValue = 0;
    volumeSlider.maximumValue = 1.0;
    volumeSlider.value = 1.0;
    [volumeSlider addTarget:self action:@selector(makeVolume:) forControlEvents:UIControlEventValueChanged];
    [visualEffectView addSubview:volumeSlider];
    
    // 播放顺序的类型按钮
    UIButton *orderPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    orderPlay.frame = CGRectMake(0, 0, 30, 30);
    orderPlay.center = CGPointMake(KScreenWidth/2-100, CGRectGetMaxY(self.albumLabel.frame) + 150);
    [orderPlay setImage:[UIImage imageNamed:@"order"] forState:UIControlStateNormal];
    [orderPlay addTarget:self action:@selector(playStateAction:) forControlEvents:UIControlEventTouchUpInside];
    orderPlay.tag = 10001;
    [visualEffectView addSubview:orderPlay];
    
    UIButton *randomPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    randomPlay.frame = CGRectMake(0, 0, 30, 30);
    randomPlay.center = CGPointMake(KScreenWidth/2, CGRectGetMaxY(self.albumLabel.frame) + 150);
    [randomPlay setImage:[UIImage imageNamed:@"random"] forState:UIControlStateNormal];
    [randomPlay addTarget:self action:@selector(playStateAction:) forControlEvents:UIControlEventTouchUpInside];
    randomPlay.tag = 10002;
    [visualEffectView addSubview:randomPlay];
    
    UIButton *singleCycle = [UIButton buttonWithType:UIButtonTypeCustom];
    singleCycle.frame = CGRectMake(0, 0, 30, 30);
    singleCycle.center = CGPointMake(KScreenWidth/2+100, CGRectGetMaxY(self.albumLabel.frame) + 150);
    [singleCycle setImage:[UIImage imageNamed:@"single"] forState:UIControlStateNormal];
    [singleCycle addTarget:self action:@selector(playStateAction:) forControlEvents:UIControlEventTouchUpInside];
    singleCycle.tag = 10003;
    [visualEffectView addSubview:singleCycle];
    
    
    // 占位歌曲
    self.music = self.musicArray.firstObject;
    [self changeMusic:self.music];
    
    self.state = MusicPlayStateOrder;
    self.musicList = [NSMutableArray arrayWithCapacity:8];
    self.musicList = self.musicArray;
    UIButton *button  = (UIButton *)[self.view viewWithTag:10001];
    [button setImage:[UIImage imageNamed:@"order_h"] forState:UIControlStateNormal];
}

#pragma mark -- AVAudioPlayerDelegate代理 --

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag == YES){
        switch (self.state) {
            case MusicPlayStateOrder:
            {
                NSInteger index= [self.musicList indexOfObject:self.music];
                if (index == (self.musicList.count - 1)) {
                    self.music = self.musicList[0];
                    [self changeMusic:self.music];
                    
                }else {
                    self.music = self.musicList[index + 1];
                    [self changeMusic:self.music];
                }
                break;
            }
            case MusicPlayStateRandom:
            {
                if (self.musicList.count == self.musicArray.count) {
                    [self.musicList removeObject: self.music];
                }
                NSArray *array1 = self.musicArray;
                NSMutableArray *array = array1.mutableCopy;
                [array removeObject:self.music];
                if (array.count == 0) {
                    array = self.musicArray;
                }
                int m = arc4random() % array.count;
                self.music = array[m];
                [self.musicList addObject:self.music];
                [self changeMusic:self.music];
                break;
            }
            case MusicPlayStateSingleCycle:
                [self changeMusic:self.music];
                break;
            default:
                break;
        }

    }
}


#pragma mark 播放顺序
- (void)playStateAction:(UIButton *)button {
    
    switch (button.tag) {
        case 10001:
        {
            self.musicList = nil;
            self.state = MusicPlayStateOrder;
            self.musicList = self.musicArray;
            UIButton *button2  = (UIButton *)[self.view viewWithTag:10002];
            [button2 setImage:[UIImage imageNamed:@"random"] forState:UIControlStateNormal];
            UIButton *button3  = (UIButton *)[self.view viewWithTag:10003];
            [button3 setImage:[UIImage imageNamed:@"single"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"order_h"] forState:UIControlStateNormal];
            break;
        }
        case 10002:
        {
            self.musicList = nil;
            self.state = MusicPlayStateRandom;
            self.musicList = [NSMutableArray arrayWithCapacity:8];
            [self.musicList addObject:self.music];
            UIButton *button1  = (UIButton *)[self.view viewWithTag:10001];
            [button1 setImage:[UIImage imageNamed:@"order"] forState:UIControlStateNormal];
            UIButton *button3  = (UIButton *)[self.view viewWithTag:10003];
            [button3 setImage:[UIImage imageNamed:@"single"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"random_h"] forState:UIControlStateNormal];
            break;
        }
        case 10003:
        {
            self.musicList = nil;
            self.state = MusicPlayStateSingleCycle;
            self.musicList = self.musicArray;
            UIButton *button2  = (UIButton *)[self.view viewWithTag:10002];
            [button2 setImage:[UIImage imageNamed:@"random"] forState:UIControlStateNormal];
            UIButton *button1  = (UIButton *)[self.view viewWithTag:10001];
            [button1 setImage:[UIImage imageNamed:@"order"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"single_h"] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}




#pragma mark 播放上一首
- (void)lastMusicAction:(UIButton *)button {
    NSInteger index= [self.musicList indexOfObject:self.music];
    if (self.state == MusicPlayStateOrder || self.state == MusicPlayStateSingleCycle) {
        if (index == 0) {
            self.music = self.musicList.lastObject;
            [self changeMusic:self.music];
            
        }else {
            self.music = self.musicList[index - 1];
            [self changeMusic:self.music];
        }
    }else if(self.state == MusicPlayStateRandom) {
        if (index == 0) {
            NSLog(@"afsdfs");
        }else {
            [self.musicList removeLastObject];
            self.music = self.musicList.lastObject;
            [self changeMusic:self.music];
        }
    }
}

#pragma mark 播放下一首
- (void)nextMusicAction:(UIButton *)button {
    NSInteger index = [self.musicList indexOfObject:self.music];
    if (self.state == MusicPlayStateOrder || self.state == MusicPlayStateSingleCycle) {
        if (index == self.musicList.count-1) {
            self.music = self.musicList.firstObject;
            [self changeMusic:self.music];
            
        }else {
            self.music = self.musicList[index + 1];
            [self changeMusic:self.music];
        }
        
    }else if(self.state == MusicPlayStateRandom) {
        if (self.musicList.count == self.musicArray.count) {
            [self.musicList removeObject: self.music];
        }
        NSArray *array1 = self.musicArray;
        NSMutableArray *array = array1.mutableCopy;
        [array removeObject:self.music];
        if (array.count == 0) {
            array = self.musicArray;
        }
        int m = arc4random() % array.count;
        self.music = array[m];
        [self.musicList addObject:self.music];
        [self changeMusic:self.music];

        
    }

}


#pragma mark 根据歌曲信息刷新UI
- (void)changeMusic:(MusicInfo *)music {
    [self.timer invalidate];
    self.timer = nil;
    // 背景图片
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:music.backImage]];
    // 专辑图片
    [self.albumImageView sd_setImageWithURL:[NSURL URLWithString:music.ablumImage] placeholderImage:[UIImage imageNamed:@"place_holder.png"]];
    // 歌名
    self.nameLabel.text = music.musicName;
    // 专辑名
    self.albumLabel.text = music.ablum;
    // 音乐控制
    NSString *path = [[NSBundle mainBundle]pathForResource:music.musicName ofType:@".mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [self.player play];
    
    // 设置代理
    self.player.delegate = self;
    
    if (self.isPlaying == NO){
        [self.button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageNamed:@"pause_h"] forState:UIControlStateHighlighted];
        self.isPlaying = YES;
    }
    
#pragma mark 音乐和UI控件的关系
    // 滑块的最大值为当前歌曲的总时长
    self.progressView.maximumValue = self.player.duration;
    
#pragma mark NStimer
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerAction) userInfo:nil repeats:YES ];
}


#pragma mark 计时器
- (void)timerAction{
    // 旋转
    self.albumImageView.transform = CGAffineTransformRotate(self.albumImageView.transform, M_1_PI / 40);
    // 进度条
    self.progressView.value = self.player.currentTime;
    // 时间标签
    self.leftLabel.text = [self caclcuateWithTime:self.player.currentTime];
    self.rightLabel.text = [self caclcuateWithTime:self.player.duration-self.player.currentTime];
}

#pragma mark 音乐音量控制
- (void)makeVolume:(UISlider *)slider{
    
    self.player.volume = slider.value;
}


#pragma mark 播放暂停
- (void)playOrPauseAction:(UIButton *)button {
    if (_isPlaying == YES) {
        [button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"play_h"] forState:UIControlStateHighlighted];
        [self.player pause];
        _isPlaying = NO; // 音乐状态为未播放
        [self.timer invalidate]; // 定时器停止
        self.timer = nil;
    }else {
        [button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"pause_h"] forState:UIControlStateHighlighted];
        [self.player play];
        _isPlaying = YES;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerAction) userInfo:nil repeats:YES ];
    }
}


#pragma mark 滑块控制音乐进度
- (void)makeProgress:(UISlider *)slider {
    // 补充操作
    if (_isPlaying) {
        [self.timer invalidate]; //计时器停止
        self.timer = nil;
        [self.player pause]; // 音乐停止
        // 音乐的当前播放时间为人为拖动的滑块的值
        self.player.currentTime = slider.value;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerAction) userInfo:nil repeats:YES ];// 重启timer
        [self.player play]; // 音乐播放
    }else {
        self.player.currentTime = slider.value;
    }
}

// 字符串和时间的转换
- (NSString *)caclcuateWithTime:(NSTimeInterval)interal{
    // 200->3:20  181->3:01  10->0:10  1->0:01
    // 获取分钟数
    int min = interal/60;
    // 获取秒数
    int sec = (interal - min*60);
    return [NSString stringWithFormat:@"%d:%02d",min,sec];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
