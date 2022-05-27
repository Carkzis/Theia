//
//  FixActionState.h
//  Theia
//
//  Created by Marc Jowett on 27/05/2022.
//

#import <Foundation/Foundation.h>
#import "Actionable.h"
#import "FixActionAdditionals.h"

NS_ASSUME_NONNULL_BEGIN

@interface FixActionable : NSObject <Actionable, FixActionAdditionals>
- (instancetype)initWithAction:(UIAction *)action;
- (void)carryOutActionOnPlayer:(nonnull AVPlayer *)player;
- (void)carryOutActionOnController:(TransportBarController *)controller;
- (void)passInActionDelegates:(NSArray *)delegates;
@end

NS_ASSUME_NONNULL_END
