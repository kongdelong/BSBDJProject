//
//  AppDelegate.m
//  百思不得姐(KDL)
//
//  Created by manager on 16/5/1.
//  Copyright © 2016年 kdl. All rights reserved.
//

#import "AppDelegate.h"
#import "XLTabBarViewController.h"
#import "XLPushGuideView.h"
#import "XLTopWindow.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    // 设置窗口的根控制器
    self.window.rootViewController = [[XLTabBarViewController alloc] init];
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    [XLPushGuideView show];
    
  
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//       //crash in ios9
//       [XLTopWindow show];
    // ok 将代码做调整，加入到下一个loop周期中，再次运行代码，程序正常
    dispatch_async(dispatch_get_main_queue(), ^{
        // 添加一个window, 点击这个window, 可以让屏幕上的scrollView滚到最顶部
        [XLTopWindow show];
    });
    //  应该是在ios9中，对应程序启动时的uiwindow处理有了调整。 有网友说，xcode7后，多个uiwindow时，都需要有rootViewController。  从上面的测试过程中，应该不全对，只是在启动过程中，未完全结束时，对多个uiwindow有要求。
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
