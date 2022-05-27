//
//  RandomAction.m
//  Theia
//
//  Created by Marc Jowett on 27/05/2022.
//

#import "RandomAction.h"

@interface RandomAction()
    @property (strong, nonatomic) UIAction *action;
    @property (strong, nonatomic) AVPlayer *player;
    @property (strong, nonatomic) TransportBarController *actionController;
@end

@implementation RandomAction

- (nonnull instancetype)initWithAction:(nonnull UIAction *)action
                                player:(AVPlayer *)player
                            transportBarController:(TransportBarController *)controller {
    if (self = [super init]) {
        self.action = action;
        self.player = player;
        self.actionController = controller;
        self.image = [UIImage systemImageNamed:@"questionmark.diamond"];
        self.action.image = _image;
    }
    return self;
}

- (void)carryOutRandomAction:(NSArray *)delegates {
    for (int actionIndex = 0; actionIndex < delegates.count; actionIndex++) {
        NSUInteger randomIndex = arc4random() % delegates.count;
        if (randomIndex == 0) {
            NSLog(@"A random event occured!");
            id<ActionState> currentAction = [delegates objectAtIndex:actionIndex];
            if ([currentAction respondsToSelector:@selector(carryOutActionOnPlayer:)]) {
                [currentAction carryOutActionOnPlayer:_player];
            }
            if ([currentAction respondsToSelector:@selector(carryOutActionOnController:)]) {
                [currentAction carryOutActionOnController:_actionController];
            }
        }
    }
}

@end
