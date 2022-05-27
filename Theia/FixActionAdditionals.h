//
//  FixActionAdditionals.h
//  Theia
//
//  Created by Marc Jowett on 27/05/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FixActionAdditionals <NSObject>
- (void)setPlayerToBroken:(nonnull AVPlayer *)player;
- (void)passInActionDelegates:(NSArray *)delegates;
@end

NS_ASSUME_NONNULL_END
