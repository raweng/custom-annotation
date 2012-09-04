//
//  MapViewController.m
//  CustomAnnotation
//
//  Created by akshay on 8/11/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import "MapViewController.h"
#import "Annotation.h"
#import "CustomAnnotationView.h"

@implementation MapViewController

@synthesize geomapView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0/255.0 green:51/255.0 blue:153/255.0 alpha:1.0]];
      
    geomapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:geomapView];
    [geomapView setShowsUserLocation:YES];
    
    [geomapView setDelegate:self];
    
    UILongPressGestureRecognizer *dropPin = [[UILongPressGestureRecognizer alloc] init];
    [dropPin addTarget:self action:@selector(handleLongPress:)];
	dropPin.minimumPressDuration = 0.5; 
	[geomapView addGestureRecognizer:dropPin];
    
    [self setTitle:@"Map View"];
    
    Annotation *ann = [[Annotation alloc]initWithLocation:CLLocationCoordinate2DMake(37.616815,-122.389682)];
    [geomapView addAnnotation:ann];
    ann.title = @"title";
    ann.locationType = @"airport";

    Annotation *ann1 = [[Annotation alloc]initWithLocation:CLLocationCoordinate2DMake(18.922749,72.831673)];
    [geomapView addAnnotation:ann1];
    ann1.title = @"title";
    ann1.locationType = @"restaurant";
    
    Annotation *ann2 = [[Annotation alloc]initWithLocation:CLLocationCoordinate2DMake(37.604287,-122.396269)];
    [geomapView addAnnotation:ann2];
    ann2.title = @"title";
    ann2.locationType = @"shopping";
    
    [geomapView setRegion:MKCoordinateRegionMake(ann.coordinate, MKCoordinateSpanMake(0.04,0.04))];
    [geomapView selectAnnotation:ann animated:YES];
}



- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {	
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
	if([gestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]] && (gestureRecognizer.state == UIGestureRecognizerStateEnded)) {
		[geomapView removeGestureRecognizer:gestureRecognizer]; //avoid multiple pins to appear when holding on the screen
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:geomapView];   
    CLLocationCoordinate2D touchMapCoordinate = [geomapView convertPoint:touchPoint toCoordinateFromView:geomapView];
	
    Annotation *annotation = [[Annotation alloc]initWithLocation:touchMapCoordinate];
    
    annotation.title = [NSString stringWithFormat:@"Dropped Pin"];
    annotation.locationType = @"dropped";
    [geomapView addAnnotation:annotation];
    
    [geomapView selectAnnotation:annotation animated:YES];
    
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[Annotation class]]){
        // Try to dequeue an existing pin view first.
        CustomAnnotationView* pinView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView){
            // If an existing pin view was not available, create one.
            pinView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotationView"];
            [pinView setPinColor:MKPinAnnotationColorGreen];
            [pinView setAnimatesDrop:YES];
            [pinView setCanShowCallout:YES];
            [pinView setDraggable:YES];
        }
        else
            pinView.annotation = annotation;
        
        return pinView;
    }
    
    return nil;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
