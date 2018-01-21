//  MIT Licence
//
//  Created on 21/03/2015.
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

#import "VCTabBarViewController.h"
#import "VCMapViewController.h"
#import "VCCountriesTableViewController.h"
#import "VCStatsTableViewController.h"

@interface VCTabBarViewController ()
@property (nonatomic,retain) VCMapViewController * mapViewController;
@property (nonatomic,retain) VCCountriesTableViewController * countriesController;
@property (nonatomic,retain) VCStatsTableViewController * statsController;

@end

@implementation VCTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapViewController = [[VCMapViewController alloc] initWithNibName:nil bundle:nil];
    self.countriesController = [[VCCountriesTableViewController alloc] initWithNibName:nil bundle:nil];
    self.statsController = [[VCStatsTableViewController alloc] initWithNibName:nil bundle:nil];

    UINavigationController * mapNav = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
    UINavigationController * countriesNav = [[UINavigationController alloc] initWithRootViewController:self.countriesController];
    UINavigationController * statsNav = [[UINavigationController alloc] initWithRootViewController:self.statsController];

    UITabBarItem * mapItem = [[UITabBarItem alloc] initWithTitle:@"Map" image:[UIImage imageNamed:@"881-globe"] tag:0];
    UITabBarItem * countriesItem = [[UITabBarItem alloc] initWithTitle:@"Countries" image:[UIImage imageNamed:@"729-top-list"] tag:1];
    UITabBarItem * statsItem = [[UITabBarItem alloc] initWithTitle:@"Stats" image:[UIImage imageNamed:@"859-bar-chart"] tag:2];

    mapNav.tabBarItem = mapItem;
    countriesNav.tabBarItem = countriesItem;
    statsNav.tabBarItem = statsItem;

    self.viewControllers = @[ countriesNav, mapNav, statsNav];
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
