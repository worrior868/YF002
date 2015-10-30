//
//  MYIntroductionPanel.m
//  MYBlurIntroductionView-Example
//
//  Created by Matthew York on 10/16/13.
//  Copyright (c) 2013 Matthew York. All rights reserved.
//

#import "MYIntroductionPanel.h"

@interface MYIntroductionPanel ()

@property (nonatomic, retain) UIView *PanelHeaderView;
@property (nonatomic, retain) NSString *PanelTitle;
@property (nonatomic, retain) NSString *PanelDescription;
@property (nonatomic, retain) UILabel *PanelTitleLabel;
@property (nonatomic, retain) UILabel *PanelDescriptionLabel;
@property (nonatomic, retain) UIView *PanelSeparatorLine;
@property (nonatomic, retain) UIImageView *PanelImageView;

@property (nonatomic, assign) BOOL isCustomPanel;
@property (nonatomic, assign) BOOL hasCustomAnimation;

//panel1
@property (weak, nonatomic) IBOutlet UIImageView *p1_device;
@property (weak, nonatomic) IBOutlet UIImageView *p1_person;
@property (weak, nonatomic) IBOutlet UILabel *p1_label1;
@property (weak, nonatomic) IBOutlet UILabel *p1_label2;
@property (weak, nonatomic) IBOutlet UIImageView *p1_phone;

//panel2
@property (weak, nonatomic) IBOutlet UIImageView *p2_hand;
@property (weak, nonatomic) IBOutlet UIImageView *p2_phone;
@property (weak, nonatomic) IBOutlet UILabel *p2_label;

//panel3
@property (weak, nonatomic) IBOutlet UIImageView *p3_pic;
@property (weak, nonatomic) IBOutlet UILabel *p3_label;

@end

@implementation MYIntroductionPanel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeConstants];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description{
    return [self initWithFrame:frame title: title description: description header: nil];
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description header:(UIView *)headerView{
    return [self initWithFrame: frame title: title description: description image: nil header: headerView];
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image{
    return [self initWithFrame: frame title: title description: description image: image header: nil];
}

-(id)initWithFrame:(CGRect)frame title:(NSString *)title description:(NSString *)description image:(UIImage *)image header:(UIView *)headerView{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeConstants];
        
        self.PanelHeaderView = headerView;
        self.PanelTitle = title;
        self.PanelDescription = description;
        self.PanelImageView = [[UIImageView alloc] initWithImage:image];
        [self buildPanelWithFrame:frame];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame nibNamed:(NSString *)nibName{
    self = [super init];
    if (self) {
        // Initialization code
        self = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][0];
        self.frame = frame;
        _isCustomPanel = YES;
        _hasCustomAnimation = NO;
    }
    return self;
}

-(void)initializeConstants{
    kTitleFont = [UIFont boldSystemFontOfSize:21];
    kTitleTextColor = [UIColor whiteColor];
    kDescriptionFont = [UIFont systemFontOfSize:14];
    kDescriptionTextColor = [UIColor whiteColor];
    kSeparatorLineColor = [UIColor colorWithWhite:0 alpha:0.1];
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)buildPanelWithFrame:(CGRect)frame{
    CGFloat panelTitleHeight = 0;
    CGFloat panelDescriptionHeight = 0;
    
    CGFloat runningYOffset = kTopPadding;
    
    //Process panel header view, if it exists
    if (self.PanelHeaderView) {
        self.PanelHeaderView.frame = CGRectMake((frame.size.width - self.PanelHeaderView.frame.size.width)/2, runningYOffset, self.PanelHeaderView.frame.size.width, self.PanelHeaderView.frame.size.height);
        [self addSubview:self.PanelHeaderView];
        
        runningYOffset += self.PanelHeaderView.frame.size.height + kHeaderTitlePadding;
    }
    
    //Calculate title and description heights
    if ([MYIntroductionPanel runningiOS7]) {
        //Calculate Title Height
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:kTitleFont forKey: NSFontAttributeName];
        panelTitleHeight = [self.PanelTitle boundingRectWithSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil].size.height;
        panelTitleHeight = ceilf(panelTitleHeight);
        
        //Calculate Description Height
        NSDictionary *descriptionAttributes = [NSDictionary dictionaryWithObject:kDescriptionFont forKey: NSFontAttributeName];
        panelDescriptionHeight = [self.PanelDescription boundingRectWithSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:descriptionAttributes context:nil].size.height;
        panelDescriptionHeight = ceilf(panelDescriptionHeight);
    }
    else {
//        panelTitleHeight = [self.PanelTitle sizeWithFont:kTitleFont constrainedToSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
//        
//        panelDescriptionHeight = [self.PanelDescription sizeWithFont:kDescriptionFont constrainedToSize:CGSizeMake(frame.size.width - 2*kLeftRightMargins, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping].height;
    }
    
    //Create title label
    self.PanelTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftRightMargins, runningYOffset, frame.size.width - 2*kLeftRightMargins, panelTitleHeight)];
    self.PanelTitleLabel.numberOfLines = 0;
    self.PanelTitleLabel.text = self.PanelTitle;
    self.PanelTitleLabel.font = kTitleFont;
    self.PanelTitleLabel.textColor = kTitleTextColor;
    self.PanelTitleLabel.alpha = 0;
    self.PanelTitleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.PanelTitleLabel];
    runningYOffset += panelTitleHeight + kTitleDescriptionPadding;
    
    
    //Add small line in between title and description
    self.PanelSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(kLeftRightMargins, runningYOffset - 0.5*kTitleDescriptionPadding, frame.size.width - 2*kLeftRightMargins, 1)];
    self.PanelSeparatorLine.backgroundColor = kSeparatorLineColor;
     [self addSubview:self.PanelSeparatorLine];
    
    //Create description label
    self.PanelDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftRightMargins, runningYOffset, frame.size.width - 2*kLeftRightMargins, panelDescriptionHeight)];
    self.PanelDescriptionLabel.numberOfLines = 0;
    self.PanelDescriptionLabel.text = self.PanelDescription;
    self.PanelDescriptionLabel.font = kDescriptionFont;
    self.PanelDescriptionLabel.textColor = kDescriptionTextColor;
    self.PanelDescriptionLabel.alpha = 0;
    self.PanelDescriptionLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.PanelDescriptionLabel];
    
    runningYOffset += panelDescriptionHeight + kDescriptionImagePadding;
    
    //Add image, if there is room
    if (self.PanelImageView.image) {
        self.PanelImageView.frame = CGRectMake(kLeftRightMargins, runningYOffset, self.frame.size.width - 2*kLeftRightMargins, self.frame.size.height - runningYOffset - kBottomPadding);
        self.PanelImageView.contentMode = UIViewContentModeCenter;
        self.PanelImageView.clipsToBounds = YES;
        [self addSubview:self.PanelImageView];
    }

    // If this is a custom panel, set the has Custom animation boolean
    if (self.isCustomPanel == YES) {
        self.hasCustomAnimation = YES;
    }
}

