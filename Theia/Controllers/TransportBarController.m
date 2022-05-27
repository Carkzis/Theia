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
    @property (strong, nonatomic) id<Actionable> muteActionableDelegate;
    @property (strong, nonatomic) id<Actionable> speedActionableDelegate;
    @property (strong, nonatomic) id<Actionable> teleportActionableDelegate;
    @property (strong, nonatomic) id<Actionable> reversiActionableDelegate;
    @property (strong, nonatomic) id<Actionable> confusedActionableDelegate;
    @property (strong, nonatomic) id<Actionable> apocalypseActionableDelegate;
    @property (strong, nonatomic) id<Actionable> fixActionableDelegate;
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
    _muteActionableDelegate = [[MuteActionable alloc] initWithAction:_muteAction];
    _speedActionableDelegate = [[SpeedActionable alloc] initWithAction:_speedAction];
    _teleportActionableDelegate = [[TeleportActionable alloc] initWithAction:_teleportAction];
    _reversiActionableDelegate = [[ReversiActionable alloc] initWithAction:_reversiAction];
    _confusedActionableDelegate = [[ConfusedActionable alloc] initWithAction:_confusedAction];
    _unexpectedAction = (id<UnexpectedAction>)_confusedActionableDelegate;
    _apocalypseActionableDelegate = [[ApocalypseActionable alloc] initWithAction:_apocalypseAction];
    _fixActionableDelegate = [[FixActionable alloc] initWithAction:_fixAction];
    _fixActionAdditionalsDelegate = (id<FixActionAdditionals>)_fixActionableDelegate;
    
    _delegates = @[_muteActionableDelegate, _speedActionableDelegate, _teleportActionableDelegate, _reversiActionableDelegate, _confusedActionableDelegate, _apocalypseActionableDelegate];
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
    UIAction *muteAction = [UIAction actionWithTitle:@"Mute" image:_muteActionableDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.muteActionableDelegate];
    }];
    return muteAction;
}

- (UIAction *)setUpAndRetrieveSpeedActionForTransportBar {
    UIAction *speedAction = [UIAction actionWithTitle:@"Speed" image:_speedActionableDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.speedActionableDelegate];
    }];
    return speedAction;
}

- (UIAction *)setUpAndRetrieveTeleportActionForTransportBar {
    UIAction *teleportAction = [UIAction actionWithTitle:@"Teleport" image:_teleportActionableDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.teleportActionableDelegate];
    }];
    return teleportAction;
}

- (UIAction *)setUpAndRetrieveReversiActionForTransportBar {
    UIAction *reversiAction = [UIAction actionWithTitle:@"Reversi" image:_reversiActionableDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.reversiActionableDelegate];
    }];
    return reversiAction;
}

- (UIAction *)setUpAndRetrieveConfusedActionForTransportBar {
    UIAction *confusedAction = [UIAction actionWithTitle:@"Confused" image:_confusedActionableDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.confusedActionableDelegate];
    }];
    return confusedAction;
}

- (UIAction *)setUpAndRetrieveApocalypseActionForTransportBar {
    UIAction *apocalypseAction = [UIAction actionWithTitle:@"Apocalypse" image:_apocalypseActionableDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.apocalypseActionableDelegate];
    }];
    return apocalypseAction;
}

- (UIAction *)setUpAndRetrieveFixActionForTransportBar {
    UIAction *fixAction = [UIAction actionWithTitle:@"Fix" image:_fixActionableDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self performAction:self.fixActionableDelegate];
    }];
    return fixAction;
}

- (void)performAction:(id<Actionable>)action {
    [_fixActionAdditionalsDelegate setPlayerToBroken:_player];
    if ([action respondsToSelector:@selector(carryOutActionOnPlayer:)]) {
        [action carryOutActionOnPlayer:_player];
    }
    if ([action respondsToSelector:@selector(carryOutActionOnController:)]) {
        [action carryOutActionOnController:self];
    }
}

@end
