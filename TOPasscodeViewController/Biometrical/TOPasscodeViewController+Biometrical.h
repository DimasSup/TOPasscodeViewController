//
//  TOPasscodeViewController+Biomentrical.h
//  TOPasscodeViewControllerExample
//
//  Created by Dimas on 26.09.2018.
//  Copyright © 2018 Timothy Oliver. All rights reserved.
//

#import "TOPasscodeViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>


@interface TOPasscodeViewController (Biometrical)
@property(nonatomic,strong)LAContext* context;

-(BOOL)prepareBiometrical;
-(void)disableBiometrical;
@end
