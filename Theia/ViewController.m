//
//  ViewController.m
//  Theia
//
//  Created by Marc Jowett on 14/04/2022.
//

#import "ViewController.h"
#import "GestureController.h"

@interface ViewController ()
    @property (strong, nonatomic) AVURLAsset *asset;
    @property (strong, nonatomic) AVPlayer *player;
    @property (strong, nonatomic) AVPlayerViewController *controller;
    @property (strong, nonatomic) GestureController *gestures;

    @property (strong, nonatomic) UIAction *randomAction;
    @property (strong, nonatomic) UIAction *muteAction;
    @property (strong, nonatomic) UIAction *speedAction;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setUpPlayButton];
}

- (void)setUpPlayButton {
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [playButton sizeToFit];
    playButton.center = self.view.center;
    
    // Add a target method to the button for when it is clicked.
    [playButton addTarget:self action:@selector(playMovie:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self.view addSubview:playButton];
}

- (void)playMovie:(UIButton *)playButton {
    NSURL *url = [[NSURL alloc]
                  initWithString:@"NOTANURL"];
    AVURLAsset *mediaAsset = [self retrieveMediaAsset:url];
    [self playMedia:mediaAsset];
}

- (void)playMedia:(AVURLAsset *)mediaAsset {
    AVPlayerItem *mediaItem = [[AVPlayerItem alloc] initWithAsset:mediaAsset];
    _player = [[AVPlayer alloc] initWithPlayerItem:mediaItem];
    [self setUpAVPlayerController];
    [self setUpGestures];
    [_player play];
}

- (AVURLAsset*)retrieveMediaAsset:(NSURL *)url {
    if (!_asset) {
        _asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    }
    return _asset;
}

- (void)setUpAVPlayerController {
    _controller = [[AVPlayerViewController alloc] init];
    _controller.player = _player;
    [self setUpTransportBar];
    [self presentViewController: _controller animated: YES completion: nil];
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

// FIXME: When you click mute AND cause the image to change, the cursor goes to the rightmost action button in the transport bar.
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

- (void)setUpGestures {
    _gestures = [[GestureController alloc] initWithPlayer:_player controller:_controller];
    [_gestures setUpGestures];
    
    
}

@end
