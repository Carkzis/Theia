//
//  GestureController.h
//  Theia
//
//  Created by Marc Jowett on 03/05/2022.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ActionController.h"
// #import "ConfusedActionState.h"

NS_ASSUME_NONNULL_BEGIN

@interface GestureController : UIViewController
- (instancetype)initWithPlayer:(AVPlayer *)player
                    controller:(AVPlayerViewController *)controller
              actionController:(ActionController*)actionController;
- (void)setUpGestures;
@end

NS_ASSUME_NONNULL_END
