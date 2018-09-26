//
//  TOPasscodeViewController+Biometrical.m
//  TOPasscodeViewControllerExample
//
//  Created by Dimas on 26.09.2018.
//  Copyright © 2018 Timothy Oliver. All rights reserved.
//

#import "TOPasscodeViewController+Biometrical.h"
#import <objc/runtime.h>

@implementation TOPasscodeViewController(Biometrical)
static const char* TOPasscodeViewControllerBiometrical_Context = "TOPasscodeViewControllerBiometrical_Context";

-(void)setContext:(LAContext *)context{
	objc_setAssociatedObject(self, TOPasscodeViewControllerBiometrical_Context, context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(LAContext *)context{
	return objc_getAssociatedObject(self, TOPasscodeViewControllerBiometrical_Context);
}

#pragma mark -
-(void)swizzleMe{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		
		Method original, swizzled;
		
		original = class_getInstanceMethod(self.class, @selector(accessoryButtonTapped:));
		swizzled = class_getInstanceMethod(self.class, @selector(swizzled_accessoryButtonTapped:));
		method_exchangeImplementations(original, swizzled);
	});
}
-(BOOL)prepareBiometrical{
	
	LAContext* context = [[LAContext alloc] init];
	
	if([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]){
		[self swizzleMe];
		self.context = context;
		
		TOPasscodeBiometryType biomentryType = TOPasscodeBiometryTypeTouchID;
		
		if (@available(iOS 11.0, *)) {
			if(context.biometryType == LABiometryTypeFaceID){
				biomentryType = TOPasscodeBiometryTypeFaceID;
			}
		}
		
		self.allowBiometricValidation = YES;
		self.biometryType = biomentryType;
		self.automaticallyPromptForBiometricValidation = YES;
		return YES;
	}
	return NO;
}
- (void)disableBiometrical{
	if(self.context){
		self.context = nil;
		self.allowBiometricValidation = NO;
	}
}
-(void)swizzled_accessoryButtonTapped:(id)sender{
	if(self.context){
		if(sender == self.biometricButton){
			[self validateBiometrical];
		}
		else{
			[self swizzled_accessoryButtonTapped:sender];
		}
	}
	else{
		[self swizzled_accessoryButtonTapped:sender];
	}
}
-(void)validateBiometrical{
	__weak typeof(self) weakSelf = self;
	NSString *reason = @"Touch ID to continue using this app";
	id reply = ^(BOOL success, NSError *error) {
		
		dispatch_async(dispatch_get_main_queue(), ^{
			
		// Touch ID validation was successful
		// (Use this to dismiss the passcode controller and display the protected content)
		if (success) {
			[weakSelf completePasscode];
			return;
		}
		
		// Actual UI changes need to be made on the main queue
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf setContentHidden:NO animated:YES];
		});
		
		// The user hit 'Enter Password'. This should probably do nothing
		// but make sure the passcode controller is visible.
		if (error.code == kLAErrorUserFallback) {
			NSLog(@"User tapped 'Enter Password'");
			return;
		}
		
		// The user hit the 'Cancel' button in the Touch ID dialog.
		// At this point, you could either simply return the user to the passcode controller,
		// or dismiss the protected content and go back to a safer point in your app (Like the login page).
		if (error.code == LAErrorUserCancel) {
			NSLog(@"User tapped cancel.");
			return;
		}
		
		// There shouldn't be any other potential errors, but just in case
		NSLog(@"%@", error.localizedDescription);
			
		});
	};
	
	[self setContentHidden:YES animated:YES];
	
	[self.context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:reason reply:reply];
}
@end
