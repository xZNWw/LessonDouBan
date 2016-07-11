//
//  firstViewController.m
//  传值
//
//  Created by lanou3g on 16/3/19.
//  Copyright © 2016年 邢晓伟. All rights reserved.
//

#import "firstViewController.h"
#import "secondViewController.h"
@interface firstViewController ()<passValueDelegate>
@property(strong,nonatomic)UITextField *textField;
@end

@implementation firstViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一页" style:(UIBarButtonItemStyleDone) target:self action:@selector(nextPage:)];
    }
    return self;
}

- (void)nextPage:(UIBarButtonItem *)barButton{
    secondViewController *secondVC = [secondViewController new];
    secondVC.string = self.textField.text;
    secondVC.delegate = self;
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (void)passValue:(NSString *)string{
    self.textField.text = string;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.center = self.view.center;
    [self.view addSubview:self.textField];
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
