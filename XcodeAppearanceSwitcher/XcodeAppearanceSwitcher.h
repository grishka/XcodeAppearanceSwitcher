//
//  XcodeAppearanceSwitcher.h
//  XcodeAppearanceSwitcher
//
//  Created by Grishka on 06/10/2018.
//

#import <AppKit/AppKit.h>

@interface XcodeAppearanceSwitcher : NSObject

+ (instancetype)sharedPlugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end
