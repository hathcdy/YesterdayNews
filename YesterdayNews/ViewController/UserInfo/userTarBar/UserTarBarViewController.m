//
//  UserTarBarViewController.m
//  YesterdayNews
//
//  Created by 陈统盼 on 2019/4/23.
//  Copyright © 2019 Cookieschen. All rights reserved.
//

#import "UserTarBarViewController.h"
#import "ListViewController.h"
#import <ReactiveObjC.h>
#define BUTTON_TAG 100

@interface UserTarBarViewController ()

@property(nonatomic, strong) UILabel *title_label;
@property(nonatomic, strong) UIButton *back_button;
@property(nonatomic, strong) UIView *separator_line1;
@property(nonatomic, strong) UIView *button_group;
@property(nonatomic, strong) UIView *separator_line2;
@property(nonatomic, strong) NSArray<NSString *> *titleArr;

@property(nonnull, nonatomic) UIPageViewController *pageVC;

@end

@implementation UserTarBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self bindViewModel];
    
}

- (instancetype)init {
    self = [super init];
    if(self){
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.titleArr = @[@"收藏", @"评论", @"点赞", @"历史", @"推送"];
}


// ui布局
- (void)setupView {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setTitle:@"test"];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack:)];
    //[self.view addSubview: self.title_label];
    [self.view addSubview:self.separator_line1];
    [self.view addSubview: self.back_button];
    [self.view addSubview:self.separator_line2];
    [self.view addSubview:self.button_group];
    [self addButtons];
    [self.view addSubview: self.pageVC.view];
    [self addChildViewController: self.pageVC];
}

// viewmodel绑定
- (void)bindViewModel {
    /*
    [RACObserve(self, current_index) subscribeNext:^(NSNumber*  _Nullable x) {
        [self.pageVC setIndex: [x integerValue]];
    }];
    */
}

- (UIPageViewController *)pageVC {
    if(_pageVC == nil){
        //_pageVC = [[UIPageViewController alloc] init];
        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:10] forKey:UIPageViewControllerOptionInterPageSpacingKey];
        _pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
        [_pageVC.view setFrame: CGRectMake(0, 130, self.view.frame.size.width, self.view.frame.size.height - 130)];
    }
    return _pageVC;
}

// buttons
- (UIView *)button_group {
    if(_button_group == nil){
        _button_group = [[UIView alloc] initWithFrame:CGRectMake(0, 86, self.view.frame.size.width, 40)];
    }
    return _button_group;
}

- (void)addButtons {
    int btnWidth = self.view.frame.size.width / self.titleArr.count;
    for(int i = 0; i < self.titleArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnWidth * i, 5, btnWidth, 30);
        [btn setTitle:_titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        btn.tag = i + BUTTON_TAG;               // tag
        btn.selected = NO;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        //[btn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [[btn rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            for (int i = 0; i < self.titleArr.count; i++) {
                //UIButton *btn = (UIButton *)[[sender superview]viewWithTag:BUTTON_TAG + i];
                UIButton *btn = (UIButton *)[self.view viewWithTag:BUTTON_TAG + i];
                [btn setSelected:NO];
                btn.subviews[1].hidden = YES;
            }
            //UIButton *button = (UIButton *)sender;
            [x setSelected:YES];
            x.subviews[1].hidden = NO;
            
            self.current_index = x.tag - BUTTON_TAG;
        }];
        
        [self.button_group addSubview:btn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 32, btnWidth - 40, 2)];
        line.backgroundColor = [UIColor redColor];
        line.hidden = YES;
        [btn addSubview:line];
    }
}

// 标题Label
- (UILabel *)title_label {
    if(_title_label == nil) {
        _title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2 - 15, self.view.frame.size.width, 30)];
        _title_label.textColor = [UIColor blackColor];
        _title_label.textAlignment = NSTextAlignmentCenter;
        _title_label.font = [UIFont systemFontOfSize:20];
        _title_label.text = @"This is a fucking test page";
    }
    return _title_label;
}

- (UIButton *)back_button {
    if(_back_button == nil) {
        _back_button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 30, 30)];
        [_back_button setTitle:@"<" forState:UIControlStateNormal];
        _back_button.titleLabel.font = [UIFont systemFontOfSize:20];
        NSMutableAttributedString *str0 = [[NSMutableAttributedString alloc] initWithString:_back_button.titleLabel.text];
        [str0 addAttribute:(NSString*)NSForegroundColorAttributeName value:[UIColor blackColor] range:[_back_button.titleLabel.text rangeOfString:((UIButton *)_back_button).titleLabel.text]];
        [_back_button setAttributedTitle:str0 forState:UIControlStateNormal];
        _back_button.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [[_back_button rac_signalForControlEvents: UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _back_button;
}

// 分割线
- (UIView *)separator_line1 {
    if(_separator_line1 == nil){
        _separator_line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 85, self.view.frame.size.width, 1)];
        [_separator_line1 setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    }
    return _separator_line1;
}

- (UIView *)separator_line2 {
    if(_separator_line2 == nil){
        _separator_line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 124, self.view.frame.size.width, 1)];
        [_separator_line2 setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    }
    return _separator_line2;
}

- (void)chooseBtn:(UIButton *)sender{
    for (int i = 0; i < _titleArr.count; i++) {
        UIButton *btn = (UIButton *)[[sender superview]viewWithTag:BUTTON_TAG + i];
        [btn setSelected:NO];
        btn.subviews[1].hidden = YES;
    }
    UIButton *button = (UIButton *)sender;
    [button setSelected:YES];
    button.subviews[1].hidden = NO;
    
    self.current_index = sender.tag - BUTTON_TAG;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
