//
//  BetterDiscordLoader.m
//  BetterDiscordLoader
//
//  Created by DF on 8/17/24.
//
//

#import "BetterDiscordLoader.h"

BetterDiscordLoader *plugin;

@interface BetterDiscordLoader()
@end

@implementation BetterDiscordLoader
+ (instancetype)sharedInstance {
    static BetterDiscordLoader *plugin = nil;
    @synchronized(self) {
        if (!plugin) {
            plugin = [[self alloc] init];
        }
    }
    return plugin;
}
+ (void)load {
    BetterDiscordLoader *plugin = [BetterDiscordLoader sharedInstance];
    NSLog(@"[+] BetterDiscordLoader loaded");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMenuItem *betterDiscordItem = [[NSMenuItem alloc] init];
            [betterDiscordItem setTitle:@"BetterDiscord"];
        
            NSMenu *mainMenu = [[[[NSApp mainMenu] itemArray] firstObject] submenu];
            [mainMenu insertItem:[NSMenuItem separatorItem] atIndex:mainMenu.itemArray.count - 1];
            [mainMenu insertItem:betterDiscordItem atIndex:mainMenu.itemArray.count - 2];
            [mainMenu insertItem:[NSMenuItem separatorItem] atIndex:mainMenu.itemArray.count - 3];
            [mainMenu setSubmenu:[plugin betterDiscordMenu] forItem:betterDiscordItem];
    });
}
- (NSMenu *)betterDiscordMenu {
    NSMenu *subMenu = [[NSMenu alloc] initWithTitle:@"BetterDiscord"];
    NSMenuItem *installItem = [[NSMenuItem alloc] init];
    [installItem setTitle:@"Install BetterDiscord"];
    [installItem setTarget:self];
    [installItem setAction:@selector(installBetterDiscord)];
    [subMenu addItem:installItem];
    return subMenu;
}
- (void)installBetterDiscord {
    NSDictionary *defaults = [[NSUserDefaults standardUserDefaults] persistentDomainForName:[NSBundle mainBundle].bundleIdentifier];
    if (![defaults.allKeys containsObject:@"betterDiscordPath"]) {
        NSOpenPanel *dialog = [NSOpenPanel openPanel];
        [dialog setCanChooseFiles:YES];
        [dialog setCanChooseDirectories:YES];
        if ([dialog runModal] == NSModalResponseOK) {
            NSString *filePath = [[dialog.URL absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            [[NSUserDefaults standardUserDefaults] setObject:filePath forKey:@"betterDiscordPath"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self openBetterDiscord];
        }
    } else {
        [self openBetterDiscord];
    }
}
- (void)openBetterDiscord {
    NSWorkspace *workspace = [NSWorkspace sharedWorkspace];
    [workspace openApplicationAtURL:[NSURL fileURLWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"betterDiscordPath"]] configuration:[NSWorkspaceOpenConfiguration configuration] completionHandler:nil];
}
@end
