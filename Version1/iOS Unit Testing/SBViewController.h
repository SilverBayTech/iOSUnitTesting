//
//  SBViewController.h
//  iOS Unit Testing
//
//  Created by Kevin Hunter on 2/16/13.
//  Copyright (c) 2013 Silver Bay Tech. All rights reserved.
//

@interface SBViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *ballImageView;
@property (weak, nonatomic) IBOutlet UIButton *verticalButton;
@property (weak, nonatomic) IBOutlet UIButton *horizontalButton;

- (IBAction)onVerticalButtonPressed:(id)sender;
- (IBAction)onHorizontalButtonPressed:(id)sender;
@end
