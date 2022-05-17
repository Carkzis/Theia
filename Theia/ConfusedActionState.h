//
//  ConfusedActionState.h
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import <Foundation/Foundation.h>
#import "ActionState.h"
#import "UnexpectedAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface ConfusedActionState : NSObject <ActionState, UnexpectedAction>
- (instancetype)initWithAction:(UIAction *)action;
- (void)carryOutActionOnPlayer:(AVPlayer *)player;
- (void)resetValuesIncludingPlayer:(AVPlayer *)player;

- (void)mayDoUnexpectedActionOnPlayerIfConfused:(nonnull AVPlayer *)player;
@end

NS_ASSUME_NONNULL_END
