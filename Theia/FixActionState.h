//
//  FixActionState.h
//  Theia
//
//  Created by Marc Jowett on 27/05/2022.
//

#import <Foundation/Foundation.h>
#import "ActionState.h"
#import "FixActionAdditionals.h"

NS_ASSUME_NONNULL_BEGIN

@interface FixActionState : NSObject <ActionState, FixActionAdditionals>
- (instancetype)initWithAction:(UIAction *)action;
- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player;
- (void)carryOutActionOnController:(ActionController *)controller;
- (void)resetValuesIncludingPlayer:(nonnull AVPlayer *)player;
- (void)passInActionDelegates:(NSArray *)delegates;
@end

NS_ASSUME_NONNULL_END
