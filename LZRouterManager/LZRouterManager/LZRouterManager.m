//
//  LZRouterManager.m
//  LZZ
//
//  Created by lizezhao on 16/12/19.
//  Copyright © 2016年 LZZ. All rights reserved.
//

#import "LZRouterManager.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface LZRouterManager()
@property (nonatomic,copy)NSString *schemeHost;
@property (nonatomic,strong) NSMutableDictionary *paramDic;
@end
@implementation LZRouterManager
-(id)initWithHost:(NSString *)host
{
    if (self = [super init] ) {
        self.schemeHost = host;
    };
    return self;
}
+(BOOL)HandleOpenURL:(NSURL *)url withScheme:(NSString *)scheme
{
    [[[self alloc]initWithHost:url.host] handleSchemes:url];
    return [url.scheme isEqualToString:scheme];
}
-(void)handleSchemes:(NSURL *)url
{
    NSString *host = [url host];
    NSArray *itms = [[url query] componentsSeparatedByString:@"&"];
    [self jumpVC:host withquerys:itms];
}
/**
 *  控制器的跳转
 *
 *  @param host   url的host
 *  @param querys 请求参数
 */
-(void)jumpVC:(NSString *)host withquerys:(NSArray *)querys
{
    NSString *vcClz = [self classWithHost];
    id myObj = [[NSClassFromString(vcClz) alloc] init];
    if (!myObj) {
//弹出不兼容提示
        if (showUpdateAlert) {
             [self showAlertView];
        }
       
       
        return;
    }

    if (myObj) {
        for (NSString *itm in querys) {
            NSArray *keyvalues = [itm componentsSeparatedByString:@"="];
            NSString *VCkey = [self paramWithQuery:keyvalues.firstObject];
            if ([self getVariableWithClass:[myObj class] varName: VCkey]) {
                [myObj setValue:keyvalues.lastObject forKey:VCkey];
            }else{
//option: 弹出不兼容提示；（这里是不兼容的参数，可选择不做跳转）
               
//                if (showUpdateAlert) {
//                    [self showAlertView];
//                }
//                return;
            }
        }
    }
    UIViewController *currentVC = [self getCurrentVC];
    if (currentVC.navigationController) {
        currentVC.hidesBottomBarWhenPushed = YES;
        [currentVC.navigationController pushViewController:myObj animated:YES];
    }else{
        [[self getCurrentVC] presentViewController:myObj animated:YES completion:nil];
    }
}
/**
 *  得到当前显示的VC
 *
 */
- (UIViewController *)getCurrentVC{
    
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    
    return result;
}
/**
 *  判断某个类是否有某个参数，防止 setvalue forkey 崩溃
 *
 */
- (BOOL)getVariableWithClass:(Class) myClass varName:(NSString *)name{
    unsigned int outCount, i;
    Ivar *ivars = class_copyIvarList(myClass, &outCount);
    for (i = 0; i < outCount; i++) {
        Ivar property = ivars[i];
        NSString *keyName = [NSString stringWithCString:ivar_getName(property) encoding:NSUTF8StringEncoding];
        keyName = [keyName stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if ([keyName isEqualToString:name]) {
            return YES;
        }
    }
    return NO;
}
/**
 *  返回VC的各参数名
 *
 */
-(NSString *)paramWithQuery:(NSString *)query
{
    if (!self.paramDic) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LZRouterManager" ofType:@"plist"];
        NSMutableDictionary *routerData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        NSDictionary *vcClz = [routerData objectForKey:self.schemeHost];
        NSDictionary *param = [vcClz objectForKey:@"param"];
        self.paramDic = [NSMutableDictionary dictionaryWithDictionary:param];
    }
    if ([self.paramDic objectForKey:query]) {
        return [self.paramDic objectForKey:query];
    }
    return query;
}
/**
 *  返回VC的类名
 *
 */
-(NSString *)classWithHost
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"LZRouterManager" ofType:@"plist"];
    NSMutableDictionary *routerData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSDictionary *vcClz = [routerData objectForKey:self.schemeHost];
    if (vcClz[@"className"]) {
        return vcClz[@"className"];
        
    }
    return self.schemeHost;
}

-(void)showAlertView{
    
    UIAlertController *alv = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要升级才能完成操作" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1=[UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeUpdateUrl]];
    }];
    
    UIAlertAction *action2=[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alv addAction:action1];
    [alv addAction:action2];
    [[self getCurrentVC] presentViewController:alv animated:YES completion:nil];
}
@end
