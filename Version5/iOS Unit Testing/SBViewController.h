//
//  SBViewController.h
//  iOS Unit Testing
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "SBAnimationManager.h"

@interface SBViewController : UIViewController<SBAnimationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ballImageView;
@property (weak, nonatomic) IBOutlet UIButton *verticalButton;
@property (weak, nonatomic) IBOutlet UIButton *horizontalButton;
@property (weak, nonatomic) IBOutlet UIButton *fourCornerButton;

@property (strong, nonatomic) SBAnimationManager *animationManager;

- (IBAction)onVerticalButtonPressed:(id)sender;
- (IBAction)onHorizontalButtonPressed:(id)sender;
- (IBAction)onFourCornerButtonPressed:(id)sender;
@end