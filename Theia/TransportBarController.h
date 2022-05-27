//
//  TransportBarController.h
//  Theia
//
//  Created by Marc Jowett on 03/05/2022.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ActionState.h"
#import "MuteActionState.h"
#import "SpeedActionState.h"
#import "TeleportActionState.h"
#import "ReversiActionState.h"
#import "ConfusedActionState.h"
#import "UnexpectedAction.h"
#import "ApocalypseActionState.h"
#import "FixActionState.h"
#import "FixActionAdditionals.h"
#import "RandomAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransportBarController : NSObject

@property (nonatomic) BOOL isConfused;
@property (strong, nonatomic) AVPlayerViewController *playerController;
@property (strong, nonatomic) id<UnexpectedAction> unexpectedAction;

- (instancetype)initWithPlayer:(AVPlayer *)player
                    controller:(AVPlayerViewController *)controller;
- (void)setUpTransportBar;
@end

NS_ASSUME_NONNULL_END