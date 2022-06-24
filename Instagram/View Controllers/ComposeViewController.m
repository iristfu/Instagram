//
//  ComposeViewController.m
//  Instagram
//
//  Created by Iris Fu on 6/24/22.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()
- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapShare:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *postCaption;
@property (weak, nonatomic) IBOutlet UIImageView *postImage;
- (IBAction)didTapImage:(id)sender;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)didTapShare:(id)sender {
}

- (IBAction)didTapCancel:(id)sender {
}

- (IBAction)cancelButton:(id)sender {
}
- (IBAction)didTapImage:(id)sender {
}
@end
