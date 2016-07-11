//
//  thirdViewController.m
//  传值
//
//  Created by lanou3g on 16/3/19.
//  Copyright © 2016年 邢晓伟. All rights reserved.
//

#import "thirdViewController.h"
#import "secondViewController.h"
@interface thirdViewController ()

@end

@implementation thirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.center = self.view.center;
    self.textField.text = self.string;
    [self.view addSubview:self.textField];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.block(self.textField.text);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