- (void) hideContent
{
    _PanelTitleLabel.alpha = 0;
    _PanelDescriptionLabel.alpha = 0;
    _PanelSeparatorLine.alpha = 0;
    if (_PanelHeaderView) {
        _PanelHeaderView.alpha = 0;
    }
    _PanelImageView.alpha = 0;
}

- (void) showContent
{
    if (_isCustomPanel && !_hasCustomAnimation) {
        return;
    }
    
    //Get initial frames
    CGRect initialHeaderFrame = CGRectZero;
    if ([self PanelHeaderView]) {
        initialHeaderFrame = [self PanelHeaderView].frame;
    }
    CGRect initialTitleFrame = [self PanelTitleLabel].frame;
    CGRect initialDescriptionFrame = [self PanelDescriptionLabel].frame;
    CGRect initialImageFrame = [self PanelImageView].frame;
    
    //Offset frames
    [[self PanelTitleLabel] setFrame:CGRectMake(initialTitleFrame.origin.x + 10, initialTitleFrame.origin.y, initialTitleFrame.size.width, initialTitleFrame.size.height)];
    [[self PanelDescriptionLabel] setFrame:CGRectMake(initialDescriptionFrame.origin.x + 10, initialDescriptionFrame.origin.y, initialDescriptionFrame.size.width, initialDescriptionFrame.size.height)];
    [[self PanelHeaderView] setFrame:CGRectMake(initialHeaderFrame.origin.x, initialHeaderFrame.origin.y - 10, initialHeaderFrame.size.width, initialHeaderFrame.size.height)];
    [[self PanelImageView] setFrame:CGRectMake(initialImageFrame.origin.x, initialImageFrame.origin.y + 10, initialImageFrame.size.width, initialImageFrame.size.height)];
    
    //Animate title and header
    [UIView animateWithDuration:0.3 animations:^{
        [[self PanelTitleLabel] setAlpha:1];
        [[self PanelTitleLabel] setFrame:initialTitleFrame];
        [[self PanelSeparatorLine] setAlpha:1];
        
        if ([self PanelHeaderView]) {
            [[self PanelHeaderView] setAlpha:1];
            [[self PanelHeaderView] setFrame:initialHeaderFrame];
        }
    } completion:^(BOOL finished) {
        //Animate description
        [UIView animateWithDuration:0.3 animations:^{
            [[self PanelDescriptionLabel] setAlpha:1];
            [[self PanelDescriptionLabel] setFrame:initialDescriptionFrame];
            [[self PanelImageView] setAlpha:1];
            [[self PanelImageView] setFrame:initialImageFrame];
        }];
    }];
}

