//
//  VCCountry.h
//  VisitedCountries
//
//  Created by Brice Rosenzweig on 26/03/2015.
//  Copyright (c) 2015 Brice Rosenzweig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface VCCountry : NSObject
@property (nonatomic,retain) NSString * name;
@property (nonatomic,retain) NSString * iso2;
@property (nonatomic,assign) NSUInteger shapeIndex;

+(VCCountry*)countryWithDefs:(NSDictionary*)one andIndex:(NSUInteger)idx;

-(NSString*)region;
-(BOOL)matchString:(NSString*)str;
-(UIImage*)flagImage;
@end
