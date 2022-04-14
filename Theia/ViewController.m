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
    NSLog(@"The play button has been pressed!");
    NSURL *url = [[NSURL alloc]
                  initWithString:@"https://ia800300.us.archive.org/1/items/night_of_the_living_dead/night_of_the_living_dead_512kb.mp4"];
    [self playMedia:url];
}

- (void)playMedia:(NSURL *)url {
    AVURLAsset *mediaAsset = [self retrieveMediaAsset:url];
    AVPlayerItem *mediaItem = [[AVPlayerItem alloc] initWithAsset:mediaAsset];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:mediaItem];
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    [self presentViewController: controller animated: YES completion: nil];
    controller.player = player;
    [player play];
}

- (AVURLAsset*)retrieveMediaAsset:(NSURL *)url {
    if (!asset) {
        NSLog(@"New asset!");
        asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    } else {
        NSLog(@"Already exists!");
    }
    return asset;
}

@end
