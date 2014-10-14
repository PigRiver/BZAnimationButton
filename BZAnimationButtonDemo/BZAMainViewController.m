//
//  BZAMainViewController.m
//  BZAnimationButtonDemo
//
//  Created by Bruce on 14-8-1.
//  Copyright (c) 2014年 com.Bruce.AnimationButtonDemo. All rights reserved.
//

#import "BZAMainViewController.h"

#define DIALOG_PART_FRAME CGRectMake(260, 50, 30, 30)

#define DIALOG_DISTANCE 70
#define DIALOG_BORDER 5

@interface BZAMainViewController ()

@property (nonatomic) CGRect dialogFrame;
@property (nonatomic) BOOL isTouching;
@property (nonatomic, retain) BZAAnimationButton *button;

@end

@implementation BZAMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    [self initButton];
}

- (void)initButton {
    self.button = [[BZAAnimationButton alloc] init];
    self.button.frame = CGRectMake(130, 80, 60, 60);
    [self.button setLayerLineLength:50];
    self.button.backgroundColor = [UIColor grayColor];
    self.button.tag = 100;
    [self.button addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    [self.button setStyle:AnimationButtonStyleXWithCircle withAnimation:NO];
    
    BZAAnimationButton *button1 = [[BZAAnimationButton alloc] init];
    button1.frame = CGRectMake(10, 170, 35, 35);
    [button1 setLayerLineLength:30];
    button1.backgroundColor = [UIColor whiteColor];
    button1.tag = AnimationButtonStyleArrowRight;
    [button1 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    [button1 setStyle:AnimationButtonStyleArrowRight withAnimation:NO];
    
    BZAAnimationButton *button2 = [[BZAAnimationButton alloc] init];
    button2.frame = CGRectMake(60, 170, 35, 35);
    [button2 setLayerLineLength:30];
    button2.backgroundColor = [UIColor whiteColor];
    button2.tag = AnimationButtonStyleArrowLeft;
    [button2 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    [button2 setStyle:AnimationButtonStyleArrowLeft withAnimation:NO];
    
    BZAAnimationButton *button3 = [[BZAAnimationButton alloc] init];
    button3.frame = CGRectMake(110, 170, 35, 35);
    [button3 setLayerLineLength:30];
    button3.backgroundColor = [UIColor whiteColor];
    button3.tag = AnimationButtonStyleThreeLines;
    [button3 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    [button3 setStyle:AnimationButtonStyleThreeLines withAnimation:NO];
    
    BZAAnimationButton *button4 = [[BZAAnimationButton alloc] init];
    button4.frame = CGRectMake(160, 170, 35, 35);
    [button4 setLayerLineLength:30];
    button4.backgroundColor = [UIColor whiteColor];
    button4.tag = AnimationButtonStyleX;
    [button4 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    [button4 setStyle:AnimationButtonStyleX withAnimation:NO];
    
    BZAAnimationButton *button5 = [[BZAAnimationButton alloc] init];
    button5.frame = CGRectMake(210, 170, 35, 35);
    [button5 setLayerLineLength:30];
    button5.backgroundColor = [UIColor whiteColor];
    button5.tag = AnimationButtonStyleAdd;
    [button5 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    [button5 setStyle:AnimationButtonStyleAdd withAnimation:NO];
    
    BZAAnimationButton *button6 = [[BZAAnimationButton alloc] init];
    button6.frame = CGRectMake(260, 170, 35, 35);
    [button6 setLayerLineLength:30];
    button6.backgroundColor = [UIColor whiteColor];
    button6.tag = AnimationButtonStyleDown;
    [button6 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button6];
    [button6 setStyle:AnimationButtonStyleDown withAnimation:NO];
    
    BZAAnimationButton *button7 = [[BZAAnimationButton alloc] init];
    button7.frame = CGRectMake(10, 220, 35, 35);
    [button7 setLayerLineLength:30];
    button7.backgroundColor = [UIColor whiteColor];
    button7.tag = AnimationButtonStyleUp;
    [button7 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button7];
    [button7 setStyle:AnimationButtonStyleUp withAnimation:NO];
    
    BZAAnimationButton *button8 = [[BZAAnimationButton alloc] init];
    button8.frame = CGRectMake(60, 220, 35, 35);
    [button8 setLayerLineLength:30];
    button8.backgroundColor = [UIColor whiteColor];
    button8.tag = AnimationButtonStyleLeft;
    [button8 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button8];
    [button8 setStyle:AnimationButtonStyleLeft withAnimation:NO];
    
    BZAAnimationButton *button9 = [[BZAAnimationButton alloc] init];
    button9.frame = CGRectMake(110, 220, 35, 35);
    [button9 setLayerLineLength:30];
    button9.backgroundColor = [UIColor whiteColor];
    button9.tag = AnimationButtonStyleRight;
    [button9 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button9];
    [button9 setStyle:AnimationButtonStyleRight withAnimation:NO];
    
    BZAAnimationButton *button10 = [[BZAAnimationButton alloc] init];
    button10.frame = CGRectMake(160, 220, 35, 35);
    [button10 setLayerLineLength:30];
    button10.backgroundColor = [UIColor whiteColor];
    button10.tag = AnimationButtonStyleAddWithCircle;
    [button10 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button10];
    [button10 setStyle:AnimationButtonStyleAddWithCircle withAnimation:NO];
    
    BZAAnimationButton *button11 = [[BZAAnimationButton alloc] init];
    button11.frame = CGRectMake(210, 220, 35, 35);
    [button11 setLayerLineLength:30];
    button11.backgroundColor = [UIColor whiteColor];
    button11.tag = AnimationButtonStyleXWithCircle;
    [button11 addTarget:self action:@selector(onButton1Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button11];
    [button11 setStyle:AnimationButtonStyleXWithCircle withAnimation:NO];
}

- (void)onButton1Click:(id)sender {
    BZAAnimationButton *button = (BZAAnimationButton *)sender;
    if (button.tag != 100) {
        [self.button setStyle:button.tag withAnimation:YES];
    }
}

@end
