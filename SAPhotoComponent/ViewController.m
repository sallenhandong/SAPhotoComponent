//
//  ViewController.m
//  SAPhotoComponent
//
//  Created by 哲仁科技李海强 on 2017/10/18.
//  Copyright © 2017年 哲仁科技韩伟. All rights reserved.
//

#import "ViewController.h"
#import "SAClipImageview.h"
#import "UIColor+Hex.h"
#define MainRedColor  [UIColor colorWithHexString:@"F94C6D"]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ViewController ()<UIScrollViewDelegate>{

    UIView *sliderView;
    //拖动时用到的属性，记录最后的选中button的tag
    int tmptag;

}
@property (nonatomic,strong) UIScrollView *mainScrollview;
@property (nonatomic,strong) NSArray *photosArr;
@property(nonatomic,strong)NSMutableArray * myRects;//存放所有的view
@property(nonatomic,strong)NSMutableArray * frames;//存放view的标准位置
@property(nonatomic,strong)NSMutableArray * panArr;//存放view的标准位置
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myRects = [NSMutableArray arrayWithCapacity:10];
    self.frames = [NSMutableArray arrayWithCapacity:10];
    self.panArr = [[NSMutableArray alloc]init];
    self.photosArr = @[@"timg.jpg",@"timg.jpg",@"timg.jpg",@"timg.jpg",@"timg.jpg",@"timg.jpg",@"timg.jpg"];
    
    
    
      [self addTemplateView];
    
}

- (void)addTemplateView{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *jsonStr = nil;
        NSString *mainBundleDirectory=[[NSBundle mainBundle] bundlePath];
        NSString *path=[mainBundleDirectory stringByAppendingPathComponent:@"template.json"];
        NSURL *url = [NSURL fileURLWithPath:path];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            int index = [[dic objectForKey:@"itemCount"] intValue];
            NSArray *positionArr = [dic objectForKey:@"position"];
            
            int t_width = [[dic objectForKey:@"t_width"] intValue];
            
            int t_height = [[dic objectForKey:@"t_height"] intValue];
            
            self.mainScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 64, t_width, SCREEN_HEIGHT - 64)];
            self.mainScrollview.backgroundColor = [UIColor blackColor];
            self.mainScrollview.contentSize = CGSizeMake(t_width, t_height + 100);
            self.mainScrollview.showsVerticalScrollIndicator = NO;
            self.mainScrollview.showsHorizontalScrollIndicator = NO;
            self.mainScrollview.scrollEnabled = NO;
            [self.view addSubview:self.mainScrollview];
            
            for (int i = 0; i <index; i++) {
                int imgeX = 0;
                int imgeY = 0;
                int width = 0;
                int height = 0;
                
                width = [[positionArr[i] objectForKey:@"width"] intValue];
                height = [[positionArr[i] objectForKey:@"height"] intValue];
                imgeX = [[positionArr[i] objectForKey:@"x"] intValue];
                imgeY = [[positionArr[i] objectForKey:@"y"] intValue];
                
                UIImage *contentImage = [UIImage imageNamed:self.photosArr[i]];
                SAClipImageview *clipView = [[SAClipImageview alloc]initWithCropImage:contentImage cropSize:CGSizeMake( width, height)];
                clipView.tag = 100 + i;
                clipView.showsVerticalScrollIndicator = NO;
                clipView.showsHorizontalScrollIndicator = NO;
                CGFloat scale = (contentImage.size.width/contentImage.size.height) * 0.59;
                clipView.contentSize = CGSizeMake(contentImage.size.width *scale, contentImage.size.height * scale);
                clipView.delegate = self;
                clipView.frame = CGRectMake(imgeX, imgeY, width, height);
                [self.mainScrollview addSubview:clipView];
                NSString * str = [NSString stringWithFormat:@"%@",NSStringFromCGRect(clipView.frame)];
                [self.frames addObject:str];
                [self.myRects addObject:clipView];
                
                UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragClipView:)];
                [clipView addGestureRecognizer:pan];
                [clipView setUserInteractionEnabled:YES];
                
                
                
                //                UIPanGestureRecognizer *clipImagePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleClipViewPan:)];
                //                clipImagePan.delegate = self;
                //                [clipView setUserInteractionEnabled:YES];
                //                [clipView  addGestureRecognizer:clipImagePan];
                //
                //
                
                //                NSString *imageUrl = [positionArr[i] objectForKey:@"imageUrl"];
                //                UIImageView *v1 = [[UIImageView alloc]init];
                //                [v1 sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                //
                //                    CGSize size = image.size;
                //                    CGFloat imageW = size.width;
                //                    CGFloat imageH = size.height;
                //
                //                    v1.bounds = CGRectMake(0, 0, imageW, imageH);
                //
                //                    NSLog(@"%f,%f",imageW,imageH);
                
                
            }
            sliderView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 20, SCREEN_HEIGHT/2 - 100, 20, 250)];
            sliderView.alpha = 0.8;
            sliderView.backgroundColor = [UIColor blackColor];
            sliderView.clipsToBounds = YES;
            sliderView.layer.cornerRadius = 10;
            [self.view addSubview:sliderView];
            
            UIImageView *sliderImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 60)];
            sliderImage.image = [UIImage imageNamed:@"slidebar_vertical"];
            [sliderView addSubview:sliderImage];
            
            
            UIPanGestureRecognizer *sliderImagePan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSliderPan:)];
            [sliderImage setUserInteractionEnabled:YES];//开启图片控件的用户交互
            [sliderImage  addGestureRecognizer:sliderImagePan];//给图片添加手势
            
            
        });
    });
    
    
}
//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
{
    NSLog(@"scrollViewWillBeginDragging");
}
//完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    NSLog(@"scrollViewWillBeginDraggingscrollViewWillBeginDragging");
    
    
}
- (void)refreshScrollviewFrame:(CGFloat)midY{
    
    midY = midY == 30 ? 0 : midY;
    self.mainScrollview.contentOffset = CGPointMake(0, midY);
    
}


