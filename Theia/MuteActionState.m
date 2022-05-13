//
//  MuteActionState.m
//  Theia
//
//  Created by Marc Jowett on 13/05/2022.
//

#import "MuteActionState.h"

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
        [self.images setObject: [UIImage systemImageNamed:@"speaker.wave.2.fill"] forKey:@"unmuted"];
        [self.images setObject: [UIImage systemImageNamed:@"speaker.zzz.fill"] forKey:@"muted"];
    }
    return self;
}

- (void)carryOutActionOn:(nonnull AVPlayer *)player {
    isActive = !isActive;
    if (isActive) {
        NSLog(@"Mute");
        self.action.image = [images objectForKey:@"muted"];
        [player setMuted:YES];
    } else {
        NSLog(@"Unmute");
        self.action.image = [images objectForKey:@"unmuted"];
        [player setMuted:NO];
    }
}

- (void)resetValue:(nonnull AVPlayer *)player {
    isActive = false;
    self.action.image = [images objectForKey:@"unmuted"];
    [player setMuted:NO];
}

@end
