//
//  ActionState.h
//  Theia
//
//  Created by Marc Jowett on 13/05/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@class ActionController;

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
- (void)carryOutActionOnController:(ActionController *)controller;
- (void)resetValuesIncludingController:(ActionController *)controller;

@end

NS_ASSUME_NONNULL_END
