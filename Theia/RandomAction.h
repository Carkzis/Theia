//
//  RandomAction.h
//  Theia
//
//  Created by Marc Jowett on 27/05/2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ActionState.h"

NS_ASSUME_NONNULL_BEGIN

@interface RandomAction : NSObject

    @property (strong, nonatomic) UIImage *image;

    - (nonnull instancetype)initWithAction:(UIAction *)action
                                    player:(AVPlayer *)player
                          transportBarController:(TransportBarController *)controller;
    - (void)carryOutRandomAction:(NSArray *)actionDelegates;

@end

NS_ASSUME_NONNULL_END
