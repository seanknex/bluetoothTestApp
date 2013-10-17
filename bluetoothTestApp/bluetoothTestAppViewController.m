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
@synthesize audioSession, player, playerURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
	//[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
	[audioSession setActive:YES error:nil];
	
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
		
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:playerURL error:nil];
		[player play];
		if ([player isPlaying]) {
			[transferOutlet setTitle:@"Stop" forState:UIControlStateNormal];
			activityView.hidden = FALSE;
			[activityView startAnimating];
			[self performSelector:@selector(resetView) withObject:nil afterDelay:[player duration]];
		}
		
	}
	
}

-(void)resetView{
	[player stop];
	[activityView stopAnimating];
	activityView.hidden = TRUE;
	[transferOutlet setTitle:@"Play" forState:UIControlStateNormal];
}

@end