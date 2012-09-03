//
//  MapViewController.h
//  CustomAnnotation
//
//  Created by akshay on 8/11/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class Annotation;
@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *geomapView;

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer;
@end
