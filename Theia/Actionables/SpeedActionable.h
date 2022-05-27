//
//  SpeedActionable.h
//  Theia
//
//  Created by Marc Jowett on 13/05/2022.
//

#import <Foundation/Foundation.h>
#import "Actionable.h"

NS_ASSUME_NONNULL_BEGIN

@interface SpeedActionable : NSObject <Actionable>

- (instancetype)initWithAction:(UIAction *)action;
- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player;
- (void)resetValuesIncludingPlayer:(nonnull AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
