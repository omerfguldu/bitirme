// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#import <Firebase/Firebase.h>

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLTTransactionStreamHandler : NSObject <FlutterStreamHandler>

- (instancetype)initWithId:(NSString *)transactionId
                   started:(void (^)(FIRTransaction *))startedListener
                     ended:(void (^)(void))endedListener;
- (void)receiveTransactionResponse:(NSDictionary *)response;

@end

NS_ASSUME_NONNULL_END
