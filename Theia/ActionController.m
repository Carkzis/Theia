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
    UIImage *lucidImage = [UIImage systemImageNamed:@"face.smiling"];
    UIImage *confusedImage = [UIImage systemImageNamed:@"face.dashed"];
    
    UIImage *confusedStateImage = _isConfused ? confusedImage : lucidImage;
    UIAction *confusedAction = [UIAction actionWithTitle:@"Confused" image:confusedStateImage identifier:nil handler:^(__weak UIAction *action) {
        [self setStatusOfPlayerToBroken];
        
        self.isConfused = !self.isConfused;
        self.confusedAction.image = self.isConfused ? confusedImage : lucidImage;
        [self mayDoUnexpectedActionIfConfused];
    }];
    return confusedAction;
}

// TODO: Tricky one, GestureController is linked to this!
- (void)mayDoUnexpectedActionIfConfused {
    if (_isConfused) {
        [self doUnexpectedAction];
    } else {
        return;
    }
}

- (void)doUnexpectedAction {
    NSUInteger randomIndex = arc4random() % 100;
    if (randomIndex < 20) {
        if (_player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
            NSLog(@"Unexpected pause!");
            [_player pause];
        } else if (_player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
            NSLog(@"Unexpected play!");
            [_player play];
        }
    }
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
    _player.muted = false;
    _player.rate = (_player.timeControlStatus == AVPlayerTimeControlStatusPlaying) ? 1.0 : 0.0;
    [self.teleportStateDelegate resetValuesIncludingPlayer:_player];
    [self.reversiStateDelegate resetValuesIncludingController:self];
    _isConfused = false;
    _apocalypseLevel = 0;
    _isBroken = false;
    
    [self setUpTransportBar];
}

@end
