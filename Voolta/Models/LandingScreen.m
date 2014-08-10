//
//  LandingScreen.m
//  Hoops
//
//  Created by Alejandro Cruz Paz on 5/16/14.
//  Copyright (c) 2014 Hoops. All rights reserved.
//

#import "LandingScreen.h"

@interface LandingScreen ()
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, assign) int index;
@end

@implementation LandingScreen

- (id) init
{
    self = [super init];
    if (self) {
        _users = [NSMutableArray arrayWithObjects:
                  @{@"bg": @"colores.png", @"name": @"Aarón Borras", @"tw": @"@avientensetodos", @"pic" : @"aaron.png" },
                  @{@"bg": @"main-background.jpg", @"name": @"Aarón Borras", @"tw": @"@avientensetodos", @"pic" : @"aaron.png" },
                  @{@"bg": @"other-background.jpg", @"name": @"Melanie Mechelen", @"tw": @"@mechelenma", @"pic" : @"melanie.jpg" },
                  @{@"bg": @"caminarla.png", @"name": @"Joseph Args", @"tw": @"@joseargs", @"pic" : @"joseph.png" },
                  @{@"bg": @"another-background.jpg", @"name": @"Bici Verde", @"tw": @"@verdecito", @"pic" : @"greenie.png" }, nil];
    }
    return self;
}

- (NSString*) background
{
    return [[_users objectAtIndex:_index] objectForKey:@"bg"];
}

- (UIImage*) image
{
    _index = arc4random() % [_users count];
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
