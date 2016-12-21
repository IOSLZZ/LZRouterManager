//
//  ViewController.m
//  LZRouterManager
//
//  Created by lizezhao on 16/12/19.
//  Copyright © 2016年 LZZ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor grayColor];
    
    //示例：
    
    //1.plist文件配置映射（有时为了安全或者和安卓端一致，常常需要配置映射）
    // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"LZRouterManagerDemo://Test1?str=hhhhhh&id=111"]];
    //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"LZRouterManagerDemo://Test1?str=hhhhhh&test1ID=111"]];
    
    
    //2.直接调用
    // [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"LZRouterManagerDemo://Test1ViewController?str=hhhhhh&nb=111"]];
    
   //3.未配置的url（test2ViewController未配置，不识别）
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"LZRouterManagerDemo://test2ViewController?str=hhhhhh&nb=111"]];
    
    //4.也可在浏览器直接输入打开,可传参跳转至指定页面
    // LZRouterManagerDemo://test2ViewController?str=hhhhhh&nb=111
#warning 注意修改升级跳转的链接 或者 屏蔽提示
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
