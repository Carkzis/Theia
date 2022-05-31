//
//  ApocalypseEnumerator.m
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import "ApocalypseEnumerator.h"

/**
 Enumerator for the Apocalypse Actionable.
 There are 5 states; not dying (0), dying (1), near death (2), apocalypse (3) and end (4, the final state).
 */
@interface ApocalypseEnumerator()

@property (nonatomic) NSInteger apocalypseLevel;

@end

@implementation ApocalypseEnumerator

- (nonnull instancetype)init {
    if (self = [super init]) {
        _apocalypseLevel = 0;
    }
    return self;
}

/**
 Returns the apocalypse level after incrementing it.
 */
- (NSUInteger)retrieveNextApocalypseLevel {
    _apocalypseLevel++;
    return _apocalypseLevel;
}

/**
 Resets the apocalpse level to 0 (not dying).
 */
- (void)resetApocalypseLevel {
    _apocalypseLevel = 0;
}

@end
