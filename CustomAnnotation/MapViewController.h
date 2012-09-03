//
//  MapViewController.h
//  GeoPOC
//
//  Created by raw engineering, inc on 8/11/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MessageUI/MessageUI.h"
#import "CustomAnnotationView.h"

@class Annotation;
@interface MapViewController : UIViewController<MKMapViewDelegate, MFMessageComposeViewControllerDelegate, CustomAnnotationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) MKMapView *geomapView;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) UIBarButtonItem *compassBarButton;
@property (strong, nonatomic) UIBarButtonItem *dropPinBarButton;
@property (strong, nonatomic) UIBarButtonItem *shareMyLocationBarButton;
@property (assign, nonatomic) BOOL showHeading;
@property (strong, nonatomic) UIImageView* adImageView;

- (void)dropPinAt:(NSArray *)latLongArray;
- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer;
- (void)showCurrentLocation;
- (void)dropPin;
- (void)removeAllAnnotations;
- (void)shareLocation:(id<MKAnnotation>)annotation;
- (void)addBannerAd;
@end
