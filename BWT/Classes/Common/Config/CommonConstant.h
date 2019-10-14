
//
//  CommonConstant.h
//  BWT
//
//  Created by Miridescent on 2019/10/13.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#ifndef CommonConstant_h
#define CommonConstant_h

#define BWTMainColor [UIColor colorWithRed:251/255.0 green:78/255.0 blue:9/255.0 alpha:1]
//#define kMainBackgrouneColor [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]
#define BWTGrayColor [UIColor colorWithRed:145/255.0 green:139/255.0 blue:138/255.0 alpha:1]

#define RGBColor(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


#define kStatusRect [[UIApplication sharedApplication] statusBarFrame]
#define kStatusBarHeight kStatusRect.size.height

#define kNavigationRect self.navigationController.navigationBar.frame
#define kNavigationBarHeight kNavigation kNavigationRect.size.height

#endif /* CommonConstant_h */
