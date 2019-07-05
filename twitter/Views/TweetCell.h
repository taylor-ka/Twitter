//
//  TweetCell.h
//  twitter
//
//  Created by taylorka on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@protocol  TweetCellDelegate;

@interface TweetCell : UITableViewCell

// Delegate for profile pic tap
@property (weak, nonatomic) id<TweetCellDelegate> delegate;

// Tweet to be stored in this cell
@property (strong, nonatomic) Tweet *tweet;

// Populates cell with info of current tweet
- (void)setUpTweetCell;

@end

@protocol  TweetCellDelegate
- (void)tweetCell:(TweetCell *)tweetCell didTapProfileOf:(User *)user;
@end

NS_ASSUME_NONNULL_END
