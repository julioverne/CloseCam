#import <dlfcn.h>
#import <objc/runtime.h>
#include <sys/sysctl.h>
#import <substrate.h>


#define NSLog(...)

@interface SBApplication : NSObject
- (id)bundleIdentifier;
- (id)displayName;
@end

@interface UIApplication ()
- (UIDeviceOrientation)_frontMostAppOrientation;
- (SBApplication*)_accessibilityFrontMostApplication;
@end

@interface SBMainSwitcherViewController : UIViewController
+(id)sharedInstanceIfExists;
-(void)_removeCardForDisplayIdentifier:(id)arg1 ;
-(void)_removeAppLayout:(id)arg1 forReason:(long long)arg2 modelMutationBlock:(/*^block*/id)arg3 completion:(/*^block*/id)arg4 ;
-(NSArray*)appLayouts;
-(void)_quitAppsRepresentedByAppLayout:(id)arg1 forReason:(long long)arg2 ;
-(BOOL)dismissSwitcherNoninteractively;
@end

@interface SBDisplayItem : NSObject
+(id)homeScreenDisplayItem;
@end

@interface SBAppLayout : NSObject
@property (assign,nonatomic) long long configuration; 
@property (nonatomic,copy) NSDictionary * rolesToLayoutItemsMap;
+ (id)homeScreenAppLayout;
@end

static void killCamera()
{
	@try {
		SBMainSwitcherViewController* shrd = [%c(SBMainSwitcherViewController) sharedInstanceIfExists];
		for(SBAppLayout* appLayoutNow in [shrd appLayouts]) {
			if([[NSString stringWithFormat:@"%@", appLayoutNow] rangeOfString:@"com.apple.camera"].location != NSNotFound) {
				[shrd _quitAppsRepresentedByAppLayout:appLayoutNow forReason:1];
				break;
			}
		}
	} @catch(NSException* ex) {
	}
	system("exec killall Camera");
	NSLog(@"**** kill Camera");
}


static void screenChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	@try{
		BOOL isCamera = NO;
		SBApplication* nowApp = [[UIApplication sharedApplication] _accessibilityFrontMostApplication];
		if(nowApp&&[nowApp respondsToSelector:@selector(bundleIdentifier)]) {
			if([[nowApp bundleIdentifier]?:@"" isEqualToString:@"com.apple.camera"]) {
				isCamera = YES;
			}
		}
		if(!isCamera) {
			killCamera();
		}
	}@catch(NSException* ex) {
		NSLog(@"NSException: %@", ex);
	}
}

%ctor
{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &screenChanged, CFSTR("com.apple.springboard.screenchanged"), NULL, 0);
}