//拖动手势的回调方法
-(void)dragClipView:(UIPanGestureRecognizer*)pan
{
    //NSLog(@"drag");
    //获取手势在该视图上得偏移量
    CGPoint translation = [pan translationInView:self.view];
    //一下分别为拖动时的三种状态：开始，变化，结束
    if (pan.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"drag begin");
        //开始时拖动的view更改透明度
        pan.view.alpha = 0.7;
    }
    else if(pan.state == UIGestureRecognizerStateChanged)
    {
        NSLog(@"drag change");
        //使拖动的view跟随手势移动
        pan.view.center = CGPointMake(pan.view.center.x + translation.x,
                                      pan.view.center.y + translation.y);
        [pan setTranslation:CGPointZero inView:self.view];
        
        //遍历9个view看移动到了哪个view区域，使其为选中状态.并更新选中view的tag值，使其永远为最新的
        for (int i = 0; i< self.myRects.count; i++)
        {
            SAClipImageview *clipImage = self.myRects[i];
            NSString *tmprect = self.frames[i];
            if (CGRectContainsPoint(CGRectFromString(tmprect), pan.view.center))
            {
                
                tmptag = (int)clipImage.tag;
                // NSLog(@"tmptag ==> %d",tmptag);
                clipImage.layer.borderWidth = 3;
                clipImage.layer.borderColor = MainRedColor.CGColor;
                return;
            }
            else
            {
                clipImage.layer.borderWidth = 0;
                clipImage.layer.borderColor = [[UIColor clearColor]CGColor];
            }
        }
        
        
    }
    else if (pan.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"drag end");
        //拖动结束的时候，将拖动的view的透明度还原
        pan.view.alpha = 1;
        [UIView animateWithDuration:0.5 animations:^
         {
             //结束时将选中view的边框还原
             SAClipImageview * clipImage = self.myRects[tmptag - 100];
             clipImage.layer.borderWidth = 0;
             clipImage.layer.borderColor = [[UIColor clearColor]CGColor];
             
             //获取需要交换的两个view的frame，并交换
             NSString * rect1 = self.frames[clipImage.tag - 100];
             NSString * rect2 = self.frames[pan.view.tag - 100];
             
             pan.view.frame = CGRectFromString(rect1);
             clipImage.frame = CGRectFromString(rect2);
             
             //并交换其tag值及在数组中得位置
             int tmp = (int)pan.view.tag;
             pan.view.tag = tmptag;
             clipImage.tag = tmp;
             //NSLog(@"%d  %d",pan.view.tag,btn.tag);
             [self.myRects exchangeObjectAtIndex:pan.view.tag - 100 withObjectAtIndex:clipImage.tag - 100];
             
             
         } completion:^(BOOL finished)
         {
             //完成动画后还原btn的状态
             for (int i = 0; i< self.myRects.count; i++)
             {
                 
                 SAClipImageview * clipImage = self.myRects[i];
                 clipImage.layer.borderColor = [[UIColor clearColor]CGColor];
                 clipImage.layer.borderWidth = 0;

             }
             
             
             
             
         }];
        
    }
    
}
//slider 手势拖动
- (void)handleSliderPan:(UIPanGestureRecognizer *)rec{
    
    CGFloat KWidth = 20;
    CGFloat KHeight = 250;
    
    //返回在横坐标上、纵坐标上拖动了多少像素
    CGPoint point = [rec translationInView:sliderView];
    
    
    CGFloat centerX = rec.view.center.x+point.x;
    CGFloat centerY = rec.view.center.y+point.y;
    
    CGFloat viewHalfH = rec.view.frame.size.height/2;
    CGFloat viewhalfW = rec.view.frame.size.width/2;
    
    //确定特殊的centerY
    if (centerY - viewHalfH < 0 ) {
        centerY = viewHalfH;
    }
    if (centerY + viewHalfH > KHeight ) {
        centerY = KHeight - viewHalfH;
    }
    
    //确定特殊的centerX
    if (centerX - viewhalfW < 0){
        centerX = viewhalfW;
    }
    if (centerX + viewhalfW > KWidth){
        centerX = KWidth - viewhalfW;
    }
    rec.view.center = CGPointMake(centerX, centerY);
    
    [self refreshScrollviewFrame:centerY];
    //拖动完之后，每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
    [rec setTranslation:CGPointMake(0, 0) inView:self.view];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
