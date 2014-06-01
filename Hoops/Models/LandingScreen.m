//
//  LandingScreen.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "LandingScreen.h"

@interface LandingScreen ()
@property (nonatomic, strong) NSArray *backgroundNames;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, assign) int index;
@end

@implementation LandingScreen

- (id) init
{
    self = [super init];
    if (self) {
        _backgroundNames = [NSMutableArray arrayWithObjects:@"main-background.jpg", @"other-background.jpg", @"another-background.jpg", nil];
        _users = [NSMutableArray arrayWithObjects:
                  @{@"name": @"Aarón Borras", @"tw": @"@avientensetodos", @"pic" : @"aaron.png" },
                  @{@"name": @"Melanie Mechelen", @"tw": @"@mechelenma", @"pic" : @"melanie.jpg" },
                  @{@"name": @"Bici Verde", @"tw": @"@verdecito", @"pic" : @"greenie.png" }, nil];
    }
    return self;
}

- (NSString*) background
{
    return [_backgroundNames objectAtIndex:_index];
}

- (UIImage*) image
{
    _index = arc4random() % [_backgroundNames count];
    return [UIImage imageNamed:[self background]];
}

- (UIImage*) userImage
{
    return [UIImage imageNamed:[[_users objectAtIndex:_index] objectForKey:@"pic"]];
}

- (NSString*) userContact
{
    return [[_users objectAtIndex:_index] objectForKey:@"tw"];
}

- (NSString*) userFullName
{
    return [[_users objectAtIndex:_index] objectForKey:@"name"];
}


@end
