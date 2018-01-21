//  MIT Licence
//
//  Created on 26/03/2015.
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

#import "VCCountry.h"
#import <CoreLocation/CoreLocation.h>
#import "RZUtils/RZUtils.h"

@interface VCCountry ()
@property (nonatomic,retain) NSNumber * regionCode;
@property (nonatomic,retain) NSNumber * subRegionCode;
@property (nonatomic,retain) NSNumber * countryCode;
@property (nonatomic,assign) CLLocationCoordinate2D location;
@end

@implementation VCCountry

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
    return map[num];

}

+(VCCountry*)countryWithDefs:(NSDictionary*)one andIndex:(NSUInteger)idx{
    VCCountry * rv = [[VCCountry alloc] init];
    if (rv) {
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

         */
        rv.name = one[@"NAME"];
        rv.shapeIndex = idx;
        rv.iso2 = one[@"ISO2"];
        rv.regionCode = one[@"REGION"];
        rv.subRegionCode = one[@"SUBREGION"];
        rv.countryCode = one[@"UN"];
        CLLocationCoordinate2D coord;
        coord.latitude = [one[@"LAT"] doubleValue];
        coord.longitude = [one[@"LON"] doubleValue];
        rv.location = coord;
    }
    return rv;
}

-(NSString*)region{
    NSString * rv = [self regionNameForCode:self.regionCode];
    if (!rv) {
        rv = NSLocalizedString(@"", @"Unknown Region");
    }
    return  rv;
}

-(BOOL)matchString:(NSString *)str{
    return [[self.name uppercaseString] containsString:[str uppercaseString]] || [[self.region uppercaseString] containsString:[str uppercaseString]];
}

-(BOOL)hasFlag{
    NSString * path = [RZFileOrganizer bundleFilePath:@"flags.bundle/%@.png"];
    return  [[NSFileManager defaultManager] fileExistsAtPath:path];
}
-(UIImage*)flagImage{
    return [UIImage imageNamed:[NSString stringWithFormat:@"flags.bundle/%@.png", self.iso2]];
}
@end
