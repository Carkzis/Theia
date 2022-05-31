//
//  Actionable.h
//  Theia
//
//  Created by Marc Jowett on 13/05/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@class TransportBarController;

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol for the state and behaviour of any actions that reside on the player's Transport Bar,
 including its icon images.
 */
@protocol Actionable <NSObject>

@required

@property (strong, nonatomic) UIAction *action;
@property (strong, nonatomic) UIImage *defaultImage;
@property (strong, nonatomic) NSMutableDictionary *images;
@property (nonatomic) BOOL isActive;

- (instancetype)initWithAction:(UIAction *)action;

@optional

/**
 Carries out an action on the player.
 */
- (void)carryOutActionOnPlayer:(AVPlayer *)player;
/**
 Resets the Actionable to the original values, as well as any effects it had on the player.
 */
- (void)resetValuesIncludingPlayer:(AVPlayer *)player;
/**
 Carries out an action on the Transport Bar.
 */
- (void)carryOutActionOnController:(TransportBarController *)controller;
/**
 Resets the Actionable to the original values, as well as any effects it had on the Transport Bar.
 */
- (void)resetValuesIncludingController:(TransportBarController *)controller;

@end

NS_ASSUME_NONNULL_END
