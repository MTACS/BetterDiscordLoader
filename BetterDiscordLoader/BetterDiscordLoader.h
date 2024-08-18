//
//  BetterDiscordLoader.h
//  BetterDiscordLoader
//
//  Created by DF on 8/17/24.
//
//

#import <Foundation/Foundation.h>

@interface BetterDiscordLoader : NSObject
+ (instancetype)sharedInstance;
- (void)installBetterDiscord;
@end
