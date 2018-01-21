//
//  SVShapeTableViewController.m
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 29/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import "SVShapeTableViewController.h"
@import RZExternalUniversal;
#import <MapKit/MapKit.h>
#import "SVPreferenceViewController.h"
#import "RZUtils/RZUtils.h"
#import "RZUtilsOSX/RZUtilsOSX.h"
#import "RZUtilsUniversal/RZUtilsUniversal.h"

@interface SVShapeTableViewController ()
@property (weak) IBOutlet NSTableView *shapesTable;
@property (weak) IBOutlet MKMapView *mapView;
@property (weak) IBOutlet NSTextField *bottomInfo;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSPopUpButton *filePopup;
@property (weak) IBOutlet NSSearchField *searchField;


@property (nonatomic,retain) NSDictionary * values;
@property (nonatomic,retain) RZFilteredSelectedArray * array;
@property (nonatomic,retain) RZShapeFile * file;
@property (nonatomic,retain) NSMutableDictionary * files;
@property (nonatomic,retain) RZShapeFileMapView * shapeFileMapView;
@end

@implementation SVShapeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    self.shapesTable.delegate = self;
    self.shapesTable.dataSource = self;
    self.files = [NSMutableDictionary dictionary];
    [self.filePopup setTarget:self];
    [self.filePopup setAction:@selector(popupAction:)];
}

-(void)viewWillAppear{
    [super viewWillAppear];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferenceChange:) name:SVNotifyPreferenceChanged object:nil];
}

-(void)viewWillDisappear{
    [super viewWillDisappear];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)openShape:(id)sender {
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    NSArray * exts = @[ @"shp", @"dbf", @"shx"];
    [panel setCanChooseDirectories:false];
    [panel setShowsHiddenFiles:false];
    [panel setAllowsMultipleSelection:YES];
    [panel setPrompt:@"Open"];
    [panel setMessage:@"Select 3 files with shp, dbg and shx extension and a common base name"];
    [panel setAllowedFileTypes:exts ];
    [panel setDirectoryURL:[NSURL URLWithString:@"~/Downloads"]];
    
    [panel runModal];
    
    NSArray * fs = [panel.URLs arrayByMappingBlock:^(NSURL* obj){
        return obj.path;
    }];
    [self performSelectorOnMainThread:@selector(setupForFileNames:) withObject:fs waitUntilDone:NO];
}
- (IBAction)searchChanged:(NSSearchField *)sender {
    if ([sender.stringValue length] > 1) {
        [self.array setFilter:^(NSDictionary*one){
            return [[[one description] uppercaseString] containsString:[sender.stringValue uppercaseString]];
        }];
        [self.tableView reloadData];
    }else{
        [self.array setFilter:nil];
        [self.tableView reloadData];
    }
}

#pragma mark - Setup

-(void)setupForFileNames:(NSArray*)fs{
    if (fs.count>0) {
        NSString * base = nil;
        NSArray * exts = @[ @"shp", @"dbf", @"shx"];

        BOOL hasCommonBase = true;
        BOOL hasExt[3] = {false,false,false};
        for (NSString * one in fs) {
            size_t i = 0;
            for (NSString * ext in exts) {
                if ([[one pathExtension] isEqualToString:ext]) {
                    hasExt[i]=true;
                }
                i++;
            }
            if (base==nil) {
                base = [one stringByDeletingPathExtension];
            }else{
                if (![base isEqualToString:[one stringByDeletingPathExtension]]) {
                    hasCommonBase = false;
                }
            }
        }
        if (hasCommonBase /* && hasExt[0] && hasExt[1] && hasExt[2]*/) {
            [self performSelectorOnMainThread:@selector(setupForFile:) withObject:base waitUntilDone:NO];
        }else{
            NSAlert * alert = [[NSAlert alloc] init];
            alert.messageText = @"You need to select 3 files with a common base and extensions shp, shx and dbf";
            [alert runModal];
        }
    }
}

-(void)openDocument:(id)sender{
    [self openShape:sender];
}

