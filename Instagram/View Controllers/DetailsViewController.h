//
//  DetailsViewController.h
//  Instagram
//
//  Created by Iris Fu on 6/26/22.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
