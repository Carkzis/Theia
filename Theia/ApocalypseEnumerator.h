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
- (UIImage *)retrieveCurrentImage;
- (UIImage *)retrieveDefaultImage;
// Add retrieve current apocalypse level.
- (void)increment;
- (void)reset;
@end

NS_ASSUME_NONNULL_END
