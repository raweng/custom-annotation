//
//  CustomAnnotationView.h
//  CustomAnnotation
//
//  Created by akshay on 8/17/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotationView : MKPinAnnotationView

@property (strong, nonatomic) UIImageView *calloutView;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)animateCalloutAppearance;

@end