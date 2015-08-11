//
//  TargetViewController.h
//  cf
//
//  Created by DX197 on 8/11/15.
//  Copyright (c) 2015 Pivotal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIBarButtonItem *target;
@property (weak, nonatomic) IBOutlet UITextField *endpoint;
@property (weak, nonatomic) IBOutlet UISwitch *skipSSL;
@property (weak, nonatomic) IBOutlet UIView *SpinView;

- (IBAction)textChanged:(id)sender;
- (IBAction)target:(id)sender;

@end
