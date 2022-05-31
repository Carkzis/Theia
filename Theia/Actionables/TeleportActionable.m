//
//  TeleportActionable.m
//  Theia
//
//  Created by Marc Jowett on 16/05/2022.
//

#import "TeleportActionable.h"

typedef NS_ENUM(NSUInteger, TeleportStatus) {
    returned = 0,
    teleported = 1
};

/**
 Actionable for the state and behaviour of the teleport ("Teleport") action, including its icon images.
 Randomly changes the playback position within the player, and returns to the original, cached position
 when inactivated.
 */
@interface TeleportActionable()

@property (strong, nonatomic) NSMutableDictionary *speeds;
@property (nonatomic) CMTime originalPosition;

@end

@implementation TeleportActionable

@synthesize action;
@synthesize defaultImage;
@synthesize images;
@synthesize isActive;

- (nonnull instancetype)initWithAction:(nonnull UIAction *)action {
    if (self = [super init]) {
        self.action = action;
        self.isActive = false;
        self.images = [NSMutableDictionary dictionary];
        [self setUpImages];
    }
    return self;
}

/**
 Sets up the images for the Actionable, with a different one for each state.
 */
- (void)setUpImages {
    defaultImage = [UIImage systemImageNamed:@"lasso.and.sparkles"];
    action.image = defaultImage;
    
    [images setObject: self.defaultImage forKey:[NSNumber numberWithInteger:returned]];
    [images setObject: [UIImage systemImageNamed:@"sparkles"] forKey:[NSNumber numberWithInteger:teleported]];
}

- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player {
    isActive = !isActive;
    if (isActive) {
        NSLog(@"Teleport Away");
        action.image = [images objectForKey:[NSNumber numberWithInteger:teleported]];
        _originalPosition = [self getCurrentPlayerItemTime: player.currentItem];
        CMTime newRandomPosition = [self generateRandomPlayerPosition:player.currentItem];
        [player seekToTime:newRandomPosition];
    } else {
        NSLog(@"Teleport Back");
        action.image = [images objectForKey:[NSNumber numberWithInteger:returned]];
        [player seekToTime:self.originalPosition];
    }
}

/**
 Retrieves the current player item time.
 */
- (CMTime)getCurrentPlayerItemTime:(AVPlayerItem *)playerItem {
    CMTime cachedPosition = playerItem.currentTime;
    return cachedPosition;
}

/**
 Generates a new, random player position within the confines of the player item.
 */
- (CMTime)generateRandomPlayerPosition:(AVPlayerItem *)playerItem {
    CMTimeValue timeValue = playerItem.duration.value;
    CMTimeScale timeScale = playerItem.duration.timescale;
    CMTimeValue randomTimeValue = arc4random() % timeValue;
    CMTime formattedTeleportTime = CMTimeMake((float)randomTimeValue, timeScale);
    return formattedTeleportTime;
}

/**
 Changes the current playback position.
 */
- (void)teleportToPosition:(CMTime)timePosition withPlayer:(nonnull AVPlayer *)player {
    [player seekToTime:timePosition];
}

- (void)resetValuesIncludingPlayer:(nonnull AVPlayer *)player {
    if (isActive) {
        [self teleportToPosition:_originalPosition withPlayer:player];
    }
    isActive = false;
    action.image = defaultImage;
}

@end
