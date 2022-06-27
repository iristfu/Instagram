//
//  ProfileViewPostCell.m
//  Instagram
//
//  Created by Iris Fu on 6/26/22.
//

#import "ProfileViewPostCell.h"

@implementation ProfileViewPostCell

- (void)setPost:(Post *)post {
    _post = post;
    self.postImage.file = post[@"image"];
    [self.postImage loadInBackground];
}

@end
