//
//  bluetoothTestAppViewController.h
//  bluetoothTestApp
//
//  Created by Sean Brown on 10/15/13.
//  Copyright (c) 2013 Sound the Bell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AVFoundation/AVFoundation.h>

@interface bluetoothTestAppViewController : UIViewController{
	IBOutlet UIActivityIndicatorView *activityView;
	IBOutlet UIButton *transferOutlet;
}

- (IBAction)initiateTransfer:(id)sender;

@property (nonatomic, retain) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) NSURL	*playerURL;

@end
