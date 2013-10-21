//
//  bluetoothTestAppViewController.m
//  bluetoothTestApp
//
//  Created by Sean Brown on 10/15/13.
//  Copyright (c) 2013 Sound the Bell. All rights reserved.
//

#import "bluetoothTestAppViewController.h"

@interface bluetoothTestAppViewController ()

@end

@implementation bluetoothTestAppViewController
@synthesize audioSession, player, playerURL, recorder;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	NSError *error;
	
	audioSession = [AVAudioSession sharedInstance];
	//[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&error];
	if (error) NSLog(@"Error in Setting Audio Session Category");
	[audioSession setActive:YES error:nil];
	if (error) NSLog(@"Error in Setting Audio Session Active");
	activityView.hidden = TRUE;
	NSString *playerString = [[NSBundle mainBundle]pathForResource:@"Breathing" ofType:@"mp3"];
	playerURL = [NSURL fileURLWithPath:playerString];
	 
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)initiateTransfer:(id)sender {
	if ([player isPlaying]) {
		[transferOutlet setTitle:@"Play" forState:UIControlStateNormal];
		[player stop];
		[activityView stopAnimating];
		activityView.hidden = TRUE;
	}
	else{
		[audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"VoiceFile"]]] error:nil];
		if (player.duration < 1) {
			player = [[AVAudioPlayer alloc] initWithContentsOfURL:playerURL error:nil];
		}
		
		[player play];
		if ([player isPlaying]) {
			[transferOutlet setTitle:@"Stop" forState:UIControlStateNormal];
			activityView.hidden = FALSE;
			[activityView startAnimating];
			[self performSelector:@selector(resetView) withObject:nil afterDelay:[player duration]];
		}
		
	}
	
}

- (IBAction)record:(id)sender {
	
	if (![recorder isRecording]) {
		NSError *error = [[NSError alloc] init];
		for (AVAudioSessionPortDescription *mDes in audioSession.availableInputs){
			if ([mDes.portType isEqualToString:AVAudioSessionPortBluetoothA2DP] || [mDes.portType isEqualToString:AVAudioSessionPortBluetoothHFP]) {
				[audioSession setPreferredInput:mDes error:&error];
			}
		}
		
		recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"VoiceFile"]]] settings:nil error:nil];
		[recorder setDelegate:self];
		[recorder prepareToRecord];
		[recorder record];
		activityView.hidden = FALSE;
		[activityView startAnimating];
		[recordOutlet setTitle:@"Stop" forState:UIControlStateNormal];
	}
	else{
		[recorder stop];
		activityView.hidden = TRUE;
		[activityView stopAnimating];
		[recordOutlet setTitle:@"Record" forState:UIControlStateNormal];
	}
	
}

-(void)resetView{
	[player stop];
	
	[activityView stopAnimating];
	activityView.hidden = TRUE;
	[transferOutlet setTitle:@"Play" forState:UIControlStateNormal];
}

@end