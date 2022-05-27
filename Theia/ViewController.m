//
//  ViewController.m
//  Theia
//
//  Created by Marc Jowett on 14/04/2022.
//

#import "ViewController.h"
#import "GestureController.h"
#import "TransportBarController.h"

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

- (IBAction)initialiseMediaPlayer:(id)sender {
    NSString *ultimateFunExampleFun = @"http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8";
    NSURL *url = [[NSURL alloc]
                  initWithString:ultimateFunExampleFun];
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
    _actions = [[TransportBarController alloc] initWithPlayer:_player controller:_controller];
    [_actions setUpTransportBar];
}

- (void)setUpGestures {
    _gestures = [[GestureController alloc] initWithPlayer:_player controller:_controller actionController:_actions];
    [_gestures setUpGestures];
}

@end
