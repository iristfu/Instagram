//
//  HomeFeedViewController.m
//  Instagram
//
//  Created by Iris Fu on 6/19/22.
//

#import "HomeFeedViewController.h"
#import "AppDelegate.h"
#import "SceneDelegate.h"
#import "LoginViewController.h"
#import "Parse/Parse.h"
#import "Post.h"
#import "PostCell.h"

@interface HomeFeedViewController () <UITableViewDelegate, UITableViewDataSource>
- (IBAction)tappedLogout:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *homeFeedTableView;
@property (strong, nonatomic) NSMutableArray *postsOnFeed;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HomeFeedViewController

- (void)fetchPosts {
    NSLog(@"fetch post called");
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            [self.postsOnFeed removeAllObjects];
            for (PFObject *post in posts) {
                [self.postsOnFeed addObject:post];
            }
            [self.refreshControl endRefreshing];
            [self.homeFeedTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    [self.refreshControl endRefreshing];
    [self.homeFeedTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchPosts) forControlEvents:UIControlEventValueChanged];
    [self.homeFeedTableView insertSubview:self.refreshControl atIndex:0];
    
    self.homeFeedTableView.delegate = self;
    self.homeFeedTableView.dataSource = self;
    self.homeFeedTableView.rowHeight = UITableViewAutomaticDimension;

    [self fetchPosts];
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView {
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;

    if (scrollOffset + scrollViewHeight == scrollContentSizeHeight) { // at the bottom of the scrollview
        [self loadMorePosts];
    }
}

-(void)loadMorePosts{
    Post *lastPost = [self.postsOnFeed lastObject];
    
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query whereKey:@"createdAt" lessThan:lastPost[@"createdAt"]]; // get older posts
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    query.limit = 20;

    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *morePosts, NSError *error) {
        if (morePosts != nil) {
            for (PFObject *post in morePosts) {
                [self.postsOnFeed addObject:post];
            }
            [self.homeFeedTableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tappedLogout:(id)sender {
    // logout the user
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
    }];
    
    // return to login screen
    SceneDelegate *myDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeFeedViewController *homeFeedViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    myDelegate.window.rootViewController = homeFeedViewController;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Post *post = self.postsOnFeed[indexPath.row];
    PostCell *postCell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    postCell.post = post;
    
    postCell.postCaption.text = post[@"caption"];
    postCell.username.text = post[@"author"][@"username"];
    postCell.postImage.file = post[@"image"];
    [postCell.postImage loadInBackground];
    postCell.profilePicture.layer.cornerRadius = postCell.profilePicture.frame.size.width/2;
    if(post[@"author"][@"profilePicture"]) {
        postCell.profilePicture.file = post[@"author"][@"profilePicture"];
        [postCell.profilePicture loadInBackground];
    } else {
        UIImage *placeHolderImage = [UIImage imageNamed:@"image_placeholder"];
        [postCell.profilePicture setImage:placeHolderImage];
    }
    return postCell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsOnFeed.count;
}

@end
