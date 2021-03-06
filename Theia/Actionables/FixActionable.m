//
//  FixActionState.m
//  Theia
//
//  Created by Marc Jowett on 27/05/2022.
//

#import "FixActionable.h"

typedef NS_ENUM(NSUInteger, FixStatus) {
    fixed = 0,
    broken = 1
};

/**
 Actionable for the state and behaviour of the fix ("Fix") action, including its icon images.
 It is activating whenever any other Actionable is in activated,
 and will reset all Actionables to their default values.
 */
@interface FixActionable()

@property (nonatomic) NSArray *delegates;
@property (nonatomic) int resetCompleteCounter;

@end

@implementation FixActionable
@synthesize action;
@synthesize defaultImage;
@synthesize images;
@synthesize isActive;

- (nonnull instancetype)initWithAction:(nonnull UIAction *)action {
    if (self = [super init]) {
        self.action = action;
        self.isActive = false;
        self.defaultImage = [UIImage systemImageNamed:@"checkmark.seal"];
        self.images = [NSMutableDictionary dictionary];
        [self.images setObject: [UIImage systemImageNamed:@"checkmark.seal"] forKey:[NSNumber numberWithInteger:fixed]];
        [self.images setObject: [UIImage systemImageNamed:@"wrench.and.screwdriver"] forKey:[NSNumber numberWithInteger:broken]];
        self.action.image = defaultImage;
        self.resetCompleteCounter = 0;
    }
    return self;
}

- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player {
    if (isActive) {
        action.image = [images objectForKey:[NSNumber numberWithInteger:fixed]];
        [self resetAllActionsOnPlayer:player];
    }
}

- (void)carryOutActionOnController:(TransportBarController *)controller {
    if (isActive) {
        action.image = [images objectForKey:[NSNumber numberWithInteger:fixed]];
        [self resetAllActionsOnController:controller];
    }
}

- (void)resetAllActionsOnPlayer:(nonnull AVPlayer *)player {
    for (int actionIndex = 0; actionIndex < _delegates.count; actionIndex++) {
        id<Actionable> currentAction = [_delegates objectAtIndex:actionIndex];
        if ([currentAction respondsToSelector:@selector(resetValuesIncludingPlayer:)]) {
            [currentAction resetValuesIncludingPlayer:player];
        }
    }
    _resetCompleteCounter++;
    [self resetValues];
}

- (void)resetAllActionsOnController:(TransportBarController *)controller {
    for (int actionIndex = 0; actionIndex < _delegates.count; actionIndex++) {
        id<Actionable> currentAction = [_delegates objectAtIndex:actionIndex];
        if ([currentAction respondsToSelector:@selector(resetValuesIncludingController:)]) {
            [currentAction resetValuesIncludingController:controller];
        }
    }
    _resetCompleteCounter++;
    [self resetValues];
}

/**
 Resets the FixActionable values.
 */
- (void)resetValues {
    if (_resetCompleteCounter == 2) {
        NSLog(@"Fixed");
        isActive = false;
        action.image = defaultImage;
        _resetCompleteCounter = 0L;
    }
}

- (void)passInActionDelegates:(NSArray *)delegates {
    _delegates = delegates;
}

/**
 Sets the FixActionable to the broken, making it active and changing the icon image.
 */
- (void)setPlayerToBroken:(nonnull AVPlayer *)player {
    isActive = true;
    action.image = [images objectForKey:[NSNumber numberWithInteger:broken]];
}

@end
