//
//  ProfileViewController.m
//  Instagram
//
//  Created by Iris Fu on 6/24/22.
//

#import <UIKit/UIKit.h>
#import "ProfileViewController.h"
#import "ParseUI.h"
#import "Post.h"
#import "ProfileViewPostCell.h"
#import "Parse/Parse.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UICollectionView *userPostsCollectionView;
- (IBAction)didTapEditProfilePicture:(id)sender;
@property (strong, nonatomic) NSMutableArray *currentUserPosts;

@end

@implementation ProfileViewController

- (void)setCurrentUserInfo {
//    PFUser *currentUser = [PFUser currentUser];
    PFUser *currentUser = self.user;
    self.username.text = currentUser.username;
    
    NSLog(@"Setting current user info");
    if(currentUser[@"profilePicture"]) {
        self.profilePicture.file = currentUser[@"profilePicture"];
        [self.profilePicture loadInBackground];
    } else {
        UIImage *placeHolderImage = [UIImage imageNamed:@"image_placeholder"];
        [self.profilePicture setImage:placeHolderImage];
    }
}

- (void) getCurrentUserPosts {
    NSLog(@"getCurrentUserPosts called");
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    [postQuery whereKey:@"author" equalTo:self.user];
    postQuery.limit = 20;
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post*> *_Nullable posts, NSError * _Nullable error) {
        if (posts != nil) {
            NSLog(@"Got current user posts: %@", posts);
            
            for (PFObject *post in posts) {
                [self.currentUserPosts addObject:post];
                NSLog(@"Added to currentUserPosts for it to become: %@", self.currentUserPosts);
            }
            [self.userPostsCollectionView reloadData];
        } else {
            NSLog(@"There was an error getting the current user's posts: %@", error.localizedDescription);
        }
    }];
    [self.userPostsCollectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUserPosts = [[NSMutableArray alloc] init];
    self.userPostsCollectionView.delegate = self;
    self.userPostsCollectionView.dataSource = self;
    
    if (!self.user) {
        self.user = [PFUser currentUser];
    }
    NSLog(@"About to call setting up methods");
    [self getCurrentUserPosts];
    NSLog(@"Returning from getCurrentUserPosts");
    [self setCurrentUserInfo];
    NSLog(@"Returning from setCurrentUserInfo");
    
    
}

-(void)renderImagePicker {
    // set up image picker
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = true;
    
    // The Xcode simulator does not support taking pictures, so let's first check that the camera is indeed supported on the device before trying to present it.
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }

    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // Get the image captured by the UIImagePickerController
    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];

    if (editedImage) {
        [self.profilePicture setImage:editedImage];
    } else {
        [self.profilePicture setImage:originalImage];
    }
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        CGSize size = CGSizeMake(300, 300);
        UIImage *uploadImage = [self resizeImage:self.profilePicture.image withSize:size];
        currentUser[@"profilePicture"] = [Post getPFFileFromImage:uploadImage];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded) {
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSLog(@"Error changing profile picture");
            }
        }];
    }
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

 
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapEditProfilePicture:(id)sender {
    [self renderImagePicker];
}
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSLog(@"Beginning of collection view for index path");
    ProfileViewPostCell *cell = [self.userPostsCollectionView dequeueReusableCellWithReuseIdentifier:@"ProfileViewCell" forIndexPath:indexPath];
    Post *post = self.currentUserPosts[indexPath.row];
    cell.post = post;
    NSLog(@"Loading a profile view post cell");
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.currentUserPosts.count;
}

@end
