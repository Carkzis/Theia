//
//  FixActionAdditionals.h
//  Theia
//
//  Created by Marc Jowett on 27/05/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol for allowing additional methods associated with the FixActionable specifically.
 */
@protocol FixActionableAdditionals <NSObject>

/**
 Passes in an array of delegates that implement the Actionable protocol.
 */
- (void)passInActionDelegates:(NSArray *)delegates;
/**
 Sets the FixActionable to the broken.
 */
- (void)setPlayerToBroken:(nonnull AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
