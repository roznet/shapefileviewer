//
//  VCSelectionTableViewController.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 10/08/2018.
//  Copyright © 2018 Brice Rosenzweig. All rights reserved.
//

#import "VCSelectionTableViewController.h"
#import "VCAppGlobal.h"

#import "VCShapeSetChoice.h"
#import "VCEditChoiceViewController.h"

@import RZUtils;
@import RZUtilsUniversal;
@import RZUtilsTouch;

@interface VCSelectionTableViewController ()

@end

@implementation VCSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem
                                              alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[VCAppGlobal organizer] attach:self];
    [self.tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[VCAppGlobal organizer] detach:self];
}

-(void)notifyCallBack:(id)theParent info:(RZDependencyInfo *)theInfo{
    dispatch_async(dispatch_get_main_queue(), ^(){
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[[VCAppGlobal organizer] validChoices] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCCellGrid * cell = [GCCellGrid gridCell:tableView];

    [cell setupForRows:2 andCols:1];
    VCShapeSetChoice * choice = [[[VCAppGlobal organizer] validChoices] objectAtIndex:indexPath.row];
    [cell labelForRow:0 andCol:0 ].attributedText = [NSAttributedString attributedString:[RZViewConfig attribute16] withString:choice.selectionName];
    [cell labelForRow:1 andCol:0 ].attributedText = [NSAttributedString attributedString:[RZViewConfig attribute14Gray] withString:choice.definitionName];

    return cell;
}


-(void)add:(UIBarButtonItem*)button{
    VCEditChoiceViewController * vc = [[VCEditChoiceViewController alloc] initWithNibName:@"VCEditChoiceViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VCShapeSetChoice * choice = [[[VCAppGlobal organizer] validChoices] objectAtIndex:indexPath.row];
    [[VCAppGlobal organizer] changeCurrentChoice:choice];
    [self.tableView reloadData];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        VCShapeSetChoice * choiceToDelete = [[[VCAppGlobal organizer] validChoices] objectAtIndex:indexPath.row];
        NSLog(@"delete %@", choiceToDelete.selectionName);
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
