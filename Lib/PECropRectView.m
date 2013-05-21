//
//  PECropRectView.m
//  PhotoCropEditor
//
//  Created by kishikawa katsumi on 2013/05/21.
//  Copyright (c) 2013 kishikawa katsumi. All rights reserved.
//

#import "PECropRectView.h"
#import "PEResizeControl.h"

@interface PECropRectView ()

@property (nonatomic) PEResizeControl *topLeftCornerView;
@property (nonatomic) PEResizeControl *topRightCornerView;
@property (nonatomic) PEResizeControl *bottomLeftCornerView;
@property (nonatomic) PEResizeControl *bottomRightCornerView;
@property (nonatomic) PEResizeControl *topEdgeView;
@property (nonatomic) PEResizeControl *leftEdgeView;
@property (nonatomic) PEResizeControl *bottomEdgeView;
@property (nonatomic) PEResizeControl *rightEdgeView;

@property (nonatomic) CGRect initialRect;
@property (nonatomic, getter = isLiveResizing) BOOL liveResizing;

@end

@implementation PECropRectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeRedraw;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, -2.0f, -2.0f)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.image = [[UIImage imageNamed:@"PEPhotoCropEditorBorder"] resizableImageWithCapInsets:UIEdgeInsetsMake(23.0f, 23.0f, 23.0f, 23.0f)];
        [self addSubview:imageView];
        
        self.topLeftCornerView = [[PEResizeControl alloc] init];
        self.topLeftCornerView.delegate = self;
        [self addSubview:self.topLeftCornerView];
        
        self.topRightCornerView = [[PEResizeControl alloc] init];
        self.topRightCornerView.delegate = self;
        [self addSubview:self.topRightCornerView];
        
        self.bottomLeftCornerView = [[PEResizeControl alloc] init];
        self.bottomLeftCornerView.delegate = self;
        [self addSubview:self.bottomLeftCornerView];
        
        self.bottomRightCornerView = [[PEResizeControl alloc] init];
        self.bottomRightCornerView.delegate = self;
        [self addSubview:self.bottomRightCornerView];
        
        self.topEdgeView = [[PEResizeControl alloc] init];
        self.topEdgeView.delegate = self;
        [self addSubview:self.topEdgeView];
        
        self.leftEdgeView = [[PEResizeControl alloc] init];
        self.leftEdgeView.delegate = self;
        [self addSubview:self.leftEdgeView];
        
        self.bottomEdgeView = [[PEResizeControl alloc] init];
        self.bottomEdgeView.delegate = self;
        [self addSubview:self.bottomEdgeView];
        
        self.rightEdgeView = [[PEResizeControl alloc] init];
        self.rightEdgeView.delegate = self;
        [self addSubview:self.rightEdgeView];
    }
    
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(self.topLeftCornerView.frame, point) ||
        CGRectContainsPoint(self.topRightCornerView.frame, point) ||
        CGRectContainsPoint(self.bottomLeftCornerView.frame, point) ||
        CGRectContainsPoint(self.bottomRightCornerView.frame, point) ||
        CGRectContainsPoint(self.topEdgeView.frame, point) ||
        CGRectContainsPoint(self.leftEdgeView.frame, point) ||
        CGRectContainsPoint(self.bottomEdgeView.frame, point) ||
        CGRectContainsPoint(self.rightEdgeView.frame, point)) {
        return [super hitTest:point withEvent:event];
    }
    
    return nil;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    UIColor *lineColor = [UIColor whiteColor];
    [lineColor set];
    
    for (NSInteger i = 1; i < 3; i++) {
        UIRectFill(CGRectMake(0.0f, roundf(height / 3 * i), roundf(width), 1.0f));
        UIRectFill(CGRectMake(roundf(width / 3 * i), 0.0f, 1.0f, roundf(height)));
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topLeftCornerView.frame = (CGRect){-2.0f, -2.0f, self.topLeftCornerView.bounds.size};
    self.topRightCornerView.frame = (CGRect){CGRectGetWidth(self.bounds) - CGRectGetWidth(self.topRightCornerView.bounds) + 2.0f, -2.0f, self.topLeftCornerView.bounds.size};
    self.bottomLeftCornerView.frame = (CGRect){-2.0f, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.bottomLeftCornerView.bounds) + 2.0f, self.bottomLeftCornerView.bounds.size};
    self.bottomRightCornerView.frame = (CGRect){CGRectGetWidth(self.bounds) - CGRectGetWidth(self.bottomRightCornerView.bounds) + 2.0f, CGRectGetHeight(self.bounds) - CGRectGetHeight(self.bottomRightCornerView.bounds) + 2.0f, self.bottomRightCornerView.bounds.size};
    self.topEdgeView.frame = (CGRect){CGRectGetMaxX(self.topLeftCornerView.frame), 0.0f, CGRectGetMinX(self.topRightCornerView.frame) - CGRectGetMaxX(self.topLeftCornerView.frame), CGRectGetHeight(self.topEdgeView.bounds)};
    self.leftEdgeView.frame = (CGRect){0.0f, CGRectGetMaxY(self.topLeftCornerView.frame), CGRectGetWidth(self.leftEdgeView.bounds), CGRectGetMinY(self.bottomLeftCornerView.frame) - CGRectGetMaxY(self.topLeftCornerView.frame)};
    self.bottomEdgeView.frame = (CGRect){CGRectGetMaxX(self.bottomLeftCornerView.frame), CGRectGetMinY(self.bottomLeftCornerView.frame) - 2.0f, CGRectGetMinX(self.bottomRightCornerView.frame) - CGRectGetMaxX(self.bottomLeftCornerView.frame), CGRectGetHeight(self.bottomEdgeView.bounds)};
    self.rightEdgeView.frame = (CGRect){CGRectGetWidth(self.bounds) - CGRectGetWidth(self.rightEdgeView.bounds), CGRectGetMaxY(self.topRightCornerView.frame), CGRectGetWidth(self.rightEdgeView.bounds), CGRectGetMinY(self.bottomRightCornerView.frame) - CGRectGetMaxY(self.topRightCornerView.frame)};
}

