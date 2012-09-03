//
//  MapViewController.m
//  GeoPOC
//
//  Created by raw engineering, inc on 8/11/12.
//  Copyright (c) 2012 raw engineering, inc. All rights reserved.
//

#import "MapViewController.h"
#import "Annotation.h"
#import "MessageUI/MessageUI.h"
#import "CustomAnnotationView.h"
#import "AppConstants.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"

@implementation MapViewController

@synthesize geomapView;
@synthesize geocoder;
@synthesize compassBarButton;
@synthesize dropPinBarButton;
@synthesize shareMyLocationBarButton;
@synthesize showHeading;
@synthesize adImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dropPinAt:(NSArray *)latLongArray{
    Annotation *ann = [[Annotation alloc]initWithLocation:CLLocationCoordinate2DMake([[latLongArray objectAtIndex:0] floatValue], [[latLongArray objectAtIndex:1] floatValue])];
    [ann setUserType:RECEIVER];
    [ann setTitle:@"Shared Pin"];
    if ([latLongArray count]>=3) {
        [ann setDate:[NSString stringWithFormat:@"%@",[latLongArray objectAtIndex:2]]];
    }
    [geomapView addAnnotation:ann];
    [geomapView selectAnnotation:ann animated:YES];
//    [geomapView setCenterCoordinate:CLLocationCoordinate2DMake([[latLongArray objectAtIndex:0] floatValue], [[latLongArray objectAtIndex:1] floatValue])];
    [geomapView setRegion:MKCoordinateRegionMake(CLLocationCoordinate2DMake([[latLongArray objectAtIndex:0] floatValue], [[latLongArray objectAtIndex:1] floatValue]), MKCoordinateSpanMake(0.004, 0.004))];
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

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"viewWillAppear MAP");
    [super viewWillAppear:YES];
            [self.navigationController.navigationBar setFrame:CGRectMake(0, 50, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
        [self addBannerAd];
    NSLog(@"NavBar %f",self.navigationController.navigationBar.frame.origin.y);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0/255.0 green:51/255.0 blue:153/255.0 alpha:1.0]];
    
//    [self.navigationController.navigationBar setFrame:CGRectMake(0, 50, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
//    [self addBannerAd];
    
    showHeading = NO;
    
    compassBarButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_compass.png"] 
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self 
                                                      action:@selector(showCurrentLocation)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:nil
                                                                                  action:nil];
    
    dropPinBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Drop Pin"                 
                                                       style:UIBarButtonItemStyleBordered
                                                      target:self
                                                      action:@selector(dropPin)];
    
    shareMyLocationBarButton = [[UIBarButtonItem alloc]initWithTitle:@"Share My Location"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(shareMyLocation)];

    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:flexibleSpace, compassBarButton, flexibleSpace, dropPinBarButton, flexibleSpace, shareMyLocationBarButton, flexibleSpace, nil] 
                                      animated:YES];
    
    
    geomapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:geomapView];
    [geomapView setShowsUserLocation:YES];
    
    [geomapView setDelegate:self];
    
    UILongPressGestureRecognizer *dropPin = [[UILongPressGestureRecognizer alloc] init];
    [dropPin addTarget:self action:@selector(handleLongPress:)];
	dropPin.minimumPressDuration = 0.5; 
	[geomapView addGestureRecognizer:dropPin];
}

- (void)addBannerAd{
    if (!adImageView) {
        adImageView = [[UIImageView alloc]init];
    }else{
        if ([AppDelegate instance].isAwayFromArena) {
            [adImageView setImage:[UIImage imageNamed:@"ad_montereyBayAquarium_320x30.png"]];
        }else{
            if ([AppDelegate instance].distance > 75) {
                [adImageView setImage:[UIImage imageNamed:@"ad_montereyBayAquarium_320x30.png"]];
            }else {
                [adImageView setImage:[UIImage imageNamed:@"ad_nbaSponsored_320x30.png"]];
            }
        }
        
        [adImageView setFrame:CGRectMake(0, 20, 0, 0)];
        [adImageView sizeToFit];
        [self.navigationController.view addSubview:adImageView];
    }
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
    
    if (geocoder) {
        [geocoder cancelGeocode];
    }

    [self removeAllAnnotations];
    annotation.title = [NSString stringWithFormat:@"Dropped Pin"];
    [annotation setUserType:SENDER];
    [geomapView addAnnotation:annotation];
    
    [geomapView selectAnnotation:annotation animated:YES];
    
    [dropPinBarButton setTitle:@"Replace Pin"];
}

#pragma mark Methods for pointing location

