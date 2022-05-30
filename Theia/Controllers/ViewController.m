//
//  ViewController.m
//  Theia
//
//  Created by Marc Jowett on 14/04/2022.
//

#import "ViewController.h"
#import "GestureController.h"
#import "TransportBarController.h"

/**
 Main ViewController responsible for the interactions between the UI and the business logic of the player.
 */
@interface ViewController ()

@property (strong, nonatomic) AVURLAsset *asset;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerViewController *controller;
@property (strong, nonatomic) GestureController *gestures;
@property (strong, nonatomic) TransportBarController *actions;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 Initialises the Media Player with URL for the media content.
 */
- (IBAction)initialiseMediaPlayer:(id)sender {
    NSURL *url = [[NSURL alloc]
                  initWithString:VIDEO_URL];
    AVURLAsset *mediaAsset = [self retrieveMediaAsset:url];
    [self playMedia:mediaAsset];
}

/**
 Given a URL, retrieves an AVURLAsset.
 */
- (AVURLAsset*)retrieveMediaAsset:(NSURL *)url {
    if (!_asset) {
        _asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    }
    return _asset;
}

/**
 Plays the media content after setting up the AVPlayerController and gestures.
 */
- (void)playMedia:(AVURLAsset *)mediaAsset {
    AVPlayerItem *mediaItem = [[AVPlayerItem alloc] initWithAsset:mediaAsset];
    _player = [[AVPlayer alloc] initWithPlayerItem:mediaItem];
    [self setUpAVPlayerController];
    [self setUpGestures];
    [_player play];
}

/**
 Sets up the AVPlayerController.
 */
- (void)setUpAVPlayerController {
    _controller = [[AVPlayerViewController alloc] init];
    _controller.player = _player;
    [self setUpTransportBar];
    [self presentViewController: _controller animated: YES completion: nil];
}

/**
 Sets up the Transport Bar via the TransportBarController.
 */
- (void)setUpTransportBar {
    _actions = [[TransportBarController alloc] initWithPlayer:_player controller:_controller];
    [_actions setUpTransportBar];
}

/**
 Sets up the remote controller gestures via the GestureController.
 */
- (void)setUpGestures {
    _gestures = [[GestureController alloc] initWithPlayer:_player controller:_controller actionController:_actions];
    [_gestures setUpGestures];
}

@end
