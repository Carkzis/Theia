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
    @property (strong, nonatomic) AVPlayerViewController *controller;

    @property (strong, nonatomic) UIAction *randomAction;

    @property (strong, nonatomic) UIAction *muteAction;

    @property (strong, nonatomic) UIAction *speedAction;

    @property (strong, nonatomic) UIAction *teleportAction;
    @property (nonatomic) CMTime teleportedFromPosition;
    @property (nonatomic) BOOL isTeleported;

    @property (strong, nonatomic) UIAction *reversiAction;
    @property (nonatomic) BOOL isReversi;

    @property (strong, nonatomic) UIAction *confusedAction;
    @property (nonatomic) BOOL isConfused;

    @property (strong, nonatomic) UIAction *apocalypseAction;
    @property (nonatomic) NSInteger uhOhRating;

    @property (strong, nonatomic) UIAction *fixAction;
    @property (nonatomic) BOOL isBroken;

@end

@implementation ActionController

- (instancetype)initWithPlayer:(AVPlayer*)player
                    controller:(AVPlayerViewController*)controller
{
    if (self = [super init])
    {
        _player = player;
        _playerItem = player.currentItem;
        _controller = controller;
    }
    return self;
}

- (void)setUpTransportBar {
    /*
     I am setting the actions as properties, as I want different actions to access each other.
     */
    _randomAction = [self setUpAndRetreiveRandomActionForTransportBar];
    _muteAction = [self setUpAndRetrieveMuteActionForTransportBar];
    _speedAction = [self setUpAndRetrieveSpeedActionForTransportBar];
    _teleportAction = [self setUpAndRetrieveTeleportActionForTransportBar];
    _reversiAction = [self setUpAndRetrieveReversiActionForTransportBar];
    _confusedAction = [self setUpAndRetrieveConfusedActionForTransportBar];
    _apocalypseAction = [self setUpAndRetrieveApocalypseActionForTransportBar];
    _fixAction = [self setUpAndRetrieveFixActionForTransportBar];
    _controller.transportBarCustomMenuItems = @[_randomAction, _muteAction, _speedAction, _teleportAction, _reversiAction, _fixAction, _apocalypseAction];
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
    UIImage *mutedImage = [UIImage systemImageNamed:@"speaker.zzz.fill"];
    UIImage *unmutedImage = [UIImage systemImageNamed:@"speaker.wave.2.fill"];
    UIImage *muteStateImage = _player.muted ? mutedImage : unmutedImage;
    UIAction *muteAction = [UIAction actionWithTitle:@"Mute" image:muteStateImage identifier:nil handler:^(__weak UIAction *action) {
        if (!self.player.muted) {
            NSLog(@"Mute");
            self.muteAction.image = mutedImage;
            [self.player setMuted:YES];
        } else {
            NSLog(@"Unmute");
            self.muteAction.image = unmutedImage;
            [self.player setMuted:NO];
        }
    }];
    
    return muteAction;
}

- (UIAction *)setUpAndRetrieveSpeedActionForTransportBar {
    UIImage *superSlowImage = [UIImage systemImageNamed:@"tortoise.fill"];
    UIImage *slowImage = [UIImage systemImageNamed:@"ant.fill"];
    UIImage *timeImage = [UIImage systemImageNamed:@"figure.walk"];
    UIImage *fastImage = [UIImage systemImageNamed:@"hare.fill"];
    UIImage *superFastImage = [UIImage systemImageNamed:@"pawprint.fill"];
    
    typedef NS_ENUM(NSUInteger, Speed) {
        superslow = 0,
        slow = 1,
        standard = 2,
        fast = 3,
        superfast = 4
    };
    
    NSMutableDictionary *speeds = [NSMutableDictionary dictionary];
    [speeds setObject: @[@0.25, superSlowImage, @"Superslow"] forKey: [NSNumber numberWithInteger:superslow]];
    [speeds setObject: @[@0.5, slowImage, @"Slow"] forKey: [NSNumber numberWithInteger:slow]];
    [speeds setObject: @[@1.0, timeImage, @"Speed Reset"] forKey: [NSNumber numberWithInteger:standard]];
    [speeds setObject: @[@1.50, fastImage, @"Fast"] forKey: [NSNumber numberWithInteger:fast]];
    [speeds setObject: @[@2.0, superFastImage, @"Superfast"] forKey: [NSNumber numberWithInteger:superfast]];
    
    UIAction *speedAction = [UIAction actionWithTitle:@"Speed" image:timeImage identifier:nil handler:^(__weak UIAction *action) {
        NSUInteger randomIndex = arc4random() % speeds.count;
        self.player.rate = [[[speeds objectForKey:[NSNumber numberWithInteger:randomIndex]] objectAtIndex:0] floatValue];
        self.speedAction.image = [[speeds objectForKey:[NSNumber numberWithInteger:randomIndex]] objectAtIndex:1];
        NSLog(@"%@", [[speeds objectForKey:[NSNumber numberWithInteger:randomIndex]] objectAtIndex:2]);
    }];
    return speedAction;
}

