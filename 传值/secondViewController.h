//
//  secondViewController.h
//  传值
//
//  Created by lanou3g on 16/3/19.
//  Copyright © 2016年 邢晓伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol passValueDelegate <NSObject>

- (void)passValue:(NSString *)string;


@end

@interface secondViewController : UIViewController
@property(strong,nonatomic)UITextField *textField;
@property(strong,nonatomic)NSString *string;
@property(assign,nonatomic)id<passValueDelegate>delegate;
@end
