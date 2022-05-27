//
//  ApocalypseEnumerator.m
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import "ApocalypseEnumerator.h"

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

- (NSUInteger)retrieveNextApocalypseLevel {
    _apocalypseLevel++;
    return _apocalypseLevel;
}

- (void)resetApocalypseLevel {
    _apocalypseLevel = 0;
}

@end
