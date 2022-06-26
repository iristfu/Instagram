//
//  PostCell.h
//  Instagram
//
//  Created by Iris Fu on 6/24/22.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostCell : UITableViewCell

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (weak, nonatomic) IBOutlet UILabel *likesCount;

@end

NS_ASSUME_NONNULL_END
