//
//  VCEditChoiceViewController.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 29/09/2018.
//  Copyright © 2018 Brice Rosenzweig. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class VCShapeSetChoice;

@interface VCEditChoiceViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) VCShapeSetChoice * choice;

@end

NS_ASSUME_NONNULL_END
