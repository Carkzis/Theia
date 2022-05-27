//
//  TeleportActionState.m
//  Theia
//
//  Created by Marc Jowett on 16/05/2022.
//

#import "TeleportActionState.h"

typedef NS_ENUM(NSUInteger, TeleportStatus) {
    returned = 0,
    teleported = 1
};

@interface TeleportActionState()
    @property (strong, nonatomic) NSMutableDictionary *speeds;
    @property (nonatomic) CMTime originalPosition;
@end

@implementation TeleportActionState

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

- (void)setUpImages {
    defaultImage = [UIImage systemImageNamed:@"lasso.and.sparkles"];
    action.image = defaultImage;
    
    [images setObject: self.defaultImage forKey:[NSNumber numberWithInteger:returned]];
    [images setObject: [UIImage systemImageNamed:@"sparkles"] forKey:[NSNumber numberWithInteger:teleported]];
}

- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player {
    isActive = !isActive;
    if (isActive) {
        action.image = [images objectForKey:[NSNumber numberWithInteger:teleported]];
        _originalPosition = [self getCurrentPlayerItemTime: player.currentItem];
        CMTime newRandomPosition = [self generateRandomPlayerPosition:player.currentItem];
        [player seekToTime:newRandomPosition];
    } else {
        action.image = [images objectForKey:[NSNumber numberWithInteger:returned]];
        [player seekToTime:self.originalPosition];
    }
}

- (CMTime)getCurrentPlayerItemTime:(AVPlayerItem *)playerItem {
    CMTime cachedPosition = playerItem.currentTime;
    return cachedPosition;
}

- (CMTime)generateRandomPlayerPosition:(AVPlayerItem *)playerItem {
    CMTimeValue timeValue = playerItem.duration.value;
    CMTimeScale timeScale = playerItem.duration.timescale;
    CMTimeValue randomTimeValue = arc4random() % timeValue;
    CMTime formattedTeleportTime = CMTimeMake((float)randomTimeValue, timeScale);
    return formattedTeleportTime;
}

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
