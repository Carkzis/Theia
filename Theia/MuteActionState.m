//
//  MuteActionState.m
//  Theia
//
//  Created by Marc Jowett on 13/05/2022.
//

#import "MuteActionState.h"

typedef NS_ENUM(NSUInteger, Muteness) {
    unmuted = 0,
    muted = 1
};

@implementation MuteActionState

@synthesize action;
@synthesize defaultImage;
@synthesize images;
@synthesize isActive;

- (nonnull instancetype)initWithAction:(nonnull UIAction *)action {
    if (self = [super init])
    {
        self.action = action;
        self.defaultImage = [UIImage systemImageNamed:@"speaker.wave.2.fill"];
        self.action.image = defaultImage;
        self.isActive = false;
        self.images = [NSMutableDictionary dictionary];
        [self.images setObject: [UIImage systemImageNamed:@"speaker.wave.2.fill"] forKey:[NSNumber numberWithInteger:unmuted]];
        [self.images setObject: [UIImage systemImageNamed:@"speaker.zzz.fill"] forKey:[NSNumber numberWithInteger:muted]];
    }
    return self;
}

- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player {
    isActive = !isActive;
    if (isActive) {
        NSLog(@"Mute");
        action.image = [images objectForKey:[NSNumber numberWithInteger:muted]];
        [player setMuted:YES];
    } else {
        NSLog(@"Unmute");
        action.image = [images objectForKey:[NSNumber numberWithInteger:unmuted]];
        [player setMuted:NO];
    }
}

- (void)resetValuesIncludingPlayer:(nonnull AVPlayer *)player {
    isActive = false;
    action.image = defaultImage;
    [player setMuted:NO];
}

@end
