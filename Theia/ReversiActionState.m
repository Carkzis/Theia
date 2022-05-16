//
//  ReversiActionState.m
//  Theia
//
//  Created by Marc Jowett on 16/05/2022.
//

#import "ReversiActionState.h"

typedef NS_ENUM(NSUInteger, Muteness) {
    versi = 0,
    reversi = 1
};

@implementation ReversiActionState

@synthesize action;
@synthesize defaultImage;
@synthesize images;
@synthesize isActive;

- (nonnull instancetype)initWithAction:(nonnull UIAction *)action {
    return self;
}

- (void)carryOutActionOnController:(ActionController *)controller {
    // Not yet implemented.
}

- (void)resetValuesIncludingController:(ActionController *)controller {
    // Not yet implemented.
}

@end
