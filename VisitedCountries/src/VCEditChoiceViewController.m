//
//  VCEditChoiceViewController.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 29/09/2018.
//  Copyright © 2018 Brice Rosenzweig. All rights reserved.
//

#import "VCEditChoiceViewController.h"
#import "VCAppGlobal.h"
#import "VCShapeSetChoice.h"

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
    
    self.choice = [[VCShapeSetChoice alloc] init];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem
                                              alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];

}

-(void)viewWillAppear:(BOOL)animated{
    [self viewWillAppear:animated];
    [self.tableView reloadData];
}

-(void)save:(UIBarButtonItem*)item{
    self.choice.selectionName = self.nameTextField.text;
    if( self.choice.selectionName && self.choice.definitionName && self.choice.selectionName.length > 0){
        [[VCAppGlobal organizer] changeCurrentChoice:self.choice];
        NSLog(@"save %@ %@", self.choice.selectionName, self.choice.definitionName);
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    return [[VCAppGlobal organizer] allDefinitionNames].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCCellGrid * cell = [GCCellGrid cellGrid:tableView];
    [cell setupForRows:1 andCols:1];
    
    NSString * name = [[VCAppGlobal organizer] allDefinitionNames][indexPath.row];
    
    // Configure the cell...
    cell.backgroundColor = [UIColor clearColor];
    [cell labelForRow:0 andCol:0].attributedText = [NSAttributedString attributedString:[RZViewConfig attributeBold14] withString:name];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.choice.definitionName = [[VCAppGlobal organizer] allDefinitionNames][indexPath.row];
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20.0;
}
 */

#pragma mark - UITextField Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.choice.selectionName = textField.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
@end
