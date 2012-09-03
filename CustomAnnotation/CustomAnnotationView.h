//
//  CustomAnnotationView.h
//  GeoPOC
//
//  Created by raw engineering, inc on 8/17/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol CustomAnnotationDelegate;

@interface CustomAnnotationView : MKPinAnnotationView

@property (strong, nonatomic) UIView *calloutView;
@property (assign, nonatomic) CGRect endFrame;
@property (strong, nonatomic) id <CustomAnnotationDelegate> delegate;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UIButton *clearButton;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)animateCalloutAppearance;
- (void)buttonClicked:(id)sender;

@end

@protocol CustomAnnotationDelegate <NSObject>

@optional
- (void)didSelectButtonAtIndex:(NSInteger)index forAnnotation:(id<MKAnnotation>)annotation;

@end