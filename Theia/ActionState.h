//
//  ActionState.h
//  Theia
//
//  Created by Marc Jowett on 13/05/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@class TransportBarController;

NS_ASSUME_NONNULL_BEGIN

@protocol ActionState <NSObject>

@required
@property (strong, nonatomic) UIAction *action;
@property (strong, nonatomic) UIImage *defaultImage;
@property (strong, nonatomic) NSMutableDictionary *images;
@property (nonatomic) BOOL isActive;

- (instancetype)initWithAction:(UIAction *)action;

@optional
- (void)carryOutActionOnPlayer:(AVPlayer *)player;
- (void)resetValuesIncludingPlayer:(AVPlayer *)player;
- (void)carryOutActionOnController:(TransportBarController *)controller;
- (void)resetValuesIncludingController:(TransportBarController *)controller;

@end

NS_ASSUME_NONNULL_END
