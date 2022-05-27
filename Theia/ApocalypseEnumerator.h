//
//  ApocalypseEnumerator.h
//  Theia
//
//  Created by Marc Jowett on 17/05/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApocalypseEnumerator : NSObject
    typedef NS_ENUM(NSUInteger, ApocalypseLevel) {
        notDying = 0,
        dying = 1,
        nearDeath = 2,
        apocalypse = 3,
        end = 4
    };
    - (NSUInteger)retrieveNextApocalypseLevel;
    - (void)resetApocalypseLevel;
@end

NS_ASSUME_NONNULL_END
