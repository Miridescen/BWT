
//
//  MSTipView.m
//  BWT
//
//  Created by Miridescent on 2019/10/15.
//  Copyright © 2019 Miridescent. All rights reserved.
//

#import "MSTipView.h"

@interface MSTipView ()

@property (nonatomic, strong) UILabel *titleLable;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) UIView *fatherView;

@property (nonatomic, strong) NSTimer *dlgTimer;

@end

@implementation MSTipView

- (void)dealloc
{
    if (self.fatherView != nil) {
        self.fatherView = nil;
    }
    [self.dlgTimer invalidate];
    self.dlgTimer = nil;
    
    
    
}

- (id)initWithView:(UIView *)view message:(NSString *)message{
    
    self = [super initWithFrame:view.bounds];
    if (self) {
        self.fatherView = view;
        
        self.showTime = [message length] * 0.3;
        self.showTime = self.showTime > 2 ? self.showTime : 2;
        
        self.showBackgroundView = NO;
        
        self.posY = 0;
        
        self.backgroundColor = [UIColor clearColor];
        self.message = message;
//        self.frame = CGRectMake(0, 0, 100, 100);
        
    }
    
    return self;
    
}
- (id)initWithView:(UIView *)view title:(NSString *)title message:(NSString *)message{
    
    self = [self initWithView:view message:message];
    self.title = title;
    return self;
}

- (id)initWithWindow:(UIWindow *)window message:(NSString *)message{
    
    self = [super initWithFrame:window.bounds];
        if (self) {
            self.fatherView = window;
            
            self.showTime = [message length] * 0.3;
            self.showTime = self.showTime > 2 ? self.showTime : 2;
            
            self.showBackgroundView = NO;
            
            self.posY = 0;
            
            self.backgroundColor = [UIColor clearColor];
            self.message = message;
    //        self.frame = CGRectMake(0, 0, 100, 100);
            
        }
        
        return self;
    
    
}
- (id)initWithWindow:(UIWindow *)window title:(NSString *)title message:(NSString *)message{
    
    
    self = [self initWithWindow:window message:message];
    self.title = title;
    return self;
}

+ (void)showWithMessage:(NSString *)message{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MSTipView *tipView = [[self alloc] initWithWindow:window message:message];
    [tipView show];
}


- (UILabel *)titleLable{
    
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.numberOfLines = 0;
        _titleLable.backgroundColor = [UIColor clearColor];
        _titleLable.font = [UIFont systemFontOfSize:17.0f];
        _titleLable.lineBreakMode = NSLineBreakByCharWrapping;
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = [UIColor whiteColor];
    }
    return _titleLable;
    
}

- (UILabel *)messageLabel{
    
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.numberOfLines = 0;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _messageLabel.adjustsFontSizeToFitWidth = YES;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
    }
    return _messageLabel;
    
}

