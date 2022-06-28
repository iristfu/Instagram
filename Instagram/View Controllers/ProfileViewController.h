//
//  ProfileViewController.h
//  Instagram
//
//  Created by Iris Fu on 6/24/22.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
