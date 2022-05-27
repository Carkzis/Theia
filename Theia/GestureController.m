//
//  GestureController.m
//  Theia
//
//  Created by Marc Jowett on 03/05/2022.
//

#import "GestureController.h"

@interface GestureController ()
    @property (strong, nonatomic) AVPlayer *player;
    @property (strong, nonatomic) AVPlayerViewController *controller;

    @property (strong, nonatomic) TransportBarController *actionController;
@end

@implementation GestureController

- (instancetype)initWithPlayer:(AVPlayer *)player
                    controller:(AVPlayerViewController *)controller
              actionController:(TransportBarController *)actionController
{
    if ((self = [super init])) {
        _player = player;
        _controller = controller;
        _actionController = actionController;
    }
    return self;
}

- (void)setUpGestures {
    [self setUpPlayPauseGestures];
    [self setUpDirectionalButtonTapGestures];
    [self setUpDirectionalButtonLongPressGestures];
}

/**
 Note: The normal pause/play gesture only works on the scrub bar, not the transport bar.
 */
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

- (void)playPauseToggleHandler {
    NSLog(@"Play/Pause pressed.");
    if (_player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self pauseHandler];
    } else if (_player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
        [self playHandler];
    }
}

- (void)pauseHandler {
    NSLog(@"Pause.");
    [_player pause];
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

- (void)playHandler {
    NSLog(@"Play.");
    [_player play];
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

- (void)goRightHandler {
    NSLog(@"Right pressed.");
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

- (void)goLeftHandler {
    NSLog(@"Left pressed.");
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

- (void)goUpHandler {
    NSLog(@"Up pressed.");
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

- (void)longPlayPauseToggleHandler:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Long play press begins!");
            [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Long play press ends!");
            [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
        default:
            break;
    }
}

- (void)longGoRightHandler:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Long right begins!");
            [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Long right ends!");
            [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
        default:
            break;
    }
}

- (void)longGoLeftHandler:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Long left begins!");
            [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Long left ends!");
            [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
        default:
            break;
    }
}

- (void)longGoUpHandler:(UILongPressGestureRecognizer *)longPressGesture {
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"Long up begins!");
            [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"Long up ends!");
            [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
        default:
            break;
    }
}

@end
