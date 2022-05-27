//
//  TransportBarController.m
//  Theia
//
//  Created by Marc Jowett on 03/05/2022.
//

#import "TransportBarController.h"

@interface TransportBarController()

    @property (strong, nonatomic) AVPlayer *player;
    @property (strong, nonatomic) AVPlayerItem *playerItem;

    @property (strong, nonatomic) UIAction *randomAction;
    @property (strong, nonatomic) UIAction *muteAction;
    @property (strong, nonatomic) UIAction *speedAction;
    @property (strong, nonatomic) UIAction *teleportAction;
    @property (strong, nonatomic) UIAction *reversiAction;
    @property (strong, nonatomic) UIAction *confusedAction;
    @property (strong, nonatomic) UIAction *apocalypseAction;
    @property (strong, nonatomic) UIAction *fixAction;

    @property (strong, nonatomic) RandomAction *randomActionResponder;
    @property (strong, nonatomic) id<ActionState> muteStateDelegate;
    @property (strong, nonatomic) id<ActionState> speedStateDelegate;
    @property (strong, nonatomic) id<ActionState> teleportStateDelegate;
    @property (strong, nonatomic) id<ActionState> reversiStateDelegate;
    @property (strong, nonatomic) id<ActionState> confusedStateDelegate;
    @property (strong, nonatomic) id<ActionState> apocalypseStateDelegate;
    @property (strong, nonatomic) id<ActionState> fixStateDelegate;
    @property (strong, nonatomic) id<FixActionAdditionals> fixActionAdditionalsDelegate;

    @property (strong, nonatomic) NSArray *delegates;

@end

@implementation TransportBarController

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

- (void)setUpTransportBar {
    [self setUpActions];
    [self setUpDelegates];
    
    _playerController.transportBarCustomMenuItems = @[_randomAction, _muteAction, _speedAction, _teleportAction, _reversiAction, _confusedAction, _fixAction, _apocalypseAction];
}

- (void)setUpActions {
    _randomAction = [self setUpAndRetreiveRandomActionForTransportBar];
    _muteAction = [self setUpAndRetrieveMuteActionForTransportBar];
    _speedAction = [self setUpAndRetrieveSpeedActionForTransportBar];
    _teleportAction = [self setUpAndRetrieveTeleportActionForTransportBar];
    _reversiAction = [self setUpAndRetrieveReversiActionForTransportBar];
    _confusedAction = [self setUpAndRetrieveConfusedActionForTransportBar];
    _apocalypseAction = [self setUpAndRetrieveApocalypseActionForTransportBar];
    _fixAction = [self setUpAndRetrieveFixActionForTransportBar];
}

- (void)setUpDelegates {
    _randomActionResponder = [[RandomAction alloc] initWithAction:_randomAction player:_player transportBarController:self];
    _muteStateDelegate = [[MuteActionState alloc] initWithAction:_muteAction];
    _speedStateDelegate = [[SpeedActionState alloc] initWithAction:_speedAction];
    _teleportStateDelegate = [[TeleportActionState alloc] initWithAction:_teleportAction];
    _reversiStateDelegate = [[ReversiActionState alloc] initWithAction:_reversiAction];
    _confusedStateDelegate = [[ConfusedActionState alloc] initWithAction:_confusedAction];
    _unexpectedAction = (id<UnexpectedAction>)_confusedStateDelegate;
    _apocalypseStateDelegate = [[ApocalypseActionState alloc] initWithAction:_apocalypseAction];
    _fixStateDelegate = [[FixActionState alloc] initWithAction:_fixAction];
    _fixActionAdditionalsDelegate = (id<FixActionAdditionals>)_fixStateDelegate;
    
    _delegates = @[_muteStateDelegate, _speedStateDelegate, _teleportStateDelegate, _reversiStateDelegate, _confusedStateDelegate, _apocalypseStateDelegate];
    [_fixActionAdditionalsDelegate passInActionDelegates:_delegates];
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
