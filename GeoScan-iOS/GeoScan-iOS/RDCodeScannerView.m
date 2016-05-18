//
//  RDQRCodeScanner.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/19/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "RDCodeScannerView.h"


@interface RDCodeScannerView ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@end
@implementation RDCodeScannerView

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.AVMetadataObjectTypes = [[NSMutableArray alloc] init];
        [self.AVMetadataObjectTypes addObject:AVMetadataObjectTypeQRCode];
        
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 2.0f;
        self.layer.cornerRadius = 15.0f;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

- (void) startReading
{
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input)
    {
        NSLog(@"%@", [error localizedDescription]);
        if([self.delegate respondsToSelector:@selector(cannotInitializeImageCapturing:)])
           {
               [self.delegate performSelector:@selector(cannotInitializeImageCapturing:) withObject:self];
           }
    }
    
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("codeScannerQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:self.AVMetadataObjectTypes];
    
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.bounds];
    [self.layer addSublayer:_videoPreviewLayer];
    
    [self.captureSession startRunning];
}

- (void) stopReading
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    [self.videoPreviewLayer removeFromSuperlayer];
}


#pragma mark - Capture metadata object delegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            if([self.delegate respondsToSelector: @selector(codeScanned:codeData:)])
            {
                [self.delegate performSelector:@selector(codeScanned:codeData:)
                                    withObject:self
                                    withObject:[metadataObj stringValue]];
            }
        }
    }
}

@end
