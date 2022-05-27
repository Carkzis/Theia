//
//  ApocalypseActionState.m
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import "ApocalypseActionState.h"

@interface ApocalypseActionState()
    @property (nonatomic) NSInteger apocalypseLevel;
    @property (strong, nonatomic) ApocalypseEnumerator *enumerator;
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
        self.enumerator = [[ApocalypseEnumerator alloc] init];
        
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
    NSUInteger nextLevel = [_enumerator retrieveNextApocalypseLevel];
    
    if (nextLevel == end) {
        NSLog(@"Kaboom!");
        exit(0);
    } else {
        action.image = [images objectForKey:[NSNumber numberWithInteger:nextLevel]];
    }
}

- (void)resetValuesIncludingPlayer:(nonnull AVPlayer *)player {
    [_enumerator resetApocalypseLevel];
    self.action.image = defaultImage;
    isActive = false;
}

@end
