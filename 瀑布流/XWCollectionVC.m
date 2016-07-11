//
//  XWCollectionVC.m
//  瀑布流
//
//  Created by lanou3g on 16/5/5.
//  Copyright © 2016年 邢晓伟. All rights reserved.
//

#import "XWCollectionVC.h"
#import "XRWaterfallLayout.h"
#import "Image.h"
#import "UIImageView+WebCache.h"

#define GET_URL @"http://image.baidu.com/search/wisejsonala?tn=wisejsonala&ie=utf8&word=%E5%8A%A8%E6%BC%AB%E4%BA%BA%E7%89%A9%E6%A1%8C%E9%9D%A2%E5%A3%81%E7%BA%B8&fr=&pn=210&rn=30&gsm=d2"

@interface XWCollectionVC ()<XRWaterfallLayoutDelegate>

@property (strong,nonatomic) NSMutableArray *dataArray;
@property (strong,nonatomic) XRWaterfallLayout *fallLayout;

@end

@implementation XWCollectionVC

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 请求数据
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:GET_URL]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            self.dataArray = [NSMutableArray new];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            for (NSDictionary *modelDict in dict[@"data"]) {
                Image *image = [Image new];
                [image setValuesForKeysWithDictionary:modelDict];
                [self.dataArray addObject:image];
            }
        }
    }];
    
    [dataTask resume];
    
    // 切换布局
    self.fallLayout = [[XRWaterfallLayout alloc]initWithColumnCount:3];
    self.collectionView.collectionViewLayout = self.fallLayout;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    self.fallLayout.delegate = self;
    UIImageView *image = [[UIImageView alloc]initWithFrame:cell.bounds];
    Image *iamge = self.dataArray[indexPath.item];
    [image sd_setImageWithURL:[NSURL URLWithString:iamge.obj_url]
                                  placeholderImage:[UIImage imageNamed:@"timg.jpg"]];
    [cell addSubview:image];
    return cell;
}

- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    
    return itemWidth;
    
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
