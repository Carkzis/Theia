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
    NSURL *url = [[NSURL alloc]
                  initWithString:@"https://ia800300.us.archive.org/1/items/night_of_the_living_dead/night_of_the_living_dead_512kb.mp4"];
    AVURLAsset *mediaAsset = [self retrieveMediaAsset:url];
    [self playMedia:mediaAsset];
}

- (void)playMedia:(AVURLAsset *)mediaAsset {
    AVPlayerItem *mediaItem = [[AVPlayerItem alloc] initWithAsset:mediaAsset];
    player = [[AVPlayer alloc] initWithPlayerItem:mediaItem];
    [self setUpAVPlayerController];
    [self setUpRemoteCommandCentre];
    [player play];
    isPlaying = true;
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
    // Gesture to handle play pause status.
    UITapGestureRecognizer *playPauseToggleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPauseToggleCommand)];
    playPauseToggleGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypePlayPause], [NSNumber numberWithInteger:UIPressTypeSelect]];
    [[controller view] addGestureRecognizer:playPauseToggleGesture];
    
    UITapGestureRecognizer *pressRightGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seekForwardCommand)];
    pressRightGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeRightArrow]];
    [[controller view] addGestureRecognizer:pressRightGesture];
    
    UITapGestureRecognizer *pressLeftGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seekBackwardCommand)];
    pressRightGesture.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeLeftArrow]];
    [[controller view] addGestureRecognizer:pressLeftGesture];
    
    MPRemoteCommandCenter *remoteCommandCentre = [MPRemoteCommandCenter sharedCommandCenter];
    [[remoteCommandCentre playCommand]addTarget:self action:@selector(playPauseToggleCommand)];
}

- (MPRemoteCommandHandlerStatus)playPauseToggleCommand {
    if (isPlaying) {
        [player play];
    } else {
        [player pause];
    }
    isPlaying = !isPlaying;
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)seekForwardCommand {
    return MPRemoteCommandHandlerStatusSuccess;
}

- (MPRemoteCommandHandlerStatus)seekBackwardCommand {
    return MPRemoteCommandHandlerStatusSuccess;
}

@end
