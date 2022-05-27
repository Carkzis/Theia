//
//  ApocalypseActionable.h
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import <Foundation/Foundation.h>
#import "Actionable.h"
#import "ApocalypseEnumerator.h"

NS_ASSUME_NONNULL_BEGIN

@interface ApocalypseActionable : NSObject <Actionable>
- (instancetype)initWithAction:(UIAction *)action;
- (void)carryOutActionOnPlayer:(AVPlayer *)player;
- (void)resetValuesIncludingPlayer:(AVPlayer *)player;
@end

NS_ASSUME_NONNULL_END
