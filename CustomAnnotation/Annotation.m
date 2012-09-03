//
//  Annotation.m
//  CustomAnnotation
//
//  Created by akshay on 8/14/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
@synthesize locationType;



- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate; 
}

@end