- (void)resizeConrolViewDidBeginResizing:(PEResizeControl *)resizeConrolView
{
    self.liveResizing = YES;
    self.initialRect = self.frame;
    
    if ([self.delegate respondsToSelector:@selector(cropRectViewDidBeginEditing:)]) {
        [self.delegate cropRectViewDidBeginEditing:self];
    }
}

- (void)resizeConrolViewDidResize:(PEResizeControl *)resizeConrolView
{
    self.frame = [self cropRectMakeWithResizeControlView:resizeConrolView];
        
    if ([self.delegate respondsToSelector:@selector(cropRectViewEditingChanged:)]) {
        [self.delegate cropRectViewEditingChanged:self];
    }
}

- (void)resizeConrolViewDidEndResizing:(PEResizeControl *)resizeConrolView
{
    self.liveResizing = NO;
    
    if ([self.delegate respondsToSelector:@selector(cropRectViewDidEndEditing:)]) {
        [self.delegate cropRectViewDidEndEditing:self];
    }
}

- (CGRect)cropRectMakeWithResizeControlView:(PEResizeControl *)resizeControlView
{
    CGRect rect = self.frame;
    
    if (resizeControlView == self.topEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect) + resizeControlView.translation.y,
                          CGRectGetWidth(self.initialRect),
                          CGRectGetHeight(self.initialRect) - resizeControlView.translation.y);
    } else if (resizeControlView == self.leftEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect) - resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect));
    } else if (resizeControlView == self.bottomEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect),
                          CGRectGetHeight(self.initialRect) + resizeControlView.translation.y);
    } else if (resizeControlView == self.rightEdgeView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect));
    } else if (resizeControlView == self.topLeftCornerView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetMinY(self.initialRect) + resizeControlView.translation.y,
                          CGRectGetWidth(self.initialRect) - resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect) - resizeControlView.translation.y);
    } else if (resizeControlView == self.topRightCornerView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect) + resizeControlView.translation.y,
                          CGRectGetWidth(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect) - resizeControlView.translation.y);
    } else if (resizeControlView == self.bottomLeftCornerView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect) - resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect) + resizeControlView.translation.y);
    } else if (resizeControlView == self.bottomRightCornerView) {
        rect = CGRectMake(CGRectGetMinX(self.initialRect),
                          CGRectGetMinY(self.initialRect),
                          CGRectGetWidth(self.initialRect) + resizeControlView.translation.x,
                          CGRectGetHeight(self.initialRect) + resizeControlView.translation.y);
    }
    
    CGFloat maxWidth = CGRectGetWidth(self.leftEdgeView.bounds) + CGRectGetWidth(self.rightEdgeView.bounds);
    if (CGRectGetWidth(rect) < maxWidth) {
        rect.origin.x = CGRectGetMaxX(self.frame) - maxWidth;
        rect.size.width = maxWidth;
    }
    
    CGFloat maxHeight = CGRectGetHeight(self.topEdgeView.bounds) + CGRectGetHeight(self.bottomEdgeView.bounds);
    if (CGRectGetHeight(rect) < maxHeight) {
        rect.origin.y = CGRectGetMaxY(self.frame) - maxHeight;
        rect.size.height = maxHeight;
    }
    
    return rect;
}

@end