-(void)popupAction:(id)sender{
    [self setupForFile:[sender titleOfSelectedItem]];
}

-(void)updatePopupForBase:(NSString*)path{
    [self.filePopup insertItemWithTitle:path atIndex:0];
    [self.filePopup selectItemAtIndex:0];
}

-(void)setupForFile:(NSString*)path{
    self.file = [RZShapeFile shapeFileWithBase:path];

    [self updatePopupForBase:path];
    self.shapeFileMapView = [RZShapeFileMapView shapeFileMapViewFor:self.file];
    
    NSMutableDictionary * dict =[NSMutableDictionary dictionary];
    for (NSDictionary * one in self.file.allShapes) {
        for (NSString * key in one) {
            
            NSDictionary * column = dict[key];
            if (!column) {
                column = @{ @"values":  [NSMutableDictionary dictionary], @"types": [NSMutableDictionary dictionary]};
                dict[key] = column;
            }
            id val = one[key];
            NSString * valtype = NSStringFromClass([val class]);
            if ([val isKindOfClass:[NSString class]]) {
                valtype = @"String";
                if (column[@"values"][val]) {
                    column[@"values"][val] = @([column[@"values"][val] integerValue] + 1);
                }else{
                    column[@"values"][val] = @(1);
                }
            }else if ([val isKindOfClass:[NSNumber class]]){
                valtype = @"Number";
            }
            
            if(column[@"types"][valtype]){
                column[@"types"][valtype] = @([column[@"types"][valtype] integerValue]  +1);
            }else{
                column[@"types"][valtype] = @(1);
            }
            
        }
    }
    self.values = dict;
    self.array = [RZFilteredSelectedArray array:self.file.allShapes withFilter:nil];
    [self setupTableColumns];
    NSString * missing = [self validateBase:path];
    
    if (self.file.allShapes.count > 0) {
        self.bottomInfo.stringValue = [NSString stringWithFormat:@"%d shapes %@", (int)self.file.allShapes.count, missing];
    }else{
        self.bottomInfo.stringValue = [NSString stringWithFormat:@"No shapes. %@", missing];;
    }
}

-(NSString*)validateBase:(NSString*)path{
    NSMutableArray * missing = [NSMutableArray array];
    if(! [[NSFileManager defaultManager] isReadableFileAtPath:[path stringByAppendingPathExtension:@"shp"]] ){
        [missing addObject:@"shp"];
    }
    if( ![[NSFileManager defaultManager] isReadableFileAtPath:[path stringByAppendingPathExtension:@"shx"]]){
        [missing addObject:@"shx"];
    }
    if( ![[NSFileManager defaultManager] isReadableFileAtPath:[path stringByAppendingPathExtension:@"dbf"]] ){
        [missing addObject:@"dbf"];
    }
    
    if (missing.count==0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"Permission to read %@ files required, please select them in the file dialog", [missing componentsJoinedByString:@", "]];
}

-(void)setupTableColumns{
    NSArray * old = [NSArray arrayWithArray:self.shapesTable.tableColumns];
    for (NSTableColumn * col in old) {
        [self.shapesTable removeTableColumn:col];
    }
    NSArray * allColumns = self.values.allKeys;
    // Add string columns with most different values to the left

    NSArray * sorted = [allColumns sortedArrayUsingComparator:^(NSString * k1, NSString * k2){
        NSDictionary * d1 = self.values[k1];
        NSDictionary * d2 = self.values[k2];
        
        NSComparisonResult rv = NSOrderedSame;
        
        BOOL isS1 = d1[@"types"][@"String"] != nil;
        BOOL isS2 = d2[@"types"][@"String"] != nil;
        
        if (isS1 && isS2) {
            NSUInteger c1 = [d1[@"values"] allKeys].count;
            NSUInteger c2 = [d2[@"values"] allKeys].count;
            if (c1<c2) {
                rv = NSOrderedDescending;
            }else if (c2<c1){
                rv = NSOrderedAscending;
            }else{
                rv = NSOrderedSame;
            }
        }else if( isS1 && ! isS2){
            rv = NSOrderedAscending;
        }else if (isS2 && ! isS1){
            rv = NSOrderedDescending;
        }
        
        return rv;
    }];
    
    for (NSString * key in sorted) {
        NSTableColumn * col = [[NSTableColumn alloc] initWithIdentifier:key];
        [col.headerCell setStringValue:key];
        [self.shapesTable addTableColumn:col];
    }

    [self.shapesTable reloadData];
}

