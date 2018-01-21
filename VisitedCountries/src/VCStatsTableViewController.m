//  MIT Licence
//
//  Created on 05/04/2015.
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

#import "RZUtils/RZUtils.h"
#import "VCStatsTableViewController.h"
#import "VCShapeSetOrganizer.h"
#import "VCAppGlobal.h"
#import "VCShape.h"
#import "VCViewConfig.h"

#define VC_SECTION_ALL          0
#define VC_SECTION_CONTINENT    1
#define VC_SECTION_END          2

@interface VCGroupInfo : NSObject
@property (nonatomic,assign) NSUInteger totalCount;
@property (nonatomic,assign) NSUInteger visited;
@property (nonatomic,retain) NSString * name;

-(double)pct;
@end

@implementation VCGroupInfo
-(double)pct{
    return (double)_visited/(double)_totalCount * 100.0;
}
@end

@interface VCStatsTableViewController ()

@property (nonatomic,retain) NSArray * groups;
@property (nonatomic,assign) NSUInteger totalCount;
@property (nonatomic,assign) NSUInteger visitedCount;

@end

@implementation VCStatsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[VCAppGlobal organizer] attach:self];
    [self notifyCallBack:nil info:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[VCAppGlobal organizer] detach:self];
}

-(void)notifyCallBack:(id)theParent info:(RZDependencyInfo *)theInfo{
    NSMutableDictionary * cont = [NSMutableDictionary dictionary];
    VCShapeSetOrganizer * organizer = [VCAppGlobal organizer];
    NSIndexSet * selected = [organizer indexSetForSelection];
    self.totalCount = organizer.list.count;
    self.visitedCount = selected.count;
    [organizer.list enumerateObjectsUsingBlock:^(VCShape*one,NSUInteger idx,BOOL * stop){
        VCGroupInfo * info = cont[one.group];
        if (info == nil) {
            info = [[VCGroupInfo alloc] init];
            info.name = one.group;
            cont[one.group] = info;
        }
        info.totalCount++;
        if ([selected containsIndex:idx]) {
            info.visited++;
        }
    }];
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:cont.count];
    for (NSString * key  in cont) {
        if ([key length] > 0) {
            [array addObject:cont[key]];
        }
    }
    self.groups = [array sortedArrayWithOptions:NSSortStable usingComparator:^(VCGroupInfo*o1,VCGroupInfo*o2){
        return [@(o2.pct) compare:@(o1.pct)];
    }];

    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return VC_SECTION_END;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == VC_SECTION_CONTINENT) {
        return self.groups.count;
    }else{
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GCCellGrid * cell = [GCCellGrid gridCell:tableView];
    [cell setupForRows:2 andCols:2];

    if (indexPath.section == VC_SECTION_ALL) {
        NSString * data = [NSString stringWithFormat:@"%d countries out of %d", (int)self.visitedCount, (int)self.totalCount];
        NSString * pct = [NSString stringWithFormat:@"%.0f%%", (double)self.visitedCount/(double)self.totalCount*100.0];
        [cell labelForRow:0 andCol:0].attributedText = [VCViewConfig attributedString:@"World" attribute:@selector(attribute16)];
        [cell labelForRow:0 andCol:1].attributedText = [VCViewConfig attributedString:data attribute:@selector(attributeBold16)];
        [cell labelForRow:1 andCol:1].attributedText = [VCViewConfig attributedString:pct attribute:@selector(attribute14Gray)];
    }else if (indexPath.section==VC_SECTION_CONTINENT){
        VCGroupInfo * info = self.groups[indexPath.row];
        NSString * data = [NSString stringWithFormat:@"%d countries out of %d", (int)info.visited, (int)info.totalCount];
        NSString * pct = [NSString stringWithFormat:@"%.0f%%", info.pct];
        [cell labelForRow:0 andCol:0].attributedText = [VCViewConfig attributedString:info.name attribute:@selector(attribute16)];
        [cell labelForRow:0 andCol:1].attributedText = [VCViewConfig attributedString:data attribute:@selector(attributeBold16)];
        [cell labelForRow:1 andCol:1].attributedText = [VCViewConfig attributedString:pct attribute:@selector(attribute14Gray)];

    }

    return cell;
}



@end
