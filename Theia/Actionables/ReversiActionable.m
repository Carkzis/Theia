//
//  ReversiActionable.m
//  Theia
//
//  Created by Marc Jowett on 16/05/2022.
//

#import "ReversiActionable.h"

typedef NS_ENUM(NSUInteger, Reverseness) {
    versi = 0,
    reversi = 1
};

/**
 Actionable for the state and behaviour of the reversi ("Reversi") action, including its icon images.
 Causes the Transport Bar item positions to reverse themselves.
 */
@implementation ReversiActionable

@synthesize action;
@synthesize defaultImage;
@synthesize images;
@synthesize isActive;

- (nonnull instancetype)initWithAction:(nonnull UIAction *)action {
    if (self = [super init]) {
        self.action = action;
        self.defaultImage = [UIImage systemImageNamed:@"chevron.forward.circle"];
        self.action.image = defaultImage;
        self.isActive = false;
        self.images = [NSMutableDictionary dictionary];
        [self.images setObject: [UIImage systemImageNamed:@"chevron.forward.circle"] forKey:[NSNumber numberWithInteger:versi]];
        [self.images setObject: [UIImage systemImageNamed:@"chevron.backward.circle"] forKey:[NSNumber numberWithInteger:reversi]];
    }
    return self;
}

- (void)carryOutActionOnController:(TransportBarController *)controller {
    NSLog(@"Reverse");
    isActive = !isActive;
    action.image = isActive ? [images objectForKey:[NSNumber numberWithInteger:reversi]] : [images objectForKey:[NSNumber numberWithInteger:versi]];
    [self reverseTransportBarOnController:controller];
    
}

- (void)resetValuesIncludingController:(TransportBarController *)controller {
    if (isActive) {
        action.image = defaultImage;
        [self reverseTransportBarOnController:controller];
        isActive = false;
    }
}

/**
 Reverses the Transport Bar items.
 */
- (void)reverseTransportBarOnController:(TransportBarController *)controller {
    NSArray *reversedArray = [[controller.playerController.transportBarCustomMenuItems reverseObjectEnumerator] allObjects];
    controller.playerController.transportBarCustomMenuItems = reversedArray;
}

@end
