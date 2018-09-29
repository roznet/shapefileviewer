//
//  VCEditChoiceViewController.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 29/09/2018.
//  Copyright © 2018 Brice Rosenzweig. All rights reserved.
//

#import "VCEditChoiceViewController.h"
#import "VCAppGlobal.h"

@import UIKit;
@import RZUtils;
@import RZUtilsUniversal;
@import RZUtilsTouch;

@interface VCEditChoiceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation VCEditChoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCCellGrid * cell = [GCCellGrid gridCell:tableView];
    [cell setupForRows:1 andCols:1];
    NSString * name = @"hello";
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    [cell labelForRow:0 andCol:0].attributedText = [NSAttributedString attributedString:[RZViewConfig attributeBold14] withString:name];
    
    return cell;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20.0;
}
 */
@end
