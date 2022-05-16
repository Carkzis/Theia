//
//  TeleportActionState.h
//  Theia
//
//  Created by Marc Jowett on 16/05/2022.
//

#import <Foundation/Foundation.h>
#import "ActionState.h"

NS_ASSUME_NONNULL_BEGIN

@interface TeleportActionState : NSObject <ActionState>
- (instancetype)initWithAction:(UIAction *)action;
- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player;
- (void)resetValuesIncludingPlayer:(nonnull AVPlayer *)player;
@end

NS_ASSUME_NONNULL_END
