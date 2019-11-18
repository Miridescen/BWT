
//
//  UILabel+Tool.m
//  BWT
//
//  Created by Miridescent on 2019/11/5.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "UILabel+Tool.h"

@implementation UILabel(Tool)

- (void)topAlignment{
    CGSize size = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    self.numberOfLines = 0;//为了添加\n必须为0
    NSInteger newLinesToPad = (self.frame.size.height - rect.size.height)/size.height;

    for (NSInteger i = 0; i < newLinesToPad; i ++) {
        self.text = [self.text stringByAppendingString:@"\n "];
    }
}

@end
