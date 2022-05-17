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
    @property (nonatomic) NSInteger apocalypseLevel;

    @property (strong, nonatomic) UIAction *fixAction;
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
    _fixAction = [self setUpAndRetrieveFixActionForTransportBar];
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
    UIImage *notDyingImage = [UIImage systemImageNamed:@"circle"];
    UIImage *dyingImage = [UIImage systemImageNamed:@"smallcircle.filled.circle"];
    UIImage *nearDeathImage = [UIImage systemImageNamed:@"flame.circle"];
    UIImage *apocalypseImage = [UIImage systemImageNamed:@"flame.fill"];
    
    typedef NS_ENUM(NSUInteger, ApocalypseLevel) {
        notDying = 0,
        dying = 1,
        nearDeath = 2,
        apocalypse = 3,
        end = 4
    };
    
    _apocalypseLevel = notDying;
    
    UIAction *apocalypseAction = [UIAction actionWithTitle:@"Apocalypse" image:notDyingImage identifier:nil handler:^(__weak UIAction *action) {
        [self setStatusOfPlayerToBroken];
        
        self.apocalypseLevel++;
        switch (self.apocalypseLevel) {
            case dying:
                self.apocalypseAction.image = dyingImage;
                break;
            case nearDeath:
                self.apocalypseAction.image = nearDeathImage;
                break;
            case apocalypse:
                self.apocalypseAction.image = apocalypseImage;
                break;
            case end:
                NSLog(@"Kaboom!");
                exit(0);
        }
    }];
    return apocalypseAction;
}

- (UIAction *)setUpAndRetrieveFixActionForTransportBar {
    _brokenImage = [UIImage systemImageNamed:@"wrench.and.screwdriver"];
    _fixedImage = [UIImage systemImageNamed:@"checkmark.seal"];
    
    UIAction *fixAction = [UIAction actionWithTitle:@"Fix" image:_fixedImage identifier:nil handler:^(__weak UIAction *action) {
        self.isBroken = !self.isBroken;
        if (self.isBroken) {
            self.fixAction.image = self.brokenImage;
        } else {
            self.fixAction.image = self.fixedImage;
            [self resetPlayerValues];
        }
    }];
    return fixAction;
}

- (void)setStatusOfPlayerToBroken {
    _isBroken = true;
    _fixAction.image = _brokenImage;
}

- (void)resetPlayerValues {
    [self.muteStateDelegate resetValuesIncludingPlayer:_player];
    [self.speedStateDelegate resetValuesIncludingPlayer:_player];
    [self.teleportStateDelegate resetValuesIncludingPlayer:_player];
    [self.reversiStateDelegate resetValuesIncludingController:self];
    _isConfused = false;
    _apocalypseLevel = 0;
    _isBroken = false;
    
    [self setUpTransportBar];
}

@end
