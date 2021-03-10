#import "CatcherPlugin.h"
#if __has_include(<catcher/catcher-Swift.h>)
#import <catcher/catcher-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "catcher-Swift.h"
#endif

@implementation CatcherPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCatcherPlugin registerWithRegistrar:registrar];
}
@end
