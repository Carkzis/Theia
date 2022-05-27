//
//  ReversiActionState.h
//  Theia
//
//  Created by Marc Jowett on 16/05/2022.
//

#import <Foundation/Foundation.h>
#import "ActionState.h"
#import "TransportBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReversiActionState : NSObject <ActionState>
- (instancetype)initWithAction:(UIAction *)action;
- (void)carryOutActionOnController:(TransportBarController *)controller;
- (void)resetValuesIncludingController:(TransportBarController *)controller;
@end

NS_ASSUME_NONNULL_END
