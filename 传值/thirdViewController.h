//
//  thirdViewController.h
//  传值
//
//  Created by lanou3g on 16/3/19.
//  Copyright © 2016年 邢晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^passValueBlock)(NSString *);
@interface thirdViewController : UIViewController

@property(strong,nonatomic)UITextField *textField;
@property(strong,nonatomic)NSString *string;
@property(copy,nonatomic)passValueBlock block;

@end
