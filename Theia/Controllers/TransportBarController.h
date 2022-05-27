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
#import "Actionable.h"
#import "MuteActionable.h"
#import "SpeedActionable.h"
#import "TeleportActionable.h"
#import "ReversiActionable.h"
#import "ConfusedActionable.h"
#import "UnexpectedAction.h"
#import "ApocalypseActionable.h"
#import "FixActionable.h"
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
