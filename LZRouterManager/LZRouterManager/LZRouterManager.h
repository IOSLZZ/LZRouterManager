//
//  LZRouterManager.h
//  LZZ
//
//  Created by lizezhao on 16/12/19.
//  Copyright © 2016年 LZZ. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  1.可在路由表（LZRouterManager.pist）中配置host与viewController、query与param的映射关系；
 *  2.如果不配置就直接一一映射；
 *  ~如果映射关系没有找到，就会弹出请升级提示~
 */

#warning 这里是拿简书的升级的url做演示
static NSString *storeUpdateUrl = @"https://itunes.apple.com/cn/app/jian-shu-tian-xia-hao-wen/id888237539?mt=8";
static BOOL showUpdateAlert = NO; //是否弹出升级提示
@interface LZRouterManager : NSObject
//在appdelegate中捕获url
+(BOOL)HandleOpenURL:(NSURL *)url withScheme:(NSString *)scheme;
@end
