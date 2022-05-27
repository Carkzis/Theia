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

    @property (nonatomic) BOOL isBroken;
    @property (strong, nonatomic) UIImage *brokenImage;
    @property (strong, nonatomic) UIImage *fixedImage;

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
    [_fixActionAdditionalsDelegate passInActionDelegates:@[_muteStateDelegate, _speedStateDelegate, _teleportStateDelegate, _reversiStateDelegate, _confusedStateDelegate, _apocalypseStateDelegate]];
    
    _playerController.transportBarCustomMenuItems = @[_randomAction, _muteAction, _speedAction, _teleportAction, _reversiAction, _confusedAction, _fixAction, _apocalypseAction];
}

- (UIAction *)setUpAndRetreiveRandomActionForTransportBar {
    UIImage *image = [UIImage systemImageNamed:@"questionmark.diamond"];
    UIAction *randomAction = [UIAction actionWithTitle:@"Random" image:image identifier:nil handler:^(UIAction *action) {
        /*
         TODO: Make a random event occur!
         */
        NSLog(@"A random event occured.");
    }];
    return randomAction;
}

- (UIAction *)setUpAndRetrieveMuteActionForTransportBar {
    UIAction *muteAction = [UIAction actionWithTitle:@"Mute" image:_muteStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self setStatusOfPlayerToBroken];
        [self.muteStateDelegate carryOutActionOnPlayer:self.player];
    }];
    return muteAction;
}

- (UIAction *)setUpAndRetrieveSpeedActionForTransportBar {
    UIAction *speedAction = [UIAction actionWithTitle:@"Speed" image:_speedStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self setStatusOfPlayerToBroken];
        [self.speedStateDelegate carryOutActionOnPlayer:self.player];
    }];
    return speedAction;
}

- (UIAction *)setUpAndRetrieveTeleportActionForTransportBar {
    UIAction *teleportAction = [UIAction actionWithTitle:@"Teleport" image:_teleportStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self setStatusOfPlayerToBroken];
        [self.teleportStateDelegate carryOutActionOnPlayer:self.player];
    }];
    return teleportAction;
}

- (UIAction *)setUpAndRetrieveReversiActionForTransportBar {
    UIAction *reversiAction = [UIAction actionWithTitle:@"Reversi" image:_reversiStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self setStatusOfPlayerToBroken];
        [self.reversiStateDelegate carryOutActionOnController:self];
    }];
    return reversiAction;
}

- (UIAction *)setUpAndRetrieveConfusedActionForTransportBar {
    UIAction *confusedAction = [UIAction actionWithTitle:@"Confused" image:_confusedStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self setStatusOfPlayerToBroken];
        [self.confusedStateDelegate carryOutActionOnPlayer:self.player];
    }];
    return confusedAction;
}

- (UIAction *)setUpAndRetrieveApocalypseActionForTransportBar {
    UIAction *apocalypseAction = [UIAction actionWithTitle:@"Apocalypse" image:_apocalypseStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self setStatusOfPlayerToBroken];
        [self.apocalypseStateDelegate carryOutActionOnPlayer:self.player];
    }];
    return apocalypseAction;
}

- (UIAction *)setUpAndRetrieveFixActionForTransportBar {
    UIAction *fixAction = [UIAction actionWithTitle:@"Fix" image:_fixStateDelegate.defaultImage identifier:nil handler:^(__weak UIAction *action) {
        [self setStatusOfPlayerToBroken];
        [self.fixStateDelegate carryOutActionOnPlayer:self.player];
        [self.fixStateDelegate carryOutActionOnController:self];
    }];
    return fixAction;
}

- (void)setStatusOfPlayerToBroken {
    [self.fixActionAdditionalsDelegate setPlayerToBroken:self.player];
}

- (void)resetPlayerValues {
    [self.muteStateDelegate resetValuesIncludingPlayer:_player];
    [self.speedStateDelegate resetValuesIncludingPlayer:_player];
    [self.teleportStateDelegate resetValuesIncludingPlayer:_player];
    [self.reversiStateDelegate resetValuesIncludingController:self];
    [self.confusedStateDelegate resetValuesIncludingPlayer:_player];
    [self.apocalypseStateDelegate resetValuesIncludingPlayer:_player];
    _isBroken = false;
    
    [self setUpTransportBar];
}

// TODO: If response to includingPlayer, if response to includingController.

@end
