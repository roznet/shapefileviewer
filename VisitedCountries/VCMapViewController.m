//
//  ViewController.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 16/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "VCMapViewController.h"
@import RZUtils;
@import RZExternalUniversal;

#import <MapKit/MapKit.h>
#import "VCAppGlobal.h"

@interface VCMapViewController ()
@property (retain, nonatomic) MKMapView *mapView;
@property (nonatomic,retain) RZShapeFileMapView * shapeFileMapView;

@end

@implementation VCMapViewController

-(void)dealloc{
    [[VCAppGlobal organizer] detach:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
    
    // Do any additional setup after loading the view, typically from a nib.

    MKCoordinateRegion region = MKCoordinateRegionForMapRect(MKMapRectWorld);
    [self.mapView setRegion:region animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.frame = self.view.frame;
    
    [[VCAppGlobal organizer] attach:self];
    [self notifyCallBack:nil info:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[VCAppGlobal organizer] detach:self];
    self.mapView.delegate = nil;
    self.shapeFileMapView = nil;
}

-(void)notifyCallBack:(id)theParent info:(RZDependencyInfo *)theInfo{
    self.shapeFileMapView = [RZShapeFileMapView shapeFileMapViewFor:[VCAppGlobal worldShape]];
    self.shapeFileMapView.fillColor = [UIColor darkGrayColor];
    self.shapeFileMapView.alpha = 0.4;
    
    self.mapView.delegate = self.shapeFileMapView;

    NSIndexSet * indexes = [[VCAppGlobal organizer] indexSetForSelection];
    
    [self.shapeFileMapView updateForMapView:self.mapView andIndexSet:indexes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
 
    self.mapView.frame = self.view.frame;
    [self.mapView setNeedsLayout];
}

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    

    if (newCollection.verticalSizeClass ==UIUserInterfaceSizeClassRegular) {
        self.tabBarController.tabBar.hidden = false;
        self.navigationController.navigationBar.hidden = false;
    }else{
        self.tabBarController.tabBar.hidden = true;
        self.navigationController.navigationBar.hidden = true;
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [coordinator notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>context){
        self.mapView.frame = self.view.frame;
    }];
}
@end
