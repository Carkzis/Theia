//
//  ReversiActionState.m
//  Theia
//
//  Created by Marc Jowett on 16/05/2022.
//

#import "ReversiActionState.h"

typedef NS_ENUM(NSUInteger, Reverseness) {
    versi = 0,
    reversi = 1
};

@implementation ReversiActionState

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

- (void)carryOutActionOnController:(ActionController *)controller {
    isActive = !isActive;
    action.image = isActive ? [images objectForKey:[NSNumber numberWithInteger:reversi]] : [images objectForKey:[NSNumber numberWithInteger:versi]];
    // TODO: Encapsulate transportBarCustomMenuItems within the ActionController.
    [self reverseTransportBarOnController:controller];
    
}

- (void)resetValuesIncludingController:(ActionController *)controller {
    if (isActive) {
        action.image = defaultImage;
        [self reverseTransportBarOnController:controller];
        isActive = false;
    }
}

- (void)reverseTransportBarOnController:(ActionController *)controller {
    NSArray *reversedArray = [[controller.playerController.transportBarCustomMenuItems reverseObjectEnumerator] allObjects];
    controller.playerController.transportBarCustomMenuItems = reversedArray;
}

@end
