//  MIT Licence
//
//  Created on 16/03/2015.
//
//  Copyright (c) 2015 Brice Rosenzweig.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
    self.shapeFileMapView = [RZShapeFileMapView shapeFileMapViewFor:[[VCAppGlobal organizer] shapeFile
                                                                     ]];
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
