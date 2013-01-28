//
//  WheresEditorViewController.h
//  GoldenKnowledge
//
//  Created by Bobie on 1/28/13.
//  Copyright (c) 2013 BobieAir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class MainViewController;

@interface WheresEditorViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, assign) MainViewController* parentMainViewController;

// IBActions
//
- (IBAction)backToMain:(id)sender;

// IBOutlets
//
@property (retain, nonatomic) IBOutlet MKMapView *myMapView;

@end
