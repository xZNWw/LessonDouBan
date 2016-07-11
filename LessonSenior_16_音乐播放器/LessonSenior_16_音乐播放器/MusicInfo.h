//
//  MusicInfo.h
//  LessonSenior_16_AVAudioPlayer
//
//  Created by lanou3g on 16/4/25.
//  Copyright © 2016年 邢晓伟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicInfo : NSObject

@property (strong,nonatomic) NSString *musicName;
@property (strong,nonatomic) NSString *backImage;
@property (strong,nonatomic) NSString *ablumImage; // 专辑封面
@property (strong,nonatomic) NSString *singer; // 歌手
@property (strong,nonatomic) NSString *ablum; // 专辑名称

@end
