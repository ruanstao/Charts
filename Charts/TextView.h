//
//  PaoPaoTextView.h
//  Charts
//
//  Created by RuanSTao on 15/7/17.
//  Copyright (c) 2015年 JJS-iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UIView

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (void) showWithAnimation:(BOOL)animation;

-(void)hide;

@end
