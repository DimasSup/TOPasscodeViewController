//
//  ViewController.m
//  TOPINViewControllerExample
//
//  Created by Tim Oliver on 5/15/17.
//  Copyright © 2017 Timothy Oliver. All rights reserved.
//

#import "ViewController.h"
#import "TOPasscodeViewController.h"
#import "TOPasscodeViewController+Biometrical.h"
#import "SettingsViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController () <TOPasscodeViewControllerDelegate>

@property (nonatomic, copy) NSString *passcode;
@property (nonatomic, assign) TOPasscodeViewStyle style;
@property (nonatomic, assign) TOPasscodeType type;

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIView *dimmingView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.passcode = @"1234";

    // Enable mipmaps so the rescaled image will look properly sampled
    self.imageView.layer.minificationFilter = kCAFilterTrilinear;

	
}

- (IBAction)showButtonTapped:(id)sender
{
	
	[TOPasscodeView appearance].titleText = @"Hello Passcode";
	
    TOPasscodeViewController *passcodeViewController = [[TOPasscodeViewController alloc] initWithStyle:self.style passcodeType:self.type];
    passcodeViewController.delegate = self;
	[passcodeViewController prepareBiometrical];

    [self presentViewController:passcodeViewController animated:YES completion:nil];
}

- (IBAction)settingsButtonTapped:(id)sender
{
    SettingsViewController *controller = [[SettingsViewController alloc] init];
    controller.passcode = self.passcode;
    controller.passcodeType = self.type;
    controller.style = self.style;
    controller.wallpaperImage = self.imageView.image;

    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];

    __weak typeof(self) weakSelf = self;
    __weak typeof(controller) weakController = controller;
    controller.doneButtonTappedHandler = ^{
        weakSelf.passcode = weakController.passcode;
        weakSelf.style = weakController.style;
        weakSelf.type = weakController.passcodeType;

        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };

    controller.wallpaperChangedHandler = ^(UIImage *image) {
        weakSelf.imageView.image = image;
    };
}

- (void)didTapCancelInPasscodeViewController:(TOPasscodeViewController *)passcodeViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)passcodeViewController:(TOPasscodeViewController *)passcodeViewController isCorrectCode:(NSString *)code
{
    return [code isEqualToString:self.passcode];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.presentedViewController) {
        return [self.presentedViewController preferredStatusBarStyle];
    }

    return UIStatusBarStyleLightContent;
}
@end