- (UIAction *)setUpAndRetrieveTeleportActionForTransportBar {
    UIImage *returnedImage = [UIImage systemImageNamed:@"lasso.and.sparkles"];
    UIImage *teleportedImage = [UIImage systemImageNamed:@"sparkles"];
    _isTeleported = false;
    
    UIAction *teleportAction = [UIAction actionWithTitle:@"Teleport" image:returnedImage identifier:nil handler:^(__weak UIAction *action) {
        self.isTeleported = !self.isTeleported;
        if (self.isTeleported) {
            self.teleportAction.image = teleportedImage;
            self.teleportedFromPosition = [self getCurrentPlayerTime];
            [self teleportToRandomPosition];
        } else {
            self.teleportAction.image = returnedImage;
            [self teleportToOriginalPosition];
        }
    }];
    return teleportAction;
}

- (CMTime)getCurrentPlayerTime {
    CMTime cachedPosition = _playerItem.currentTime;
    return cachedPosition;
}

- (void)teleportToRandomPosition {
    CMTimeValue timeValue = _playerItem.duration.value;
    CMTimeScale timeScale = _playerItem.duration.timescale;
    CMTimeValue randomTimeValue = arc4random() % timeValue;
    [self formatNewTimeAndSeek:randomTimeValue withScale:timeScale];
}

- (void)teleportToOriginalPosition {
    CMTimeScale timeScale = _playerItem.currentTime.timescale;
    [self formatNewTimeAndSeek:_teleportedFromPosition.value withScale:timeScale];
}

- (void)formatNewTimeAndSeek:(CMTimeValue)value withScale:(CMTimeScale)scale {
    CMTime formattedTeleportTime = CMTimeMake((float)value, scale);
    [self.player seekToTime:formattedTeleportTime];
}

- (UIAction *)setUpAndRetrieveReversiActionForTransportBar {
    UIImage *forwardsImage = [UIImage systemImageNamed:@"chevron.forward.circle"];
    UIImage *backwardsImage = [UIImage systemImageNamed:@"chevron.backward.circle"];
    
    UIImage *reversiStateImage = _isReversi ? backwardsImage : forwardsImage;
    UIAction *reversiAction = [UIAction actionWithTitle:@"Reversi" image:reversiStateImage identifier:nil handler:^(__weak UIAction *action) {
        self.isReversi = !self.isReversi;
        NSArray *reversedArray = [[self.controller.transportBarCustomMenuItems reverseObjectEnumerator] allObjects];
        self.controller.transportBarCustomMenuItems = reversedArray;
    }];
    return reversiAction;
}

- (UIAction *)setUpAndRetrieveConfusedActionForTransportBar {
    /*
     TODO: Make this a confused action, not another reversi action.
     */
    UIImage *lucidImage = [UIImage systemImageNamed:@"face.smiling"];
    UIImage *confusedImage = [UIImage systemImageNamed:@"face.dashed"];
    
    UIImage *confusedStateImage = _isConfused ? confusedImage : lucidImage;
    
    UIAction *confusedAction = [UIAction actionWithTitle:@"Confused" image:confusedStateImage identifier:nil handler:^(__weak UIAction *action) {
        self.isConfused = !self.isConfused;
        if (self.isConfused) {
            self.confusedAction.image = lucidImage;
            /*
             TODO: Make an action that will make it more difficult for inputs to register.
             */
        } else {
            self.confusedAction.image = confusedImage;
            /*
             TODO: Make it so inputs register normally.
             */
        }
    }];
    return confusedAction;
}

- (UIAction *)setUpAndRetrieveApocalypseActionForTransportBar {
    UIImage *notDyingImage = [UIImage systemImageNamed:@"circle"];
    UIImage *dyingImage = [UIImage systemImageNamed:@"smallcircle.filled.circle"];
    UIImage *nearDeathImage = [UIImage systemImageNamed:@"flame.circle"];
    UIImage *apocalypseImage = [UIImage systemImageNamed:@"flame.fill"];
    
    // TODO: This will be replaced by an enum at a later time.
    _uhOhRating = 0;
    
    UIAction *apocalypseAction = [UIAction actionWithTitle:@"Apocalypse" image:notDyingImage identifier:nil handler:^(__weak UIAction *action) {
        /*
         TODO: Make this work.
         */
        self.uhOhRating++;
        switch (self.uhOhRating) {
            case 1:
                self.apocalypseAction.image = dyingImage;
                break;
            case 2:
                self.apocalypseAction.image = nearDeathImage;
                break;
            case 3:
                self.apocalypseAction.image = apocalypseImage;
                break;
            default:
                self.apocalypseAction.image = notDyingImage;
                // exit(0);
                self.uhOhRating = 0;
        }
    }];
    return apocalypseAction;
}

- (UIAction *)setUpAndRetrieveFixActionForTransportBar {
    UIImage *brokenImage = [UIImage systemImageNamed:@"wrench.and.screwdriver"];
    UIImage *fixedImage = [UIImage systemImageNamed:@"checkmark.seal"];
    
    UIAction *fixAction = [UIAction actionWithTitle:@"Fix" image:fixedImage identifier:nil handler:^(__weak UIAction *action) {
        self.isBroken = !self.isBroken;
        if (self.isBroken) {
            self.fixAction.image = brokenImage;
            /*
             TODO: Remove this, this should only be changed as a side effect.
             */
        } else {
            self.fixAction.image = fixedImage;
            /*
             TODO: Reset all the items to their original states, including button images.
             */
        }
    }];
    return fixAction;
}

@end