- (void)show{
    
    [self.fatherView addSubview:self];
    
    _dlgTimer = [NSTimer scheduledTimerWithTimeInterval:_showTime target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    
}
- (void)dismiss{
    
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self.dlgTimer invalidate];
        self.dlgTimer = nil;
        
        [self removeFromSuperview];
    }];
    
    
}
- (void)dismiss:(BOOL)animation{
    
    if (animation) {
        [self dismiss];
    } else {
        
        [self.dlgTimer invalidate];
        self.dlgTimer = nil;
        [self removeFromSuperview];
    }
    
}
- (void)dismiss:(BOOL)animation callback:(SEL)sel{
    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([self.title length] == 0) {
        NSDictionary *messageAttributedDic = @{
                                               NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size:14]
                                               };
        CGRect messageRect = [self.message boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:messageAttributedDic context:nil];
        CGSize messageSize = messageRect.size;
        
        CGSize maskSize = CGSizeMake(messageSize.width+40, messageSize.height+20);
        
        CGFloat centerY;
        if (self.posY) {
            centerY = _posY + maskSize.height;
        } else {
            centerY = 0.382 * self.frame.size.height;
        }

        if (self.showBackgroundView) {
            
            size_t gradLocationsNum = 2;
            CGFloat gradLocations[2] = {0.0f, 1.0f};
            CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.6f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
            CGColorSpaceRelease(colorSpace);
            
            //Gradient center
            CGPoint gradCenter = CGPointMake(self.width/2,  centerY);
            //Gradient radius
            //float gradRadius =  (self.bounds.size.height-_posY)*2;
            float gradRadius = 350;
            //Gradient draw
            CGContextDrawRadialGradient (context, gradient, gradCenter,
                                         0, gradCenter, gradRadius,
                                         kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
        }
        
        CGRect messageLabelFrame = CGRectMake(self.frame.size.width/2-messageSize.width/2, centerY-messageSize.height/2, messageSize.width, messageSize.height);
        CGRect maskFrame = CGRectMake(self.frame.size.width/2-maskSize.width/2, centerY-maskSize.height/2, maskSize.width, maskSize.height);
        
        float fw, fh;
        CGContextSaveGState(context); // 2
        CGContextTranslateCTM (context, CGRectGetMinX(maskFrame), // 3
                               CGRectGetMinY(maskFrame));
        CGContextScaleCTM (context, 3.0f, 3.0f); // 4
        fw = CGRectGetWidth (maskFrame) / 3.0f; // 5
        fh = CGRectGetHeight (maskFrame) / 3.0f; // 6
        CGContextMoveToPoint(context, fw, fh/2); // 7
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); // 8
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // 9
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // 10
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
        CGContextClosePath(context); // 12
        CGContextRestoreGState(context); // 13
        
        CGFloat black[4] = {0.0, 0.0, 0.0, 0.7f};
        CGContextSetFillColor(context, black);
        CGContextFillPath(context);
        
        
        self.messageLabel.frame = messageLabelFrame;
        self.messageLabel.text = _message;
        [self addSubview:self.messageLabel];
    } else {
        
        CGSize titleSize = CGSizeMake(200, 20);
        
        NSDictionary *messageAttributedDic = @{
                                               NSFontAttributeName : [UIFont fontWithName:@"PingFangSC-Medium" size:14]
                                               };
        CGRect messageRect = [self.message boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:messageAttributedDic context:nil];
        CGSize messageSize = messageRect.size;
        
        CGSize maskSize = CGSizeMake(titleSize.width+40, titleSize.height+messageSize.height+20);
        
        CGFloat centerY;
        if (self.posY) {
            centerY = _posY + maskSize.height;
        } else {
            centerY = 0.382 * self.frame.size.height;
        }
        
        if (self.showBackgroundView) {

            size_t gradLocationsNum = 2;
            CGFloat gradLocations[2] = {0.0f, 1.0f};
            CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.6f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
            CGColorSpaceRelease(colorSpace);

            //Gradient center
            CGPoint gradCenter = CGPointMake(self.width/2,  centerY);
            //Gradient radius
            //float gradRadius =  (self.bounds.size.height-_posY)*2;
            float gradRadius = 350;
            //Gradient draw
            CGContextDrawRadialGradient (context, gradient, gradCenter,
                                         0, gradCenter, gradRadius,
                                         kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
        }
        
        CGRect maskFrame = CGRectMake(self.frame.size.width/2-maskSize.width/2, centerY-maskSize.height/2, maskSize.width, maskSize.height);
        CGRect titleFrame = CGRectMake(self.frame.size.width/2-titleSize.width/2, maskFrame.origin.y+13, titleSize.width, titleSize.height);
        CGRect messageLabelFrame = CGRectMake(self.frame.size.width/2-messageSize.width/2, CGRectGetMaxY(titleFrame)+5, messageSize.width, messageSize.height);
        
        float fw, fh;
        CGContextSaveGState(context); // 2
        CGContextTranslateCTM (context, CGRectGetMinX(maskFrame), // 3
                               CGRectGetMinY(maskFrame));
        CGContextScaleCTM (context, 3.0f, 3.0f); // 4
        fw = CGRectGetWidth (maskFrame) / 3.0f; // 5
        fh = CGRectGetHeight (maskFrame) / 3.0f; // 6
        CGContextMoveToPoint(context, fw, fh/2); // 7
        CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1); // 8
        CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // 9
        CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // 10
        CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
        CGContextClosePath(context); // 12
        CGContextRestoreGState(context); // 13
        
        CGFloat black[4] = {0.0, 0.0, 0.0, 0.7f};
        CGContextSetFillColor(context, black);
        CGContextFillPath(context);
        
        
        self.titleLable.text = self.title;
        self.titleLable.frame = titleFrame;
        [self addSubview:self.titleLable];
        
        self.messageLabel.frame = messageLabelFrame;
        self.messageLabel.text = _message;
        [self addSubview:self.messageLabel];
        
    }
    
}

@end
