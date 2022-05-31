//
//  UnexpectedAction.h
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol for allowing an unexpected action to potentially occur on the player.
 */
@protocol UnexpectedAction <NSObject>

@optional

- (void)mayDoUnexpectedActionOnPlayerIfConfused:(nonnull AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
