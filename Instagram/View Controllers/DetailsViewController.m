//
//  DetailsViewController.m
//  Instagram
//
//  Created by Iris Fu on 6/26/22.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet PFImageView *postPicture;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (weak, nonatomic) IBOutlet UILabel *timeStamp;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.postCaption.text = self.post[@"caption"];
    self.username.text = self.post[@"author"][@"username"];
    self.postPicture.file = self.post[@"image"];
    [self.postPicture loadInBackground];
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width/2;
    if(self.post[@"author"][@"profilePicture"]) {
        self.profilePicture.file = self.post[@"author"][@"profilePicture"];
        [self.profilePicture loadInBackground];
    } else {
        UIImage *placeHolderImage = [UIImage imageNamed:@"image_placeholder"];
        [self.profilePicture setImage:placeHolderImage];
    }
    self.likeCount.text = [NSString stringWithFormat:@"%@ likes", self.post[@"likeCount"]];
    self.timeStamp.text = [self.post getTimeStamp];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
