//
//  ActionController.h
//  Theia
//
//  Created by Marc Jowett on 03/05/2022.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActionController : NSObject
- (instancetype)initWithPlayer:(AVPlayer *)player
                    controller:(AVPlayerViewController *)controller;
- (void)setUpTransportBar;
@end

NS_ASSUME_NONNULL_END
