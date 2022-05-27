//
//  ReversiActionable.h
//  Theia
//
//  Created by Marc Jowett on 16/05/2022.
//

#import <Foundation/Foundation.h>
#import "Actionable.h"
#import "TransportBarController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReversiActionable : NSObject <Actionable>
- (instancetype)initWithAction:(UIAction *)action;
- (void)carryOutActionOnController:(TransportBarController *)controller;
- (void)resetValuesIncludingController:(TransportBarController *)controller;
@end

NS_ASSUME_NONNULL_END
