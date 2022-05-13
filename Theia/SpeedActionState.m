//
//  SpeedActionState.m
//  Theia
//
//  Created by Marc Jowett on 13/05/2022.
//

#import "SpeedActionState.h"

typedef NS_ENUM(NSUInteger, Speed) {
    superslow = 0,
    slow = 1,
    standard = 2,
    fast = 3,
    superfast = 4
};

@interface SpeedActionState()
    @property (strong, nonatomic) NSMutableDictionary *speeds;
@end

@implementation SpeedActionState

@synthesize action;
@synthesize defaultImage;
@synthesize images;
@synthesize isActive;

- (nonnull instancetype)initWithAction:(nonnull UIAction *)action {
    if (self = [super init])
    {
        self.action = action;
        self.defaultImage = [UIImage systemImageNamed:@"figure.walk"];
        self.action.image = defaultImage;
        self.isActive = false;
        self.images = [NSMutableDictionary dictionary];
        [self setUpImages];
        [self setUpSpeeds];
    }
    return self;
}

- (void)setUpImages {
    [images setObject: [UIImage systemImageNamed:@"tortoise.fill"] forKey:[NSNumber numberWithInteger:superslow]];
    [images setObject: [UIImage systemImageNamed:@"ant.fill"] forKey:[NSNumber numberWithInteger:slow]];
    [images setObject: [UIImage systemImageNamed:@"figure.walk"] forKey:[NSNumber numberWithInteger:standard]];
    [images setObject: [UIImage systemImageNamed:@"hare.fill"] forKey:[NSNumber numberWithInteger:fast]];
    [images setObject: [UIImage systemImageNamed:@"pawprint.fill"] forKey:[NSNumber numberWithInteger:superfast]];
}

- (void)setUpSpeeds {
    self.speeds = [NSMutableDictionary dictionary];
    [_speeds setObject: @[@0.25, @"Superslow"] forKey: [NSNumber numberWithInteger:superslow]];
    [_speeds setObject: @[@0.5, @"Slow"] forKey: [NSNumber numberWithInteger:slow]];
    [_speeds setObject: @[@1.0, @"Speed Reset"] forKey: [NSNumber numberWithInteger:standard]];
    [_speeds setObject: @[@1.50, @"Fast"] forKey: [NSNumber numberWithInteger:fast]];
    [_speeds setObject: @[@2.0, @"Superfast"] forKey: [NSNumber numberWithInteger:superfast]];
}

- (void)carryOutActionOn:(nonnull AVPlayer *)player {
    isActive = !isActive;
    NSUInteger randomIndex = arc4random() % _speeds.count;
    player.rate = [[[_speeds objectForKey:[NSNumber numberWithInteger:randomIndex]] objectAtIndex:0] floatValue];
    action.image = [images objectForKey:[NSNumber numberWithInteger:randomIndex]];
    NSLog(@"%@", [[_speeds objectForKey:[NSNumber numberWithInteger:randomIndex]] objectAtIndex:1]);
}

- (void)resetValue:(nonnull AVPlayer *)player {
    isActive = false;
    action.image = defaultImage;
    if (player.timeControlStatus == AVPlayerTimeControlStatusPlaying) {
        [player setRate:1.0];
    } else {
        [player setRate:0.0];
    }
}

@end
