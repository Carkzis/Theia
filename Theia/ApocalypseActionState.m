//
//  ApocalypseActionState.m
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import "ApocalypseActionState.h"

typedef NS_ENUM(NSUInteger, ApocalypseLevel) {
    notDying = 0,
    dying = 1,
    nearDeath = 2,
    apocalypse = 3,
    end = 4
};

@interface ApocalypseActionState()
    @property (nonatomic) NSInteger apocalypseLevel;
@end

@implementation ApocalypseActionState
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
        _apocalypseLevel = notDying;
    }
    return self;
}

- (void)setUpImages {
    defaultImage = [UIImage systemImageNamed:@"circle"];
    action.image = defaultImage;
    
    [images setObject: defaultImage forKey:[NSNumber numberWithInteger:notDying]];
    [images setObject: [UIImage systemImageNamed:@"smallcircle.filled.circle"] forKey:[NSNumber numberWithInteger:dying]];
    [images setObject: [UIImage systemImageNamed:@"flame.circle"] forKey:[NSNumber numberWithInteger:nearDeath]];
    [images setObject: [UIImage systemImageNamed:@"flame.fill"] forKey:[NSNumber numberWithInteger:apocalypse]];
}


- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player {
    isActive = !isActive;
    _apocalypseLevel++;
    switch (self.apocalypseLevel) {
        case dying:
            action.image = [images objectForKey:[NSNumber numberWithInteger:dying]];
            break;
        case nearDeath:
            action.image = [images objectForKey:[NSNumber numberWithInteger:nearDeath]];
            break;
        case apocalypse:
            action.image = [images objectForKey:[NSNumber numberWithInteger:apocalypse]];;
            break;
        case end:
            NSLog(@"Kaboom!");
            exit(0);
    }
}

- (void)resetValuesIncludingPlayer:(nonnull AVPlayer *)player {
    _apocalypseLevel = notDying;
    self.action.image = defaultImage;
    isActive = false;
}

@end
