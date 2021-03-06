//  MIT Licence
//
//  Created on 15/05/2015.
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

#import "VCShapeCountry.h"

/*
 COLUMN		TYPE			DESCRIPTION

 Shape		Polygon			Country/area border as polygon(s)
 FIPS		String(2)		FIPS 10-4 Country Code
 ISO2		String(2)		ISO 3166-1 Alpha-2 Country Code
 ISO3		String(3)		ISO 3166-1 Alpha-3 Country Code
 UN		Short Integer(3)	ISO 3166-1 Numeric-3 Country Code
 NAME		String(50)		Name of country/area
 AREA		Long Integer(7)		Land area, FAO Statistics (2002)
 POP2005		Double(10,0)	 	Population, World Polulation Prospects (2005)
 REGION		Short Integer(3) 	Macro geographical (continental region), UN Statistics
 SUBREGION	Short Integer(3)	Geogrpahical sub-region, UN Statistics
 LON		FLOAT (7,3)		Longitude
 LAT		FLOAT (6,3)		Latitude

 CLLocationCoordinate2D coord;
 coord.latitude = [one[@"LAT"] doubleValue];
 coord.longitude = [one[@"LON"] doubleValue];

 */


@implementation VCShapeCountry
+(instancetype)shapeWithValues:(NSDictionary*)vals atIndex:(NSUInteger)idx withDefs:(VCShapeSetDefinition*)defs{
    VCShapeCountry * rv = [super shapeWithValues:vals atIndex:idx withDefs:defs];
    if (rv) {
        rv.group = [rv regionNameForCode:vals[defs.groupField]];
    }
    return rv;
}

#if ! __has_feature(objc_arc)
// dealloc
#endif


-(NSString*)regionNameForCode:(NSNumber*)num{
    static NSDictionary * map = nil;
    if (map == nil) {
        map =    @{

                   @(1):@"World",
                   @(2):@"Africa",
                   @(14):@"Eastern Africa",
                   @(17):@"Middle Africa",
                   @(15):@"Northern Africa",
                   @(18):@"Southern Africa",
                   @(11):@"Western Africa",
                   @(19):@"Americas ",
                   @(419):@"Latin America and the Caribbean ",
                   @(29):@"Caribbean",
                   @(13):@"Central America",
                   @(5):@"South America",
                   @(21):@"Northern America",
                   @(142):@"Asia",
                   @(143):@"Central Asia",
                   @(30):@"Eastern Asia",
                   @(34):@"Southern Asia",
                   @(35):@"South-Eastern Asia",
                   @(145):@"Western Asia",
                   @(150):@"Europe",
                   @(151):@"Eastern Europe",
                   @(154):@"Northern Europe",
                   @(39):@"Southern Europe",
                   @(155):@"Western Europe",
                   @(9):@"Oceania",
                   @(53):@"Australia and New Zealand",
                   @(54):@"Melanesia",
                   @(57):@"Micronesia",
                   @(61):@"Polynesia",
                   };
    }
    NSString * rv = map[num];
    if (rv == nil) {
        rv = NSLocalizedString(@"Unknown Region", @"Missing Region Code");
    }
    return rv;

}



@end
