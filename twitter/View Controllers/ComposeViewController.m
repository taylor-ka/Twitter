//
//  ComposeViewController.m
//  twitter
//
//  Created by taylorka on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *tweetButton;
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UILabel *characterCountLabel;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Text box border
    self.tweetTextView.layer.borderWidth = 1.5f;
    self.tweetTextView.layer.borderColor = [[UIColor colorNamed:@"tweeterBlue"] CGColor];
    self.tweetTextView.layer.cornerRadius = 5;
    
    // To control character count
    self.tweetTextView.delegate = self;
}

- (IBAction)onCloseClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)onTweetClick:(id)sender {
    NSString *tweetText = self.tweetTextView.text;
    [[APIManager shared] postStatusWithText:tweetText completion:^(Tweet *tweet, NSError *error) {
        if (error) {
            NSLog(@"Error composing Tweet: %@", error);
        } else {
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // Set max character limit
    int characterLimit = 280;
    
    // Construct what the new text would be if we allowed the user's latest edit
    NSString *newText = [self.tweetTextView.text stringByReplacingCharactersInRange:range withString:text];
    
    // Update character count label
    NSInteger charactersLeft = 280 - newText.length;
    self.characterCountLabel.text = [NSString stringWithFormat:@"%ld", charactersLeft];
    
    // Return if the edit should be allowed (fits in character limit)
    return newText.length < characterLimit;
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