+(BOOL)runningiOS7{
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if (currSysVer.floatValue >= 7.0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Interaction Methods

-(void)panelDidAppear{
    /*
     /panel1
     @property (weak, nonatomic) IBOutlet UIImageView *p1_device;
     @property (weak, nonatomic) IBOutlet UIImageView *p1_person;
     @property (weak, nonatomic) IBOutlet UILabel *p1_label1;
     @property (weak, nonatomic) IBOutlet UILabel *p1_label2;
     @property (weak, nonatomic) IBOutlet UIImageView *p1_phone;
     
     //panel2
     @property (weak, nonatomic) IBOutlet UIImageView *p2_hand;
     @property (weak, nonatomic) IBOutlet UIImageView *p2_phone;
     @property (weak, nonatomic) IBOutlet UILabel *p2_label;
     
     //panel3
     @property (weak, nonatomic) IBOutlet UIImageView *p3_pic;
     @property (weak, nonatomic) IBOutlet UILabel *p3_label;
     */
    
    ///panel1
    _p1_device.alpha= 0.1;
    [UIView animateWithDuration:0.1 animations:^{
        _p1_device.transform =CGAffineTransformMakeTranslation(0, -80);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _p1_device.transform = CGAffineTransformMakeTranslation(0, 0);
            _p1_device.alpha =1.0;
        }];
    }];
    
    _p1_person.alpha= 0.0;
    [UIView animateWithDuration:0.8 animations:^{
        _p1_person.transform =CGAffineTransformMakeTranslation(0, -80);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _p1_person.transform = CGAffineTransformMakeTranslation(0, 0);
            _p1_person.alpha =1.0;
        }];
    }];
    
    _p1_label1.alpha= 0.0;
    [UIView animateWithDuration:1.5 animations:^{
        _p1_label1.transform =CGAffineTransformMakeTranslation(-80, 0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _p1_label1.transform = CGAffineTransformMakeTranslation(0, 0);
            _p1_label1.alpha =1.0;
        }];
    }];
    
    _p1_phone.alpha= 0.0;
    [UIView animateWithDuration:1.5 animations:^{
        _p1_phone.transform =CGAffineTransformMakeTranslation(0, 120);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _p1_phone.transform = CGAffineTransformMakeTranslation(0, 0);
            _p1_phone.alpha =1.0;
        }];
    }];
    
    
    _p1_label2.alpha= 0.0;
    [UIView animateWithDuration:2 animations:^{
        _p1_label2.transform =CGAffineTransformMakeTranslation(120, 0);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _p1_label2.transform = CGAffineTransformMakeTranslation(0, 0);
            _p1_label2.alpha =1.0;
        }];
    }];
    ///panel2
     _p2_label.alpha =0.0;
    [UIView animateWithDuration:1 animations:^{
         _p2_label.alpha =1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
           
        }];
    }];
    

    _p2_phone.alpha= 0.1;
    [UIView animateWithDuration:0.1 animations:^{
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _p2_phone.transform = CGAffineTransformMakeTranslation(0, 0);
            _p2_phone.alpha =1.0;
        }];
    }];
    
    _p2_hand.alpha= 1.0;

    [UIView animateWithDuration:2 delay:0.2 options:UIViewAnimationOptionAutoreverse animations:^{
        _p2_hand.transform =CGAffineTransformMakeTranslation(-50, 0);
    } completion:^(BOOL finished) {
        _p2_hand.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
    
    ///panel3
    _p3_pic.alpha= 0.1;
    [UIView animateWithDuration:0.4 animations:^{
        _p3_pic.transform= CGAffineTransformMakeScale(1.5, 1.5);
        _p3_pic.alpha= 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _p3_pic.transform= CGAffineTransformMakeScale(1, 1);
            _p3_pic.alpha= 1;
        }];
    }];
    
    _p3_label.alpha= 0.1;
    [UIView animateWithDuration:0.8 animations:^{
        _p3_label.transform = CGAffineTransformMakeTranslation(0, 80);
        _p3_label.alpha= 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
            _p3_label.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }];
   
}

-(void)panelDidDisappear{
    //Implemented by subclass
}


@end
