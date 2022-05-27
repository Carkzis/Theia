//
//  ActionController.m
//  Theia
//
//  Created by Marc Jowett on 03/05/2022.
//

#import "ActionController.h"

@interface ActionController()

    @property (strong, nonatomic) AVPlayer *player;
    @property (strong, nonatomic) AVPlayerItem *playerItem;

    @property (strong, nonatomic) UIAction *randomAction;
    @property (strong, nonatomic) RandomAction *randomActionResponder;

    @property (strong, nonatomic) UIAction *muteAction;
    @property (strong, nonatomic) id<ActionState> muteStateDelegate;

    @property (strong, nonatomic) UIAction *speedAction;
    @property (strong, nonatomic) id<ActionState> speedStateDelegate;

    @property (strong, nonatomic) UIAction *teleportAction;
    @property (strong, nonatomic) id<ActionState> teleportStateDelegate;

    @property (strong, nonatomic) UIAction *reversiAction;
    @property (strong, nonatomic) id<ActionState> reversiStateDelegate;

    @property (strong, nonatomic) UIAction *confusedAction;
    @property (strong, nonatomic) id<ActionState> confusedStateDelegate;

    @property (strong, nonatomic) UIAction *apocalypseAction;
    @property (strong, nonatomic) id<ActionState> apocalypseStateDelegate;

    @property (strong, nonatomic) UIAction *fixAction;
    @property (strong, nonatomic) id<ActionState> fixStateDelegate;
    @property (strong, nonatomic) id<FixActionAdditionals> fixActionAdditionalsDelegate;

    @property (strong, nonatomic) NSArray *delegates;

@end

// TODO: TransportBarController?
@implementation ActionController

- (instancetype)initWithPlayer:(AVPlayer*)player
                    controller:(AVPlayerViewController*)controller
{
    if (self = [super init])
    {
        _player = player;
        _playerItem = player.currentItem;
        _playerController = controller;
    }
    return self;
}

/**
 TODO: Xcode 13.3 causes a bug that resets the position everytime you click on something.
 TODO: Set _ to self if they are properties.
 */
- (void)setUpTransportBar {
    _randomAction = [self setUpAndRetreiveRandomActionForTransportBar];
    _randomActionResponder = [[RandomAction alloc] initWithAction:_randomAction player:_player actionController:self];
    
    _muteAction = [self setUpAndRetrieveMuteActionForTransportBar];
    _muteStateDelegate = [[MuteActionState alloc] initWithAction:_muteAction];
    
    _speedAction = [self setUpAndRetrieveSpeedActionForTransportBar];
    _speedStateDelegate = [[SpeedActionState alloc] initWithAction:_speedAction];
    
    _teleportAction = [self setUpAndRetrieveTeleportActionForTransportBar];
    _teleportStateDelegate = [[TeleportActionState alloc] initWithAction:_teleportAction];
    
    _reversiAction = [self setUpAndRetrieveReversiActionForTransportBar];
    _reversiStateDelegate = [[ReversiActionState alloc] initWithAction:_reversiAction];
    
    _confusedAction = [self setUpAndRetrieveConfusedActionForTransportBar];
    _confusedStateDelegate = [[ConfusedActionState alloc] initWithAction:_confusedAction];
    _unexpectedAction = (id<UnexpectedAction>)_confusedStateDelegate;
    
    _apocalypseAction = [self setUpAndRetrieveApocalypseActionForTransportBar];
    _apocalypseStateDelegate = [[ApocalypseActionState alloc] initWithAction:_apocalypseAction];
    
    _fixAction = [self setUpAndRetrieveFixActionForTransportBar];
    FixActionState *sharedFixAction = [[FixActionState alloc] initWithAction:_fixAction];
    _fixStateDelegate = sharedFixAction;
    _fixActionAdditionalsDelegate = sharedFixAction;
    
    _delegates = @[_muteStateDelegate, _speedStateDelegate, _teleportStateDelegate, _reversiStateDelegate, _confusedStateDelegate, _apocalypseStateDelegate];
    [_fixActionAdditionalsDelegate passInActionDelegates:_delegates];
    
    _playerController.transportBarCustomMenuItems = @[_randomAction, _muteAction, _speedAction, _teleportAction, _reversiAction, _confusedAction, _fixAction, _apocalypseAction];
}

- (UIAction *)setUpAndRetreiveRandomActionForTransportBar {
    UIAction *randomAction = [UIAction actionWithTitle:@"Random" image:_randomActionResponder.image identifier:nil handler:^(UIAction *action) {
        [self.fixActionAdditionalsDelegate setPlayerToBroken:self.player];
        [self.randomActionResponder carryOutRandomAction:self.delegates];
    }];
    return randomAction;
}

- (UIAction *)setUpAndRetrieveMuteActionForTransportBar {
    UIAction *muteAction = [UIAction actionWithTitle:@"Mute" image:_muteStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.muteStateDelegate];
    }];
    return muteAction;
}

- (UIAction *)setUpAndRetrieveSpeedActionForTransportBar {
    UIAction *speedAction = [UIAction actionWithTitle:@"Speed" image:_speedStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.speedStateDelegate];
    }];
    return speedAction;
}

- (UIAction *)setUpAndRetrieveTeleportActionForTransportBar {
    UIAction *teleportAction = [UIAction actionWithTitle:@"Teleport" image:_teleportStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.teleportStateDelegate];
    }];
    return teleportAction;
}

- (UIAction *)setUpAndRetrieveReversiActionForTransportBar {
    UIAction *reversiAction = [UIAction actionWithTitle:@"Reversi" image:_reversiStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.reversiStateDelegate];
    }];
    return reversiAction;
}

- (UIAction *)setUpAndRetrieveConfusedActionForTransportBar {
    UIAction *confusedAction = [UIAction actionWithTitle:@"Confused" image:_confusedStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.confusedStateDelegate];
    }];
    return confusedAction;
}

- (UIAction *)setUpAndRetrieveApocalypseActionForTransportBar {
    UIAction *apocalypseAction = [UIAction actionWithTitle:@"Apocalypse" image:_apocalypseStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.apocalypseStateDelegate];
    }];
    return apocalypseAction;
}

- (UIAction *)setUpAndRetrieveFixActionForTransportBar {
    UIAction *fixAction = [UIAction actionWithTitle:@"Fix" image:_fixStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.fixStateDelegate];
    }];
    return fixAction;
}

- (void)performAction:(id<ActionState>)action {
    [_fixActionAdditionalsDelegate setPlayerToBroken:_player];
    if ([action respondsToSelector:@selector(carryOutActionOnPlayer:)]) {
        [action carryOutActionOnPlayer:_player];
    }
    if ([action respondsToSelector:@selector(carryOutActionOnController:)]) {
        [action carryOutActionOnController:self];
    }
}

@end
