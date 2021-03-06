//
//  UIDevice+Tool.m
//  PoporUI
//
//  Created by popor on 2018/6/19.
//  Copyright © 2018年 popor. All rights reserved.
//
#import "UIDevice+Tool.h"

#import "sys/utsname.h"

// wifi 名字
#import <SystemConfiguration/CaptiveNetwork.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation UIDevice (Tool)

#pragma mark [获取设备 Retina 信息]
+ (BOOL)isRetinaScreen
{
    BOOL isRetina = NO;
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {// iOS 3.2
        // 你的Base SDK应 不小于 iOS 3.2
        CGFloat w = [[[UIScreen mainScreen] currentMode] size].width;
        /*
         Retina iPad 模拟器像素宽度为1136.0f，但真机像素宽度为2048.0f。
         Retina iPhone/iPod Touch 模拟器/真机像素宽度为640.0f，
         但为了防止出现类似iPad那样的情况，也检测960.0f和1136.0f。
         */
        if (w == 640.0f || w == 960.0f || w == 1136.0f || w == 1536.0f || w == 2048.0f) {
            isRetina = YES;
        }
    }
    return isRetina;
}

+ (NSString *)getAppName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    
    return app_Name;
}

#pragma mark - 推送开关是否打开
+ (BOOL)pushNotificationsEnabled
{
    // ios8代码
    UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    return (types & UIUserNotificationTypeAlert);
    // ios78兼容代码
    //if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]) {
    //    UIUserNotificationType types = [[[UIApplication sharedApplication] currentUserNotificationSettings] types];
    //    return (types & UIUserNotificationTypeAlert);
    //} else {
    //    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    //    return (types & UIRemoteNotificationTypeAlert);
    //}
}

/**
 * 获取ios设备状态栏网络状态，检测2G、3G、4G、wifi都是正常的。
 */
+ (NSString *)getIOSStatusBarNetWorkTypeStr
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children  = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    NSString *state    = @"无网络";
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (netType) {
                case 0:{
                    state = @"无网络";
                    break;
                }
                case 1:{
                    state = @"2G";
                    break;
                }
                case 2:{
                    state = @"3G";
                    break;
                }
                case 3:{
                    state = @"4G";
                    break;
                }
                case 5:{
                    state = @"wifi";
                    break;
                }
                default:{
                    state = @"无网络";
                    break;
                }
            }
        }
    }
    //根据状态选择
    return state;
}

+ (int)getIOSStatusBarNetWorkTypeInt
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children  = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int state    = NetStatusType_nil;
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (netType) {
                case 0:{
                    state = NetStatusType_nil;
                    break;
                }
                case 1:{
                    state = NetStatusType_2G;
                    break;
                }
                case 2:{
                    state = NetStatusType_3G;
                    break;
                }
                case 3:{
                    state = NetStatusType_4G;
                    break;
                }
                case 5:{
                    state = NetStatusType_Wifi;
                    break;
                }
                default:{
                    state = NetStatusType_nil;
                    break;
                }
            }
        }
    }
    //根据状态选择
    return state;
}

#pragma mark - APP Plist 版本
/**
 *  对外版本号
 */
+ (NSString *)getAppVersion_short
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

/**
 *  对内build号
 */
+ (NSString *)getAppVersion_build
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString*)devicePlatform
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return platform;
}

+ (BOOL)isIPhone6SOrNewer {
    NSString * platform = [UIDevice devicePlatform];
    if (platform.length > 7) {
        int number = [[platform substringWithRange:(NSRange){6,1}] intValue];
        if (number >= 8) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    //    if ([platform hasPrefix:@"iPhone8"]) {
    //        return YES;
    //    }else{
    //        return NO;
    //    }
}

+ (BOOL)isIPhone5S {
    NSString * platform = [UIDevice devicePlatform];
    if (platform.length > 7) {
        int number = [[platform substringWithRange:(NSRange){6,1}] intValue];
        if (number == 6) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
    //    if ([platform hasPrefix:@"iPhone8"]) {
    //        return YES;
    //    }else{
    //        return NO;
    //    }
}

+ (NSString *)getWifiName {
    NSString *ssid  = nil;//@"Not Found";
    //NSString *macIp = @"Not Found";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict =CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray,0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid  = [dict valueForKey:@"SSID"];//WiFi名称
            //macIp = [dict valueForKey:@"BSSID"];//Mac地址
        }
        CFRelease(myArray);
    }
    
    return ssid;
}

@end
