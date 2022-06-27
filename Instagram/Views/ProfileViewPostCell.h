//
//  ProfileViewPostCell.h
//  Instagram
//
//  Created by Iris Fu on 6/26/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <ParseUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfileViewPostCell : UICollectionViewCell
@property (strong,nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;

@end

NS_ASSUME_NONNULL_END
