//
//  WheresEditorViewController.m
//  GoldenKnowledge
//
//  Created by Bobie on 1/28/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import "WheresEditorViewController.h"
#import "MainViewController.h"

// Taipei 101
static NSString* STATIC_LOCATION_LATITUDE = @"25.033681";
static NSString* STATIC_LOCATION_LONGITUDE = @"121.56474";
static NSString* STATIC_EDITORS_CHOICE = @"想看什麼不會自己寫喔?!";


@interface WheresEditorViewController ()

@end

@implementation WheresEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.myMapView.delegate = self;
    
    [self performSelector:@selector(locationEditor) withObject:nil afterDelay:0.5];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMain:(id)sender {
    [self.parentMainViewController backToMain];
}


- (void)dealloc {
    [_myMapView release];
    [super dealloc];
}


#pragma mark - Map delegates and methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pav == nil)
    {
        pav = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId] autorelease];
        pav.draggable = YES;
        pav.canShowCallout = YES;
    }
    else
    {
        pav.draggable = YES;
        pav.annotation = annotation;
    }
    
    pav.animatesDrop = YES;
    pav.selected = YES;
    return pav;
}

- (void)locationEditor
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([STATIC_LOCATION_LATITUDE floatValue], [STATIC_LOCATION_LONGITUDE floatValue]);
    MKCoordinateRegion regionCenter = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.005, 0.005));
    regionCenter = [self.myMapView regionThatFits:regionCenter];
    [self.myMapView setRegion:regionCenter animated:YES];
    
    [self performSelector:@selector(addEditorsChoiceAnnotation) withObject:nil afterDelay:2.0f];
}

- (void)addEditorsChoiceAnnotation
{
    MKPointAnnotation* annotatePoint = [[MKPointAnnotation alloc] init];
    annotatePoint.coordinate = CLLocationCoordinate2DMake([STATIC_LOCATION_LATITUDE floatValue], [STATIC_LOCATION_LONGITUDE floatValue]);
    annotatePoint.title = @"總編輯";
    annotatePoint.subtitle = STATIC_EDITORS_CHOICE;
    
    [self.myMapView addAnnotation:annotatePoint];
    [annotatePoint release];
    [self.myMapView selectAnnotation:annotatePoint animated:YES];
}

@end
