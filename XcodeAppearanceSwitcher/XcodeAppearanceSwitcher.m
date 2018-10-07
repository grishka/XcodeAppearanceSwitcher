//
//  XcodeAppearanceSwitcher.m
//  XcodeAppearanceSwitcher
//
//  Created by Grishka on 06/10/2018.
//

#import "XcodeAppearanceSwitcher.h"

static XcodeAppearanceSwitcher *sharedPlugin;

@implementation XcodeAppearanceSwitcher{
	NSMenu* chooserMenu;
}

#pragma mark - Initialization

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    NSArray *allowedLoaders = [plugin objectForInfoDictionaryKey:@"me.delisa.XcodePluginBase.AllowedLoaders"];
    if ([allowedLoaders containsObject:[[NSBundle mainBundle] bundleIdentifier]]) {
        sharedPlugin = [[self alloc] initWithBundle:plugin];
    }
}

+ (instancetype)sharedPlugin
{
    return sharedPlugin;
}

- (id)initWithBundle:(NSBundle *)bundle
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        _bundle = bundle;
        // NSApp may be nil if the plugin is loaded from the xcodebuild command line tool
        if (NSApp && !NSApp.mainMenu) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationDidFinishLaunching:)
                                                         name:NSApplicationDidFinishLaunchingNotification
                                                       object:nil];
        } else {
            [self initializeAndLog];
        }
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSApplicationDidFinishLaunchingNotification object:nil];
    [self initializeAndLog];
}

- (void)initializeAndLog
{
    NSString *name = [self.bundle objectForInfoDictionaryKey:@"CFBundleName"];
    NSString *version = [self.bundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *status = [self initialize] ? @"loaded successfully" : @"failed to load";
    NSLog(@"🔌 Plugin %@ %@ %@", name, version, status);
}

#pragma mark - Implementation

- (BOOL)initialize
{
    // Create menu items, initialize UI, etc.
    // Sample Menu Item:
    NSMenuItem *menuItem = [[NSApp mainMenu] itemWithTitle:@"View"];
    if (menuItem) {
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Appearance" action:@selector(doMenuAction) keyEquivalent:@""];
		NSMenu* chooser=[[NSMenu alloc] initWithTitle:@"Appearance"];
		[chooser addItem:[[NSMenuItem alloc] initWithTitle:@"Use System Preference" action:@selector(setSystemDefaultTheme) keyEquivalent:@""]];
		[chooser addItem:[[NSMenuItem alloc] initWithTitle:@"Dark" action:@selector(setDarkTheme) keyEquivalent:@""]];
		[chooser addItem:[[NSMenuItem alloc] initWithTitle:@"Light" action:@selector(setLightTheme) keyEquivalent:@""]];
		for(NSMenuItem* item in [chooser itemArray]){
			[item setTarget:self];
		}
		[actionMenuItem setSubmenu:chooser];
		chooserMenu=chooser;
        [actionMenuItem setTarget:self];
        [[menuItem submenu] addItem:actionMenuItem];
		[self applyThemePreference:(int)[[self myUserDefaults] integerForKey:@"ChosenAppearance"]];
        return YES;
    } else {
        return NO;
    }
}

// Sample Action, for menu item:
- (void)doMenuAction{
	
}

- (NSUserDefaults*)myUserDefaults{
	return [[NSUserDefaults alloc] initWithSuiteName:[[sharedPlugin bundle] bundleIdentifier]];
}

- (void)saveAndApplyThemePreference:(int)pref{
	[[self myUserDefaults] setInteger:pref forKey:@"ChosenAppearance"];
	[self applyThemePreference:pref];
}

- (void)applyThemePreference:(int)pref{
	NSAppearance* appearance=nil;
	switch(pref){
		case 0:
			break;
		case 1:
			appearance=[NSAppearance appearanceNamed:NSAppearanceNameDarkAqua];
			break;
		case 2:
			appearance=[NSAppearance appearanceNamed:NSAppearanceNameAqua];
			break;
	}
	[[NSApplication sharedApplication] setAppearance:appearance];
	NSArray<NSMenuItem*>* items=[chooserMenu itemArray];
	for(int i=0;i<[items count];i++){
		[items[i] setState:pref==i ? NSControlStateValueOn : NSControlStateValueOff];
	}
}

- (void)setSystemDefaultTheme{
	[self saveAndApplyThemePreference:0];
}
- (void)setLightTheme{
	[self saveAndApplyThemePreference:2];
}
- (void)setDarkTheme{
	[self saveAndApplyThemePreference:1];
}

@end
