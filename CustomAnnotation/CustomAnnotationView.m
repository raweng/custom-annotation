//
//  CustomAnnotationView.m
//  GeoPOC
//
//  Created by raw engineering, inc on 8/17/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "Annotation.h"
#import "AppConstants.h"

@implementation CustomAnnotationView

@synthesize calloutView;
@synthesize endFrame;
@synthesize delegate;
@synthesize shareButton;
@synthesize dateLabel;
@synthesize clearButton;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    Annotation *ann = self.annotation;
    if(selected)
    {
        //Add your custom view to self...
        calloutView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"graphic_mapCallout.png"]];
        [calloutView setFrame:CGRectMake(-46, 35, 0, 0)];
        [calloutView setUserInteractionEnabled:YES];
        [calloutView sizeToFit];
        
        CGFloat bottom;
        
        if ([ann.userType isEqualToString:SENDER]) {
            shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [shareButton setTitle:SHARE forState:UIControlStateNormal];
            [shareButton setFrame:CGRectMake(12, 25, 88, 25)];
            [shareButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
            [shareButton setTag:0];
            [calloutView addSubview:shareButton];
            bottom = shareButton.frame.origin.y + shareButton.frame.size.height + 7;
        }else if([ann.userType isEqualToString:RECEIVER]) {
            dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 25, 88, 30)];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ssZZZZ"];

            NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
            [formatter2 setDateFormat:@"MM/dd/yyyy h:mm a"];
            
            [dateLabel setText:[NSString stringWithFormat:@"Sent %@",[formatter2 stringFromDate:[formatter dateFromString:[ann.date stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]]];
            
            formatter = nil;
            formatter2 = nil;
            
            [dateLabel setFont:[UIFont boldSystemFontOfSize:11.5]];
            [dateLabel setBackgroundColor:[UIColor clearColor]];
            [dateLabel setTextColor:[UIColor whiteColor]];
            [dateLabel setTextAlignment:UITextAlignmentCenter];
            [calloutView addSubview:dateLabel];
            [dateLabel setNumberOfLines:2];
            
            bottom = dateLabel.frame.origin.y + dateLabel.frame.size.height + 7;
        }
        
        clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [clearButton setTitle:CLEAR forState:UIControlStateNormal];
        [clearButton setFrame:CGRectMake(12, bottom, 88, 25)];
        [clearButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        [clearButton setTag:1];
        [calloutView addSubview:clearButton];

        [self animateCalloutAppearance];
        [self addSubview:calloutView];
    }
    else
    {
        //Remove your custom view...
        [calloutView removeFromSuperview];
    }
}

- (void)buttonClicked:(id)sender{
    UIButton *button = (UIButton *)sender;
    [delegate didSelectButtonAtIndex:button.tag forAnnotation:self.annotation];
}

- (void)didAddSubview:(UIView *)subview{
    if ([[[subview class] description] isEqualToString:@"UICalloutView"]) {
        for (UIView *subsubView in subview.subviews) {
            if ([subsubView class] == [UIImageView class]) {
                UIImageView *imageView = ((UIImageView *)subsubView);
                [imageView removeFromSuperview];
            }else if ([subsubView class] == [UILabel class]) {
                UILabel *labelView = ((UILabel *)subsubView);
                [labelView removeFromSuperview];
            }
        }
    }
}

- (void)animateCalloutAppearance {
    CGFloat scale = 0.001f;
    calloutView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -50);
    
    [UIView animateWithDuration:0.12f delay:0 options:UIViewAnimationCurveEaseOut animations:^{
        CGFloat scale = 1.05f;
        calloutView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
            CGFloat scale = 0.95;
            calloutView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, -2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut animations:^{
                CGFloat scale = 1.0;
                calloutView.transform = CGAffineTransformMake(scale, 0.0f, 0.0f, scale, 0, 0);
            } completion:nil];
        }];
    }];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    if (CGRectContainsPoint(calloutView.frame, point)) {
//        NSLog(@"YES");
//    }
//    NSLog(@"Point %f",point.x);
    return YES;
}


@end
