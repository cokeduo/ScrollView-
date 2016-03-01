//
//  ViewController.m
//  CYScrollView
//
//  Created by change009 on 16/2/1.
//  Copyright © 2016年 change009. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"

#define KWidth self.view.bounds.size.width
#define KSliderHeight 142

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic,assign) NSInteger pageCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSArray *imagesArr = [NSArray arrayWithObjects:@"http://182.92.101.144:8080/ibiaoqing/admin/advertisement/download.do?aId=1",@"http://182.92.101.144:8080/ibiaoqing/admin/advertisement/download.do?aId=2",@"http://182.92.101.144:8080/ibiaoqing/admin/advertisement/download.do?aId=3", nil];
    
    NSArray *imagesArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"image_1"],[UIImage imageNamed:@"image_2"],[UIImage imageNamed:@"image_3"], nil];
    
    NSMutableArray *newImageArr = [[NSMutableArray alloc] initWithArray:imagesArr];
    [newImageArr insertObject:[imagesArr lastObject] atIndex:0];
    [newImageArr addObject:[imagesArr firstObject]];
    
    self.pageIndex = 0;
    self.pageCount = imagesArr.count;
    

    UIScrollView *tempScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KSliderHeight)];
    tempScroll.contentSize = CGSizeMake(KWidth*newImageArr.count, KSliderHeight);
    tempScroll.pagingEnabled = YES;
    tempScroll.delegate = self;
    tempScroll.bounces = NO;
    tempScroll.showsHorizontalScrollIndicator = NO;
    tempScroll.contentOffset = CGPointMake(KWidth, 0);
    self.scrollView = tempScroll;
    [self.view addSubview:self.scrollView];
    
    
    for (int i = 0; i < newImageArr.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(KWidth*i, 0, KWidth, KSliderHeight)];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:[newImageArr objectAtIndex:i]] placeholderImage:nil];
        imageView.image = [newImageArr objectAtIndex:i];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickedImageViewAtIndex:)]];
        [self.scrollView addSubview:imageView];
    }
    
    
    UIPageControl *tempPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, KSliderHeight-20, KWidth, 20)];
    tempPageControl.numberOfPages = self.pageCount;
    tempPageControl.currentPage = self.pageIndex;
    tempPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    tempPageControl.currentPageIndicatorTintColor = [UIColor purpleColor];
    self.pageControl = tempPageControl;
    [self.view addSubview:self.pageControl];
    
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(beginPlayImage) userInfo:nil repeats:YES];
    
}


#pragma mark - timer 事件
-(void)beginPlayImage{
    
    self.pageIndex++;
    if (self.pageIndex == self.pageCount) {
        self.pageIndex = 0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + KWidth, 0);
    } completion:^(BOOL finished) {
        self.pageControl.currentPage = self.pageIndex;
    }];
    
    
    int index = self.scrollView.contentOffset.x/KWidth;
    if (index == 0) {
        self.scrollView.contentOffset = CGPointMake(KWidth*self.pageCount, 0);
        self.pageIndex = self.pageCount - 1;
    }else if (index == self.pageCount + 1){
        self.scrollView.contentOffset = CGPointMake(KWidth, 0);
        self.pageIndex = 0;
    }else{
        self.pageIndex = index - 1;
    }

    
}

#pragma mark - scrollView delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int index = self.scrollView.contentOffset.x/KWidth;
    if (index == 0) {
        self.scrollView.contentOffset = CGPointMake(KWidth*self.pageCount, 0);
        self.pageIndex = self.pageCount - 1;
    }else if (index == self.pageCount + 1){
        self.scrollView.contentOffset = CGPointMake(KWidth, 0);
        self.pageIndex = 0;
    }else{
        self.pageIndex = index - 1;
    }
    
    self.pageControl.currentPage = self.pageIndex;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(beginPlayImage) userInfo:nil repeats:YES];
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer invalidate];
}

#pragma mark - imageView 点击事件
-(void)clickedImageViewAtIndex:(UITapGestureRecognizer *)tapGesture{
    NSLog(@"pageIndex:%ld",self.pageIndex);
}


@end
