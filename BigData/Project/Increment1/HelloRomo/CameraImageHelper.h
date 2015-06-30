//
//  CameraImageHelper.h
//  HelloRomo
//
//  Created by kishore on 6/24/15.
//  Copyright (c) 2015 Romotive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol AVHelperDelegate;

@interface CameraImageHelper : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    AVCaptureSession *session;
    UIImage *image;
    AVCaptureVideoPreviewLayer *preview;
    AVCaptureStillImageOutput *captureOutput;
    UIImageOrientation g_orientation;
    
    id<AVHelperDelegate>delegate;
}
@property (retain) AVCaptureSession *session;
@property (retain) AVCaptureStillImageOutput *captureOutput;
@property (retain) UIImage *image;
@property (assign) UIImageOrientation g_orientation;
@property (assign) AVCaptureVideoPreviewLayer *preview;
@property (assign) id<AVHelperDelegate>delegate;

- (void) startRunning;
- (void) stopRunning;

-(void)setDelegate:(id<AVHelperDelegate>)_delegate;
-(void)CaptureStillImage;
- (void)embedPreviewInView: (UIView *) aView;
- (void)changePreviewOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end

@protocol AVHelperDelegate <NSObject>

-(void)didFinishedCapture:(UIImage*)_img;
-(void)foucusStatus:(BOOL)isadjusting;
@end
