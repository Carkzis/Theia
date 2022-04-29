//
//  ViewController.m
//  Theia
//
//  Created by Marc Jowett on 14/04/2022.
//

#import "ViewController.h"

@interface ViewController ()
    @property (strong, nonatomic) AVURLAsset *asset;
    @property (strong, nonatomic) AVPlayer *player;
    @property (strong, nonatomic) AVPlayerViewController *controller;
    @property (nonatomic) BOOL isMuted;
    @property (nonatomic) BOOL isPlaying;
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
    // "https://ia800300.us.archive.org/1/items/night_of_the_living_dead/night_of_the_living_dead_512kb.mp4"
    NSURL *url = [[NSURL alloc]
                  initWithString:@"https://ia800300.us.archive.org/1/items/night_of_the_living_dead/night_of_the_living_dead_512kb.mp4"];
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

- (void)muteToggle {
    _isMuted = !_isMuted;
    _player.muted = _isMuted;
}

- (void)setUpAVPlayerController {
    _controller = [[AVPlayerViewController alloc] init];
    _controller.player = _player;
    [self setUpTransportBar];
    [self presentViewController: _controller animated: YES completion: nil];
}

- (void)setUpTransportBar {
    UIAction *randomAction = [self setUpAndRetreiveRandomActionForTransportBar];
    UIAction *muteAction = [self setUpAndRetrieveMuteActionForTransportBar];
    _controller.transportBarCustomMenuItems = @[randomAction, muteAction];
}

- (UIAction *)setUpAndRetreiveRandomActionForTransportBar {
    UIImage *image = [UIImage systemImageNamed:@"questionmark.diamond"];
    UIAction *randomAction = [UIAction actionWithTitle:@"Random" image:image identifier:nil handler:^(UIAction *action) {
        NSLog(@"A random event occured.");
    }];
    return randomAction;
}

// FIXME: When you click mute, the cursor goes to the rightmost action button in the transport bar.
- (UIAction *)setUpAndRetrieveMuteActionForTransportBar {
    UIImage *mutedImage = [UIImage systemImageNamed:@"speaker.slash.fill"];
    UIImage *unmutedImage = [UIImage systemImageNamed:@"speaker.slash"];
    UIImage *muteStateImage = _player.muted ? mutedImage : unmutedImage;
    UIAction *muteAction = [UIAction actionWithTitle:@"Mute" image:muteStateImage identifier:nil handler:^(__weak UIAction *action) {
        if (!self.player.muted) {
            NSLog(@"Mute");
            action.image = mutedImage;
            [self.player setMuted:YES];
        } else {
            NSLog(@"Unmute");
            action.image = unmutedImage;
            [self.player setMuted:NO];
        }
    }];
    
    return muteAction;
}

- (void)setUpGestures {
    // This is what actions will be taken when carrying out actions on the remote.
    [self setUpPlayPauseGestures];
    [self setUpDirectionalButtonTapGestures];
    [self setUpDirectionalButtonLongPressGestures];
}

- (void)setUpPlayPauseGestures {
    UITapGestureRecognizer *playPauseToggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPauseToggleHandler)];
    playPauseToggleGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypePlayPause]];
    [[_controller view] addGestureRecognizer:playPauseToggleGesture];
    
    UILongPressGestureRecognizer *longPlayPauseToggleGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPlayPauseToggleHandler:)];
    longPlayPauseToggleGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypePlayPause]];
    [[_controller view] addGestureRecognizer:longPlayPauseToggleGesture];
}

/**
 Note: These only work on the transport bar.
 */
- (void)setUpDirectionalButtonTapGestures {
    UITapGestureRecognizer *pressRightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goRightHandler)];
    pressRightGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeRightArrow]];
    //pressRightGesture.cancelsTouchesInView = YES;
    [[_controller view] addGestureRecognizer:pressRightGesture];

    UITapGestureRecognizer *pressLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLeftHandler)];
    pressLeftGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeLeftArrow]];
    [[_controller view] addGestureRecognizer:pressLeftGesture];
    
    UITapGestureRecognizer *pressUpGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goUpHandler)];
    pressUpGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeUpArrow]];
    [[_controller view] addGestureRecognizer:pressUpGesture];
}

/**
 Note: These only work on the transport bar.
 */
- (void)setUpDirectionalButtonLongPressGestures {
    UILongPressGestureRecognizer *longPressRightGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGoRightHandler:)];
    longPressRightGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeRightArrow]];
    [[_controller view] addGestureRecognizer:longPressRightGesture];

    UILongPressGestureRecognizer *longPressLeftGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGoLeftHandler:)];
    longPressLeftGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeLeftArrow]];
    [[_controller view] addGestureRecognizer:longPressLeftGesture];

    UILongPressGestureRecognizer *longPressUpGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGoUpHandler:)];
    longPressUpGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeUpArrow]];
    [[_controller view] addGestureRecognizer:longPressUpGesture];
}

- (MPRemoteCommandHandlerStatus)playPauseToggleHandler {
    NSLog(@"Play/Pause pressed.");
    if (_player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        return self.pauseHandler;
    } else if (_player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
        return self.playHandler;
    }
    return MPRemoteCommandHandlerStatusCommandFailed;
}

- (MPRemoteCommandHandlerStatus)pauseHandler {
    NSLog(@"Pause.");
    [_player pause];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)playHandler {
    NSLog(@"Play.");
    [_player play];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)goRightHandler {
    NSLog(@"Right pressed.");
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)goLeftHandler {
    NSLog(@"Left pressed.");
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)goUpHandler {
    NSLog(@"Up pressed.");
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)longPlayPauseToggleHandler:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Long play press begins!");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Long play press ends!");
        default:
            break;
    }
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)longGoRightHandler:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Long right begins!");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Long right ends!");
        default:
            break;
    }

    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)longGoLeftHandler:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Long left begins!");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Long left ends!");
        default:
            break;
    }
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)longGoUpHandler:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Long up begins!");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Long up ends!");
        default:
            break;
    }
    return MPRemoteCommandHandlerStatusSuccess;
}

@end
