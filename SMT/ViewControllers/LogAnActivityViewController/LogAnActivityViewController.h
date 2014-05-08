//
//  LogAnActivityViewController.h
//  SMT
//
//  Created by Mac on 5/7/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogAnActivityViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarVerticalConstr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navigationBarHeightConstr;

- (IBAction)actPhotoLog:(id)sender;
- (IBAction)actTraditionalLog:(id)sender;
@end
