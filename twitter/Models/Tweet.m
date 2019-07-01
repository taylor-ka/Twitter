//
//  Tweet.m
//  twitter
//
//  Created by taylorka on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        // Check if retweet
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if (originalTweet != nil) { // is a retweet
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Use information from original tweet
            dictionary = originalTweet;
        }
        
        // Set up properties
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        // Set up user
        NSDictionary *userDict = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:userDict];
        
        // Create and format createdAtString
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        
        // Create and configure formatter
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        
        // Configure output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        
        // Convert Date to String
        self.createdAtString = [formatter stringFromDate:date];
        
    }
    
    return self;
}

+ (NSMutableArray*)tweetsWithArray:(NSArray *)tweetDicts {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *tDict in tweetDicts) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:tDict];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
