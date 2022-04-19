//
//  ViewController.m
//  Theia
//
//  Created by Marc Jowett on 14/04/2022.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

AVURLAsset *asset;
AVPlayer *player;
AVPlayerViewController *controller;
BOOL isMuted;
BOOL isPlaying;

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
    // TODO: This should have an option to use a provided URL.
    /*
     "https://ia800300.us.archive.org/1/items/night_of_the_living_dead/night_of_the_living_dead_512kb.mp4"
     */
    NSURL *url = [[NSURL alloc]
                  initWithString:@"https://vod-hls-uk-live.akamaized.net/usp/auth/vod/piff_abr_full_hd/efd8aa-m000crsj/vf_m000crsj_d8ecfb25-9648-4ca8-8b19-664f28c3344a.ism/mobile_wifi_main_sd_abr_v2_hls_master.m3u8?__gda__=1650377428_cad4de8c3fea760109c2c26f3427cf5e"];
    AVURLAsset *mediaAsset = [self retrieveMediaAsset:url];
    [self playMedia:mediaAsset];
}

- (void)playMedia:(AVURLAsset *)mediaAsset {
    AVPlayerItem *mediaItem = [[AVPlayerItem alloc] initWithAsset:mediaAsset];
    player = [[AVPlayer alloc] initWithPlayerItem:mediaItem];
    [self setUpAVPlayerController];
    [self setUpRemoteCommandCentre];
    [player play];
}

- (AVURLAsset*)retrieveMediaAsset:(NSURL *)url {
    if (!asset) {
        asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    }
    return asset;
}

- (void)muteToggle {
    isMuted = !isMuted;
    player.muted = isMuted;
}

- (void)setUpAVPlayerController {
    controller = [[AVPlayerViewController alloc] init];
    controller.player = player;
    [self presentViewController: controller animated: YES completion: nil];
}

- (void)setUpRemoteCommandCentre {
    // This is what actions will be taken when carrying out actions on the remote.
    UITapGestureRecognizer *playPauseToggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPauseToggleCommand)];
    playPauseToggleGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypePlayPause]];
    [[controller view] addGestureRecognizer:playPauseToggleGesture];

    UITapGestureRecognizer *selectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCommand)];
    selectGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeSelect]];
    [[controller view] addGestureRecognizer:selectGesture];

    UITapGestureRecognizer *pressRightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipForwardCommand)];
    pressRightGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeRightArrow]];
    [[controller view] addGestureRecognizer:pressRightGesture];

    UITapGestureRecognizer *pressLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skipBackwardCommand)];
    pressLeftGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeLeftArrow]];
    [[controller view] addGestureRecognizer:pressLeftGesture];

    UILongPressGestureRecognizer *longPressRightGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(seekForwardCommand)];
    longPressRightGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeRightArrow]];
    [[controller view] addGestureRecognizer:longPressRightGesture];

    UILongPressGestureRecognizer *longPressLeftGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(seekBackwardCommand)];
    longPressLeftGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeRightArrow]];
    [[controller view] addGestureRecognizer:longPressLeftGesture];
    
    // This is what actions will be taken when carrying out actions on the remote.
    MPRemoteCommandCenter *remoteCommandCentre = [MPRemoteCommandCenter sharedCommandCenter];
    [[remoteCommandCentre playCommand]addTarget:self action:@selector(playCommand)];
    [[remoteCommandCentre pauseCommand]addTarget:self action:@selector(pauseCommand)];
    [[remoteCommandCentre togglePlayPauseCommand]addTarget:self action:@selector(playPauseToggleCommand)];
    [[remoteCommandCentre seekForwardCommand]addTarget:self action:@selector(seekForwardCommand)];
    [[remoteCommandCentre seekBackwardCommand]addTarget:self action:@selector(seekBackwardCommand)];
    [[remoteCommandCentre skipForwardCommand]addTarget:self action:@selector(skipForwardCommand)];
    [[remoteCommandCentre skipBackwardCommand]addTarget:self action:@selector(skipBackwardCommand)];
}

- (MPRemoteCommandHandlerStatus)playPauseToggleCommand {
    NSLog(@"Play/Pause pressed.");
    if (player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        return self.pauseCommand;
    } else if (player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
        return self.playCommand;
    }
    return MPRemoteCommandHandlerStatusCommandFailed;
}

- (MPRemoteCommandHandlerStatus)pauseCommand {
    NSLog(@"Pause.");
    [player pause];
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)playCommand {
    NSLog(@"Play.");
    [player play];
    return MPRemoteCommandHandlerStatusSuccess;
}

/**
 I have separated this from the pause and play for the time being,
 as due to race conditions it is causing pause/play to toggle on and off whenever it is selected.
 */
- (MPRemoteCommandHandlerStatus)selectCommand {
    NSLog(@"Select.");
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)seekForwardCommand {
    NSLog(@"Seek forward long pressed.");
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)seekBackwardCommand {
    NSLog(@"Seek backward long pressed.");
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)skipForwardCommand {
    NSLog(@"Skip forward pressed.");
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)skipBackwardCommand {
    NSLog(@"Skip backward pressed.");
    [player setMuted:YES];
    return MPRemoteCommandHandlerStatusSuccess;
}

@end
