//
//  ConfusedActionable.m
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import "ConfusedActionable.h"

typedef NS_ENUM(NSUInteger, Confusedness) {
    lucid = 0,
    confused = 1
};

/**
 Actionable for the state and behaviour of the confused ("Confused") action, including its icon images.
 Randomly results in the player pausing/playing when pressing the directional button whilst on the Transport Bar.
 */
@implementation ConfusedActionable

@synthesize action;
@synthesize defaultImage;
@synthesize images;
@synthesize isActive;

- (nonnull instancetype)initWithAction:(nonnull UIAction *)action {
    if (self = [super init]) {
        self.action = action;
        self.defaultImage = [UIImage systemImageNamed:@"face.smiling"];
        self.action.image = defaultImage;
        self.isActive = false;
        self.images = [NSMutableDictionary dictionary];
        [images setObject: [UIImage systemImageNamed:@"face.smiling"] forKey:[NSNumber numberWithInteger:lucid]];
        [images setObject: [UIImage systemImageNamed:@"face.dashed"] forKey:[NSNumber numberWithInteger:confused]];
    }
    return self;
}

- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player {
    isActive = !isActive;
    if (isActive) {
        NSLog(@"Confused");
        action.image = [images objectForKey:[NSNumber numberWithInteger:confused]];
        [self mayDoUnexpectedActionOnPlayerIfConfused:player];
    } else {
        NSLog(@"Unconfused");
        action.image = [images objectForKey:[NSNumber numberWithInteger:lucid]];
    }
}

- (void)resetValuesIncludingPlayer:(nonnull AVPlayer *)player {
    isActive = false;
    action.image = defaultImage;
}

/**
 If the Actionable is active, may randomly do an unexpected action on the player; this does nothing otherwise.
 */
- (void)mayDoUnexpectedActionOnPlayerIfConfused:(nonnull AVPlayer *)player  {
    if (isActive) {
        [self doUnexpectedActionOnPlayer:player];
    } else {
        return;
    }
}

/**
 Results in a 20% chance of pausing if the player is currently playing, or playing if the player is currently paused.
 */
- (void)doUnexpectedActionOnPlayer:(nonnull AVPlayer *)player  {
    NSUInteger randomIndex = arc4random() % 100;
    if (randomIndex < 20) {
        if (player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
            NSLog(@"Unexpected pause!");
            [player pause];
        } else if (player.timeControlStatus == AVPlayerTimeControlStatusPaused) {
            NSLog(@"Unexpected play!");
            [player play];
        }
    }
}

@end
