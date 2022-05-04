//
//  ActionController.m
//  Theia
//
//  Created by Marc Jowett on 03/05/2022.
//

#import "ActionController.h"

@interface ActionController()
    @property (strong, nonatomic) AVPlayer *player;
    @property (strong, nonatomic) AVPlayerViewController *controller;

    @property (strong, nonatomic) UIAction *randomAction;
    @property (strong, nonatomic) UIAction *muteAction;
    @property (strong, nonatomic) UIAction *speedAction;
@end

@implementation ActionController

- (instancetype)initWithPlayer:(AVPlayer*)player
                    controller:(AVPlayerViewController*)controller
{
    if (self = [super init])
    {
        _player = player;
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
    _controller.transportBarCustomMenuItems = @[_randomAction, _muteAction, _speedAction];
}

- (UIAction *)setUpAndRetreiveRandomActionForTransportBar {
    UIImage *image = [UIImage systemImageNamed:@"questionmark.diamond"];
    UIAction *randomAction = [UIAction actionWithTitle:@"Random" image:image identifier:nil handler:^(UIAction *action) {
        NSLog(@"A random event occured.");
    }];
    return randomAction;
}

/*
 FIXME: When you click a button in the transport bar and cause the image to change, the cursor goes to the rightmost action button in the transport bar.
 */

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

@end
