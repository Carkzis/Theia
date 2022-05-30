//
//  GestureController.m
//  Theia
//
//  Created by Marc Jowett on 03/05/2022.
//

#import "GestureController.h"

/**
 Controller for the gestures, which decides various actions that are undergone in reaction to
 remote control gestures such as playing, pausing and pressing the directional buttons.
 */
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

/**
 Sets up the play, pause and directional button gestures listeners.
 */
- (void)setUpGestures {
    [self setUpPlayPauseGestures];
    [self setUpDirectionalButtonTapGestures];
    [self setUpDirectionalButtonLongPressGestures];
}

/**
 Sets up the pause/play gesture listeners that decide what happens when the pause/play button is pressed for
 both short (tapped) and long periods of time.
 Note: The normal pause/play gesture listener only works when the buttons are pressed whilst the focus is
 on the scrub bar, not the transport bar, but the pausing/playing will still work.
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
 Sets up the gesture listeners that decide what happens when the right, left and up gestures are tapped.
 Note: These gestures listeners only work on the transport bar, not the scrub bar.
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
 Sets up the gesture listeners that decide what happens when the right, left and up gestures are held down and released.
 Note: These gestures listeners only work on the transport bar, not the scrub bar.
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

/**
 Handler that forwards the request to pause or play depending on the current state of the playing.
 Pauses when the player is currently playing; plays when the play is currently paused.
 */
- (void)playPauseToggleHandler {
    NSLog(@"Play/Pause pressed.");
    if (_player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [self pauseHandler];
    } else if (_player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
        [self playHandler];
    }
}

/**
 Pauses the player when the the GestureRecognizer observes a pause event.
 Note: An unexpected action make also occur if the player has an active Confused state.
 */
- (void)pauseHandler {
    NSLog(@"Pause.");
    [_player pause];
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

/**
 Plays the player when the the GestureRecognizer observes a play event.
 Note: An unexpected action make also occur if the player has an active Confused state.
 */
- (void)playHandler {
    NSLog(@"Play.");
    [_player play];
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

/**
 Handler for a right tap event.
 Note: An unexpected action make also occur if the player has an active Confused state.
 */
- (void)goRightHandler {
    NSLog(@"Right pressed.");
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

/**
 Handler for a left tap event.
 Note: An unexpected action make also occur if the player has an active Confused state.
 */
- (void)goLeftHandler {
    NSLog(@"Left pressed.");
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

/**
 Handler for an up tap event.
 Note: An unexpected action make also occur if the player has an active Confused state.
 */
- (void)goUpHandler {
    NSLog(@"Up pressed.");
    [_actionController.unexpectedAction mayDoUnexpectedActionOnPlayerIfConfused:_player];
}

/**
 Handler for a long play/pause button press event.
 Note: An unexpected action make also occur if the player has an active Confused state, and this can be both
 on beginning the press, and on releasing the press.
 */
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

/**
 Handler for a long right button press event.
 Note: An unexpected action make also occur if the player has an active Confused state, and this can be both
 on beginning the press, and on releasing the press.
 */
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

/**
 Handler for a long left button press event.
 Note: An unexpected action make also occur if the player has an active Confused state, and this can be both
 on beginning the press, and on releasing the press.
 */
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

/**
 Handler for a long up button press event.
 Note: An unexpected action make also occur if the player has an active Confused state, and this can be both
 on beginning the press, and on releasing the press.
 */
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
