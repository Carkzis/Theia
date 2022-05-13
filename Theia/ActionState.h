//
//  ActionState.h
//  Theia
//
//  Created by Marc Jowett on 13/05/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ActionState <NSObject>

@required
@property (strong, nonatomic) UIAction *action;
@property (strong, nonatomic) UIImage *defaultImage;
@property (strong, nonatomic) NSMutableDictionary *images;
@property (nonatomic) BOOL isActive;

- (instancetype)initWithAction:(UIAction *)action;
- (void)carryOutActionOn:(AVPlayer *)player;
- (void)resetValue:(AVPlayer *)player;

@end

NS_ASSUME_NONNULL_END
