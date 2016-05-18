//
//  RDQRCodeScanner.h
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/19/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class AVCaptureMetadataOutput;
@class RDCodeScannerView;

@protocol RDCodeScannerDelegate <NSObject>

- (void) codeScanned: (RDCodeScannerView *) object codeData: (NSString *) codeData;

@optional

- (void) cannotInitializeImageCapturing: (RDCodeScannerView *) object;

@end

@interface RDCodeScannerView: UIView <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableArray * AVMetadataObjectTypes;

- (void) startReading;
- (void) stopReading;

@end
