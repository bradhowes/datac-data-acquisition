// -*- Mode: ObjC -*-
//
// Copyright (C) 2011, Brad Howes. All rights reserved.
//

#import "UserSettings.h"

NSString* kSettingsInputDisplayUpdateRateKey = @"INPUT_DISPLAY_UPDATE_RATE";
NSString* kSettingsInputDisplayXMinKey = @"INPUT_DISPLAY_XMIN";
NSString* kSettingsInputDisplayXMaxKey = @"INPUT_DISPLAY_XMAX";

NSString* kSettingsDetectionsViewDurationKey = @"DETECTIONS_VIEW_DURATION";

NSString* kSettingsLevelDetectorLevelKey = @"LEVEL_DETECTOR_LEVEL";
NSString* kSettingsLevelDetectorUpdateRateKey = @"LEVEL_DETECTOR_UPDATE_RATE";
NSString* kSettingsLevelDetectorUseLowPassFilterKey = @"LEVEL_DETECTOR_USE_LOW_PASS_FILTER";
NSString* kSettingsLevelDetectorLowPassFilterFileNameKey = @"LEVEL_DETECTOR_LOW_PASS_FILTER_FILENAME";
NSString* kSettingsLevelDetectorCountsDecayDurationKey = @"LEVEL_DETECTOR_COUNTS_DECAY_DURATION";
NSString* kSettingsLevelDetectorScalingKey = @"LEVEL_DETECTOR_SCALING";

NSString* kSettingsBitDetectorMaxLowLevelKey = @"BIT_DETECTOR_MAX_LOW_LEVEL";
NSString* kSettingsBitDetectorMinHighLevelKey = @"BIT_DETECTOR_MIN_HIGH_LEVEL";
NSString* kSettingsBitDetectorSamplesPerPulseKey = @"BIT_DETECTOR_SAMPLES_PER_PULSE";

NSString* kSettingsBitStreamFrameDetectorPrefixKey = @"BIT_STREAM_FRAME_DETECTOR_PREFIX";
NSString* kSettingsBitStreamFrameDetectorSuffixKey = @"BIT_STREAM_FRAME_DETECTOR_SUFFIX";
NSString* kSettingsBitStreamFrameDetectorContentSizeKey = @"BIT_STREAM_FRAME_DETECTOR_CONTENT_SIZE";

NSString* kSettingsMicSwitchDetectorThresholdKey = @"MIC_SWITCH_DETECTOR_THRESHOLD";
NSString* kSettingsMicSwitchDetectorDurationKey = @"MIC_SWITCH_DETECTOR_DURATION";

NSString* kSettingsCloudStorageEnableKey = @"CLOUD_STORAGE_ENABLE";

NSString* kSettingsWaveCycleDetectorNonZeroLevelKey = @"nonZeroLevel";

@implementation UserSettings

+ (NSUserDefaults*)registerDefaults
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:

                                [NSNumber numberWithFloat:20.0], kSettingsInputDisplayUpdateRateKey,
                                [NSNumber numberWithFloat:0.0], kSettingsInputDisplayXMinKey,
                                [NSNumber numberWithFloat:1.0], kSettingsInputDisplayXMaxKey,

                                [NSNumber numberWithFloat:30.0], kSettingsDetectionsViewDurationKey,

                                [NSNumber numberWithFloat:0.3333], kSettingsLevelDetectorLevelKey,
                                [NSNumber numberWithFloat:4], kSettingsLevelDetectorUpdateRateKey,
                                [NSNumber numberWithBool:YES], kSettingsLevelDetectorUseLowPassFilterKey,
                                @"taps", kSettingsLevelDetectorLowPassFilterFileNameKey,
                                [NSNumber numberWithInt:4], kSettingsLevelDetectorCountsDecayDurationKey,
                                [NSNumber numberWithFloat:33.0], kSettingsLevelDetectorScalingKey,

                                [NSNumber numberWithFloat:0.33], kSettingsBitDetectorMaxLowLevelKey,
                                [NSNumber numberWithFloat:0.66], kSettingsBitDetectorMinHighLevelKey,
                                [NSNumber numberWithInt:37], kSettingsBitDetectorSamplesPerPulseKey,

                                @"0010101011", kSettingsBitStreamFrameDetectorPrefixKey,
                                @"0101010101", kSettingsBitStreamFrameDetectorSuffixKey,
                                [NSNumber numberWithInt:30], kSettingsBitStreamFrameDetectorContentSizeKey,
                                
                                [NSNumber numberWithFloat:0.0001], kSettingsMicSwitchDetectorThresholdKey,
                                [NSNumber numberWithFloat:0.5], kSettingsMicSwitchDetectorDurationKey,

                                [NSNumber numberWithBool:YES], kSettingsCloudStorageEnableKey,

                                [NSNumber numberWithFloat:0.33], kSettingsWaveCycleDetectorNonZeroLevelKey,
                                
                                nil]];
    return defaults;
}

+ (void)validateFloatNamed:(NSString*)key minValue:(Float32)minValue maxValue:(Float32)maxValue
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    Float32	value = [defaults floatForKey:key];
    if (value < minValue) {
	value = minValue;
    }
    else if	(value > maxValue) {
	value = maxValue;
    }
    [defaults setFloat:value forKey:key];
    NSLog(@"validateFloatNamed: %@ %f", key, value);
}

+ (void)validateIntegerNamed:(NSString*)key minValue:(SInt32)minValue maxValue:(SInt32)maxValue
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    SInt32	value = [defaults integerForKey:key];
    if (value < minValue) {
	value = minValue;
    }
    else if	(value > maxValue) {
	value = maxValue;
    }
    [defaults setInteger:value forKey:key];
    NSLog(@"validateIntegerNamed: %@ %f", key, value);
}

+ (NSUserDefaults*)validate
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [UserSettings validateFloatNamed:kSettingsInputDisplayUpdateRateKey minValue:1.0 maxValue:60.0];
    [UserSettings validateFloatNamed:kSettingsInputDisplayXMinKey minValue:0.0 maxValue:1.0];
    [UserSettings validateFloatNamed:kSettingsInputDisplayXMaxKey minValue:0.0 maxValue:1.0];

    [UserSettings validateFloatNamed:kSettingsLevelDetectorLevelKey minValue:0.0 maxValue:1.0];
    [UserSettings validateFloatNamed:kSettingsLevelDetectorScalingKey minValue:0.1 maxValue:10000.0];
    [UserSettings validateIntegerNamed:kSettingsLevelDetectorCountsDecayDurationKey minValue:0 maxValue:10];

    Float32 maxLowValue = [defaults floatForKey:kSettingsBitDetectorMaxLowLevelKey];
    if (maxLowValue < -0.99) maxLowValue = -0.99;

    Float32 minHighValue = [defaults floatForKey:kSettingsBitDetectorMinHighLevelKey];
    if (minHighValue > 0.99) minHighValue = 0.99;

    if (maxLowValue > minHighValue) maxLowValue = minHighValue;

    [defaults setFloat:maxLowValue forKey:kSettingsBitDetectorMaxLowLevelKey];
    [defaults setFloat:minHighValue forKey:kSettingsBitDetectorMinHighLevelKey];

    [defaults synchronize];

    return defaults;
}

@end