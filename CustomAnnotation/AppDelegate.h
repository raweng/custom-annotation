//
//  AppDelegate.h
//  CustomAnnotation
//
//  Created by akshay on 9/3/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) MapViewController *mapViewController;
@end
