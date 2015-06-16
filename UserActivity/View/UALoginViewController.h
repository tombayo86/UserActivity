//
//  UALoginViewController.h
//  UserActivity
//
//  Created by el mariachi on 16/06/15.
//  Copyright (c) 2015 bitelz. All rights reserved.
//

#import <ParseUI/ParseUI.h>

@interface UALoginViewController : PFLogInViewController

-(void)hideWithAnimationAndCompletion:(void (^)(void))completionBlock;
@end
