//
//  Trip.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 3/23/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "Trip.h"

@implementation Trip
static NSArray *list;

+ (Trip*) initWithDictionary:(NSDictionary*)dictionary
{
    Trip *trip = [[Trip alloc] init];
    trip.kind = [dictionary objectForKey:@"kind"];
    trip.background = [dictionary objectForKey:@"background"];

    if (![trip isLandingView]) {
        trip.title = [dictionary objectForKey:@"name"];
        trip.mainPic = [dictionary objectForKey:@"picture"];
        trip.isAvailable = [[dictionary objectForKey:@"available"] boolValue];
        trip.cost = [[dictionary objectForKey:@"cost"] floatValue];
        
        trip.introEs = [dictionary objectForKey:@"intro_es"];
        trip.introEn = [dictionary objectForKey:@"intro_en"];
        trip.complexity = [dictionary objectForKey:@"complexity"];
        trip.distance = [dictionary objectForKey:@"distance"];

        if (trip.isAvailable) {
            // Loading route data
            NSDictionary *route = [dictionary objectForKey:@"route"];
            float oLat = [[[route objectForKey:@"origin"] objectForKey:@"lat"] floatValue];
            float oLon = [[[route objectForKey:@"origin"] objectForKey:@"lon"] floatValue];
            [trip setOriginCoordinate:CLLocationCoordinate2DMake(oLat, oLon)];
            
            float eLat = [[[route objectForKey:@"end"] objectForKey:@"lat"] floatValue];
            float eLon = [[[route objectForKey:@"end"] objectForKey:@"lon"] floatValue];
            [trip setEndCoordinate:CLLocationCoordinate2DMake(eLat, eLon)];
            trip.startZoom = (int) [[route objectForKey:@"start_zoom"] integerValue];
            
            NSMutableArray *pathsTmp = [NSMutableArray array];
            for (NSDictionary *path in [route objectForKey:@"paths"]) {
                [pathsTmp addObject:[Path initWithDictionary:path]];
            }
            trip.paths = pathsTmp;
            
            // Loading orientation markers
            NSMutableArray *directionTmp = [NSMutableArray array];
            for (NSDictionary *dict in [route objectForKey:@"markers"]) {
                DirectionMarker *directionMarker = [DirectionMarker initWithDictionary:dict];
                [directionTmp addObject:directionMarker];
            }
            [trip setDirectionMarkers:directionTmp];
            
            trip.detailsPic = [route objectForKey:@"detailed_pic"];
        }
        
        // Loading pois
        NSMutableDictionary *poisTmp = [NSMutableDictionary dictionary];
        NSMutableArray *poisList = [NSMutableArray array];

        for (NSDictionary *dict in [dictionary objectForKey:@"pois"]) {
            Poi *poi = [Poi initWithDictionary:dict];
            
            // Separate listed from unlisted
            NSString *listedOrNotKey = @"listed";
            if (![[dict objectForKey:listedOrNotKey] boolValue]) {
                listedOrNotKey = @"unlisted";
            }
            
            if (![poisTmp objectForKey:listedOrNotKey]) {
                [poisTmp setObject:[NSMutableArray array] forKey:listedOrNotKey];
            }
            
            [[poisTmp objectForKey:listedOrNotKey] addObject:poi];
            [poisList addObject:poi];
        }
        
        [trip setPois:poisTmp];
        [trip setAllPois:poisList];
        // Loading brochure elements
        
        NSMutableArray *brochureList = [NSMutableArray array];
        for (NSDictionary *brochureContent in [dictionary objectForKey:@"contents"]) {
            [brochureList addObject:[BrochureElement initWithDictionary:brochureContent]];
        }
        [trip setBrochureList:brochureList];
        
    }
    
    return trip;
}

+ (NSArray*) loadAll
{
    NSArray *listOfTrips = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Trips" ofType:@"plist"]];
    NSMutableArray *tripsTmp = [NSMutableArray array];
    for (NSDictionary *dict in listOfTrips) {
        [tripsTmp addObject:[Trip initWithDictionary:dict]];
    }
    
    list = [NSArray arrayWithArray:tripsTmp];
    
    return list;
}

+ (int) count
{
    return (int) [list count];
}

+ (NSArray*) all
{
    return list;
}

- (BOOL) isLandingView
{
    return [self.kind isEqualToString:@"landing"];
}

@end
