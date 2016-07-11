//
//  secondViewController.m
//  传值
//
//  Created by lanou3g on 16/3/19.
//  Copyright © 2016年 邢晓伟. All rights reserved.
//

#import "secondViewController.h"
#import "thirdViewController.h"
@interface secondViewController ()

@end

@implementation secondViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一页" style:(UIBarButtonItemStyleDone) target:self action:@selector(nextPage:)];
    }
    return self;
}

- (void)nextPage:(UIBarButtonItem *)barButton{
    
    thirdViewController *thirdVC = [thirdViewController new];
    thirdVC.block = ^(NSString *string){
        self.textField.text = string;
    };
    thirdVC.string = self.textField.text;
    thirdVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    [self presentViewController:thirdVC animated:YES completion:nil];
}

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
    [_delegate passValue:self.textField.text];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
