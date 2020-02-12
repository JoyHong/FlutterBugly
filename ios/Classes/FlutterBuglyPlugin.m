#import "FlutterBuglyPlugin.h"
#import <Bugly/Bugly.h>

@implementation FlutterBuglyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
    methodChannelWithName:@"flutter_bugly"
binaryMessenger:[registrar messenger]];
  FlutterBuglyPlugin* instance = [[FlutterBuglyPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"initBugly" isEqualToString:call.method]) {
    NSString *appId = call.arguments[@"appId"];
    NSString *channel = call.arguments[@"channel"];
    NSString *version = call.arguments[@"version"];
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.reportLogLevel = BuglyLogLevelInfo;
    config.channel = channel;
    config.version = version;
    [Bugly startWithAppId:appId config:config];
    result(nil);
  } else if ([@"setUserId" isEqualToString:call.method]) {
    NSString *userId = call.arguments[@"userId"];
    [Bugly setUserIdentifier:userId];
    result(nil);
  } else if ([@"postCatchedException" isEqualToString:call.method]) {
    NSString *detail = call.arguments[@"detail"];
    NSString *message = call.arguments[@"message"];
    if ([detail isKindOfClass:[NSNull class]]) {
      message = @"";
    }
    NSArray *stackTraceArray = [detail componentsSeparatedByString:@""];
    NSDictionary *data = call.arguments[@"data"];
    if (data == nil) {
      data = [NSMutableDictionary dictionary];
    }
    [Bugly reportExceptionWithCategory:5 name:message reason:@" " callStack:stackTraceArray extraInfo:data terminateApp:NO];
        result(nil);
    } else if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else {
      result(FlutterMethodNotImplemented);
    }
}

@end
