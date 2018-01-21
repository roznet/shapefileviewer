//
//  VCCountriesTableViewController.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 21/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "VCCountriesTableViewController.h"
#import "VCAppGlobal.h"
#import "VCViewConfig.h"
#import "VCShape.h"
#import "RZUtils/RZUtils.h"

@interface VCCountriesTableViewController ()
@property (nonatomic,retain) UISearchBar * search;

@property (nonatomic,retain) RZFilteredSelectedArray * array;


@end

@implementation VCCountriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.search = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 280.0f, 44.0f)];
    self.search.barStyle					= UIBarStyleDefault;
    self.search.delegate					= self;
    self.search.autocorrectionType		= UITextAutocorrectionTypeNo;
    self.search.autocapitalizationType	= UITextAutocapitalizationTypeNone;
    self.navigationItem.titleView	= self.search;
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sets" style:UIBarButtonItemStylePlain target:self action:@selector(tapSets:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"798-filter"] style:UIBarButtonItemStylePlain target:self action:@selector(tapFilter:)];
    
    NSArray * list =[[VCAppGlobal organizer] list];
    self.array = [RZFilteredSelectedArray array:list withFilter:nil];
    
    [self.array setSelectionIndexes:[[VCAppGlobal organizer] indexSetForSelection]];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[VCAppGlobal organizer] attach:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[VCAppGlobal organizer] detach:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tapSets:(id)obj{
    
}
-(void)notifyCallBack:(id)theParent info:(RZDependencyInfo *)theInfo{
    if (/* DISABLES CODE */ (false)) {
        self.array = [RZFilteredSelectedArray array:[[VCAppGlobal organizer] list] withFilter:nil];
        
        [self.array setSelectionIndexes:[[VCAppGlobal organizer] indexSetForSelection]];
    }
    
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void)tapFilter:(id)obj{
    if ([self.array isFilterEqualToSelection]) {
        [self.array clearFilter];
    }else{
        [self.array setFilterFromSelection];
    }
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCCellGrid * cell = [GCCellGrid gridCell:tableView];
    
    [cell setupForRows:2 andCols:1];
    VCShape * one= self.array[indexPath.row];
    
    [cell labelForRow:0 andCol:0].attributedText = [NSAttributedString attributedString:[VCViewConfig attributeBold16] withString:one.name?one.name:@"Unkown"];
    [cell labelForRow:1 andCol:0].attributedText = [NSAttributedString attributedString:[VCViewConfig attribute14Gray] withString:one.group?one.group:@""];
    NSString * iconName = [one iconName];
    if (iconName) {
        [cell setIconImage:[UIImage imageNamed:iconName]];
    }else{
        [cell setIconImage:nil];
    }
    cell.iconPosition = gcIconPositionLeft;
    if ([self.array.filteredSelectionIndexes containsIndex:indexPath.row]) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(searchBarSearchButtonClicked:)];

}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"798-filter"] style:UIBarButtonItemStylePlain target:self action:@selector(tapFilter:)];
    [self.search resignFirstResponder];
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText && searchText.length > 0){
        self.array.filter = ^(VCShape*one){
            return [one matchString:searchText];
        };
    }else{
        self.array.filter = nil;
    }
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.array.filteredSelectionIndexes containsIndex:indexPath.row]) {
        [self.array selectionRemoveIndex:indexPath.row];
    }else{
        [self.array selectionAddIndex:indexPath.row];
    }
    [[VCAppGlobal organizer] setIndexSetForSelection:self.array.selectionIndexes];
    [self.tableView reloadData];
}

@end
