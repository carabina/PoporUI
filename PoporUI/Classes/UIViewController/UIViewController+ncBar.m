//
//  UIViewController+ncBar.m
//  PoporUI
//
//  Created by popor on 2018/6/19.
//  Copyright © 2018年 popor. All rights reserved.
//

#import "UIViewController+ncBar.h"
#import <objc/runtime.h>

@implementation UIViewController (ncBar)
@dynamic needHiddenNVBar;
//@dynamic inNC;

//- (void)setTapEndEditGR:(UITapGestureRecognizer *)tapEndEditGR {
//    objc_setAssociatedObject(self, @"tapEndEditGR", tapEndEditGR, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (UITapGestureRecognizer *)tapEndEditGR {
//    return objc_getAssociatedObject(self, @"tapEndEditGR");
//}

- (void)setNeedHiddenNVBar:(NSNumber *)needHiddenNVBar {
    objc_setAssociatedObject(self, @"needHiddenNVBar", needHiddenNVBar, OBJC_ASSOCIATION_RETAIN);
}

- (NSNumber *)needHiddenNVBar {
    return objc_getAssociatedObject(self, @"needHiddenNVBar");
}

- (BOOL)isInNC {
    for (UIViewController * vc in self.navigationController.viewControllers) {
        if (vc == self) {
            return YES;
        }
    }
    return NO;
}
//- (void)setInNC:(BOOL)inNC {
//    objc_setAssociatedObject(self, @"inNC", @(inNC), OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (BOOL)isInNC {
//    return objc_getAssociatedObject(self, @"inNC");
//}

@end
