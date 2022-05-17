//
//  ConfusedActionState.m
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import "ConfusedActionState.h"

typedef NS_ENUM(NSUInteger, Muteness) {
    lucid = 0,
    confused = 1
};

@implementation ConfusedActionState

@synthesize action;
@synthesize defaultImage;
@synthesize images;
@synthesize isActive;

- (nonnull instancetype)initWithAction:(nonnull UIAction *)action {
    if (self = [super init]) {
        action = action;
        defaultImage = [UIImage systemImageNamed:@"face.smiling"];
        action.image = defaultImage;
        isActive = false;
        images = [NSMutableDictionary dictionary];
        [images setObject: [UIImage systemImageNamed:@"face.smiling"] forKey:[NSNumber numberWithInteger:lucid]];
        [images setObject: [UIImage systemImageNamed:@"face.dashed"] forKey:[NSNumber numberWithInteger:confused]];
    }
    return self;
}

- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player {
    isActive = !isActive;
    if (isActive) {
        action.image = [images objectForKey:[NSNumber numberWithInteger:confused]];
        [self mayDoUnexpectedActionOnPlayerIfConfused:player];
    } else {
        action.image = [images objectForKey:[NSNumber numberWithInteger:lucid]];
    }
}

- (void)resetValuesIncludingPlayer:(nonnull AVPlayer *)player {
    isActive = false;
}

- (void)mayDoUnexpectedActionOnPlayerIfConfused:(nonnull AVPlayer *)player  {
    if (isActive) {
        [self doUnexpectedActionOnPlayer:player];
    } else {
        return;
    }
}

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
