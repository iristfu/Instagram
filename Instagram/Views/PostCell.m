//
//  PostCell.m
//  Instagram
//
//  Created by Iris Fu on 6/24/22.
//

#import "PostCell.h"

@implementation PostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    self.postCaption.text = post[@"caption"];
    self.username.text = post[@"author"][@"username"];
    self.postImage.file = post[@"image"];
    NSLog(@"Setting the post image file %@", post[@"image"]);
    [self.postImage loadInBackground];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
    if(post[@"author"][@"profilePicture"]) {
        self.profilePicture.file = post[@"author"][@"profilePicture"];
        [self.profilePicture loadInBackground];
    } else {
        UIImage *placeHolderImage = [UIImage imageNamed:@"image_placeholder"];
        [self.profilePicture setImage:placeHolderImage];
    }
    self.likesCount.text = [NSString stringWithFormat:@"%@ likes", post[@"likeCount"]];
    self.timeStamp.text = [self.post getTimeStamp];
}

@end