-(void)preferenceChange:(NSNotification*)obj{
    [self tableViewSelectionDidChange:obj];
}

#pragma mark - NSTableDataSource

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.array.count;
}


#pragma mark - NSTableDelegate

-(NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    // Get a new ViewCell
    
    NSString * key = tableColumn.identifier;
    id val = @"";
    if (row < self.array.count) {
        NSDictionary * rowDict = self.array[row];
        val = rowDict[key];
    }
    
    NSRect rect = NSMakeRect(0.0, 0.0, 60., 20.);
    
    NSTextField * textField = [[NSTextField alloc] initWithFrame:rect];
    textField.stringValue = [NSString stringWithFormat:@"%@", val ? val : @""];
    
    if ([val isKindOfClass:[NSString class]]) {
        textField.alignment = NSLeftTextAlignment;
        textField.editable = YES;
        [textField setDelegate:self];
        textField.identifier = [NSString stringWithFormat:@"%@|%@", @(row),key];
    }else{
        textField.alignment = NSRightTextAlignment;
        textField.editable = NO;
    }
    
    textField.bordered = NO;
    textField.backgroundColor= [NSColor clearColor];
    
    /*
     NSTableCellView * cellView = [[NSTableCellView alloc] initWithFrame:rect];
    cellView.textField = textField;
    [cellView addSubview:textField];
    */
    
    return textField;
}


-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    NSArray * split = [control.identifier componentsSeparatedByString:@"|"];
    if (split>0) {
        NSInteger row = [split[0] integerValue];
        NSString * key = split[1];
        if (row < self.array.count) {
            NSDictionary * rowDict = self.array[row];
            NSString * oldval = rowDict[key];
            NSLog(@"Changed [%d,%@] %@ -> %@", (int)row, key, oldval, control.stringValue );
        }
    }

    return YES;
}

-(CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 20.;
}

-(void)tableViewSelectionDidChange:(NSNotification *)notification{
    self.shapeFileMapView.fillColor = [NSColor colorWithRgbComponents:[[NSUserDefaults standardUserDefaults] objectForKey:SVPrefShapeColor] andAlpha:1.0];
    self.shapeFileMapView.alpha = [[NSUserDefaults standardUserDefaults] doubleForKey:SVPrefShapeTransparency];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:SVPrefDrawLine]) {
        self.shapeFileMapView.strokeColor = [NSColor colorWithRgbComponents:[[NSUserDefaults standardUserDefaults] objectForKey:SVPrefLineColor] andAlpha:1.0];
    }else{
        self.shapeFileMapView.strokeColor = nil;
    }
    [self.array selectionSetIndexSet:self.tableView.selectedRowIndexes];

    self.mapView.delegate = self.shapeFileMapView;

    [self.shapeFileMapView updateForMapView:self.mapView andIndexSet:self.array.selectionIndexes];
    
}

#pragma mark - NSOutlineDataSource

-(NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item{
    if (item == nil) {
        return self.values.count;
    }else{
        NSDictionary * one = self.values[item];
        return one? [one[@"values"] count]:0;
    }
}

-(BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item{
    if (item == nil) {
        return YES;
    }else{
        NSDictionary * one = self.values[item];
        return one? YES:NO;
        
    }
    
}
-(id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item{
    if (item == nil) {
        return [self.values allKeys][index];
    }else{
        NSDictionary * one = self.values[item];
        NSArray * sub = one[@"values"];
        return one? [sub objectAtIndexedSubscript:index]:@"";
        
    }
}

-(id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item{
    return item?item:@"";
}
@end
