//
//  User.m
//  twitter
//
//  Created by taylorka on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

// Initialize user based on dictionary of info
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.tagline = dictionary[@"description"];
        self.profilePicString = dictionary[@"profile_image_url_https"];
        self.headerPicString = dictionary[@"profile_banner_url"];
        self.numTweets = [dictionary[@"statuses_count"] intValue];
        self.numFollowers = [dictionary[@"followers_count"] intValue];
        self.numFollowing = [dictionary[@"friends_count"] intValue];
    }
    return self;
}

@end