- (void)showCurrentLocation{
    if (showHeading) {
        [compassBarButton setImage:[UIImage imageNamed:@"icon_compass_orientLoc.png"]];
        [geomapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
        showHeading = NO;
    }else{
        showHeading = YES;
        [compassBarButton setImage:[UIImage imageNamed:@"icon_compass.png"]];
        [geomapView setUserTrackingMode:MKUserTrackingModeNone];
        [geomapView setCenterCoordinate:geomapView.userLocation.location.coordinate animated:YES];
    }
}

- (void)dropPin{
    [dropPinBarButton setTitle:@"Replace Pin"];
    Annotation *annotation = [[Annotation alloc]initWithLocation:geomapView.centerCoordinate];
    [self removeAllAnnotations];
    annotation.title = [NSString stringWithFormat:@"Dropped Pin"];
    [annotation setUserType:SENDER];
    [geomapView addAnnotation:annotation];
    [geomapView selectAnnotation:annotation animated:YES];
}

- (void)shareMyLocation{
    [self shareLocation:geomapView.userLocation];
}


- (void)shareLocation:(id<MKAnnotation>)annotation{
    
//    MKNetworkEngine *bitlyEngine = [[MKNetworkEngine alloc]initWithHostName:BITLY_HOSTNAME];
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:BITLY_USERNAME,@"login",BITLY_APIKEY,@"apiKey",@"",@"longUrl",@"json",@"format," nil];
//    MKNetworkOperation *op = [bitlyEngine operationWithPath:@"v3/shorten" params:params httpMethod:@"GET" ssl:NO];
//    [op onCompletion:^(MKNetworkOperation *completedOperation) {
//        NSLog(@"response %@",[completedOperation responseJSON]);
//    } onError:^(NSError *error) {
//        NSLog(@"error %@",error);
//    }];
//    [bitlyEngine enqueueOperation:op];
    
    Annotation *ann = (Annotation *)annotation;
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
        NSString *linkToShare = [[NSString stringWithFormat:@"gsw://%f,%f,%@",ann.coordinate.latitude,ann.coordinate.longitude,[NSDate date]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		controller.body = [NSString stringWithFormat:@"Here's my location at Oracle Arena: %@",linkToShare];
		controller.messageComposeDelegate = self;
		[self presentModalViewController:controller animated:YES];
	}
}

- (void)removeAllAnnotations{
    for (Annotation *ann in geomapView.annotations) {
        if (![ann isKindOfClass:[MKUserLocation class]] && ![ann.userType isEqualToString:RECEIVER]) {
            [geomapView removeAnnotation:ann];
        }
    }
}

#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
//			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@”OK” otherButtonTitles: nil];
//			[alert show];
//			[alert release];
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[self dismissModalViewControllerAnimated:YES];
    [self viewWillAppear:YES];
}

#pragma mark MKMapView Delegate

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (geomapView.userTrackingMode == MKUserTrackingModeNone) {
        [geomapView setRegion:MKCoordinateRegionMake(geomapView.userLocation.location.coordinate, MKCoordinateSpanMake(0.004, 0.004))];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[Annotation class]]){
        // Try to dequeue an existing pin view first.
        CustomAnnotationView* pinView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        [pinView setDelegate:self];
        if (!pinView){
            // If an existing pin view was not available, create one.
            pinView = [[CustomAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:@"CustomPinAnnotation"];
            [pinView setDelegate:self];
            Annotation *ann = (Annotation *)annotation;
            if ([ann.userType isEqualToString:SENDER]) {
                [pinView setPinColor:MKPinAnnotationColorGreen];
            }else if([ann.userType isEqualToString:RECEIVER]) {
                [pinView setPinColor:MKPinAnnotationColorRed];
            }
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState{
    if (newState == MKAnnotationViewDragStateEnding){
        CLLocationCoordinate2D droppedAt = view.annotation.coordinate;
        NSLog(@"Pin dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
    }
}


-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    MKMapRect visibleRect = [mapView visibleMapRect];
    if (MKMapRectContainsPoint(visibleRect, MKMapPointForCoordinate(geomapView.userLocation.coordinate))) {
        CGRect centerRect = CGRectMake(120, 190, 80, 80);
        CGPoint point = [geomapView convertCoordinate:geomapView.userLocation.coordinate toPointToView:geomapView];
        if (!CGRectContainsPoint(centerRect, point)) {
            [compassBarButton setImage:[UIImage imageNamed:@"icon_compass.png"]];
            showHeading = NO;
        }
    }
}

-(void)mapView:(MKMapView *)mapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated{
    if (mode != MKUserTrackingModeFollowWithHeading) {
        [compassBarButton setImage:[UIImage imageNamed:@"icon_compass.png"]];
    }
}

#pragma mark CustomAnnotationDelegate

-(void)didSelectButtonAtIndex:(NSInteger)index forAnnotation:(id<MKAnnotation>)annotation{
     Annotation *ann = (Annotation *)annotation;
    if (index == 0) {
        [geomapView deselectAnnotation:annotation animated:YES];
        [self shareLocation:ann];
        
    }else if (index == 1){
        [geomapView removeAnnotation:annotation];
        if ([ann.userType isEqualToString:SENDER]) {
            [dropPinBarButton setTitle:@"Drop Pin"];
        }
    }
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
