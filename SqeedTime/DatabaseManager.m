//
//  DatabaseManager.m
//  SqeedTime
//
//  Created by Antoine De Gieter on 30/11/14.
//  Copyright (c) 2014 Net Production Köbe & Co. All rights reserved.
//

#import "DatabaseManager.h"
#import "CacheHandler.h"
#import "AFNetworking.h"

@implementation DatabaseManager

static NSString *serverURL = @"http://sqtdbws.net-production.ch/";

# pragma mark - Log In

+ (void)loginRequest :(NSString *)username :(NSString *)password {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"loginRequestV1",
    @"username" : username
    };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSString *userId = [response valueForKey:@"id"];
          NSLog(@"Login request for user id: %@", userId);
          [[CacheHandler instance] setCurrentUserId:userId];
          [[CacheHandler instance] setCurrentUser:[[User alloc] init:userId]];
          [[CacheHandler instance] setTmpUser:[[User alloc] init:userId]];

          [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequestDidComplete"
                                                              object:nil];
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginRequestDidFail"
                                                              object:nil];
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }];
}

+ (void)login :(NSString *)username :(NSString *)password {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"login",
    @"username" : username,
    @"password" : password
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Login user %@", username);
          if (200 == [[response valueForKey:@"code"] integerValue]) {
            [[CacheHandler instance] setToken:[response valueForKey:@"token"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginDidComplete"
                                                                object:nil];
          } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginDidFail"
                                                                object:nil];
          }
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"Error: %@", error);
          [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginDidFail"
                                                              object:nil];
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }];
}

# pragma mark - Fetch data

+ (void)fetchUser :(User *)user {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{ @"function" : @"getUser", @"id" : [user userId] };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSString *username = [response valueForKey:@"username"];
          NSLog(@"Fetching user: %@", username);
          NSString *name = [response valueForKey:@"name"];
          NSString *forname = [response valueForKey:@"forname"];
          NSString *email = [response valueForKey:@"email"];
          NSString *phoneExt = [response valueForKey:@"phoneExt"];
          NSString *phone = [response valueForKey:@"phone"];
          NSString *salt = [response valueForKey:@"salt"];
          NSString *facebookUrl = [response valueForKey:@"facebookUrl"];

          [user set :username
                    :name
                    :forname
                    :email
                    :phoneExt
                    :phone
                    :salt
                    :facebookUrl];
          [[CacheHandler instance] setTmpUser:user];

          [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchUserDidComplete"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchUserDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)fetchMySqeeds :(User *)user {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"eventsByUser",
    @"id" : [user userId]
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Fetching my sqeeds for user: %@", [user username]);
          NSArray *tmp_sqeeds = response[@"result"];
          NSMutableArray *sqeeds = [[NSMutableArray alloc] init];
          Sqeed *tmp_sqeed;
          NSString *sqeedId;
          NSString *title;
          NSString *place;
          SqeedCategory *category;
          NSString *creatorFirstName;
          NSString *creatorName;
          NSString *peopleMin;
          NSString *peopleMax;
          NSDate *dateStart;
          NSDate *dateEnd;

          for (NSDictionary *sqeed in tmp_sqeeds) {
            sqeedId = sqeed[@"id"];
            title = sqeed[@"title"];
            place = sqeed[@"place"];
            category = [[SqeedCategory alloc] initWithId:sqeed[@"category_id"]];
            creatorFirstName = sqeed[@"creator_first_name"];
            creatorName = sqeed[@"creator_name"];
            peopleMin = sqeed[@"people_min"];
            peopleMax = sqeed[@"people_max"];

            if (![sqeed[@"datetime_start"] isKindOfClass:[NSNull class]])
              dateStart = [NSDate dateWithTimeIntervalSince1970:
                                      [sqeed[@"datetime_start"] doubleValue]];
            else
              dateStart = [NSDate dateWithTimeIntervalSince1970:0];
            if (![sqeed[@"datetime_end"] isKindOfClass:[NSNull class]])
              dateEnd = [NSDate dateWithTimeIntervalSince1970:
                                    [sqeed[@"datetime_end"] doubleValue]];
            else
              dateEnd = [NSDate dateWithTimeIntervalSince1970:0];

            tmp_sqeed = [[Sqeed alloc] init:sqeedId];
            [tmp_sqeed setHeaders:
                            title:
                            place:
                         category:
                 creatorFirstName:
                      creatorName:
                        peopleMin:
                        peopleMax:
                        dateStart:dateEnd];

            [sqeeds addObject:tmp_sqeed];
          }
          [user setMySqeeds:sqeeds];
          [[CacheHandler instance] setTmpUser:user];

          [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchSqeedsDidComplete"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchSqeedsDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)fetchDiscovered :(User *)user {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"discover",
    @"userId" : [user userId]
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Fetching discovered for user: %@", [user username]);
          NSArray *tmp_sqeeds = response[@"result"];
          NSMutableArray *sqeeds = [[NSMutableArray alloc] init];
          Sqeed *tmp_sqeed;
          NSString *sqeedId;
          NSString *title;
          NSString *place;
          SqeedCategory *category;
          NSString *creatorFirstName;
          NSString *creatorName;
          NSString *peopleMin;
          NSString *peopleMax;
          NSDate *dateStart;
          NSDate *dateEnd;

          for (NSDictionary *sqeed in tmp_sqeeds) {
            sqeedId = sqeed[@"id"];
            title = sqeed[@"title"];
            place = sqeed[@"place"];
            category = [[SqeedCategory alloc] initWithId:sqeed[@"category_id"]];
            creatorFirstName = sqeed[@"creator_first_name"];
            creatorName = sqeed[@"creator_name"];
            peopleMin = sqeed[@"people_min"];
            peopleMax = sqeed[@"people_max"];

            if (![sqeed[@"datetime_start"] isKindOfClass:[NSNull class]])
              dateStart = [NSDate dateWithTimeIntervalSince1970:
                                      [sqeed[@"datetime_start"] doubleValue]];
            else
              dateStart = [NSDate dateWithTimeIntervalSince1970:0];
            if (![sqeed[@"datetime_end"] isKindOfClass:[NSNull class]])
              dateEnd = [NSDate dateWithTimeIntervalSince1970:
                                    [sqeed[@"datetime_end"] doubleValue]];
            else
              dateEnd = [NSDate dateWithTimeIntervalSince1970:0];

            tmp_sqeed = [[Sqeed alloc] init:sqeedId];
            [tmp_sqeed setHeaders:
                            title:
                            place:
                         category:
                 creatorFirstName:
                      creatorName:
                        peopleMin:
                        peopleMax:
                        dateStart:dateEnd];

            [sqeeds addObject:tmp_sqeed];
          }
          [user setDiscovered:sqeeds];
          [[CacheHandler instance] setTmpUser:user];

          [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchSqeedsDidComplete"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchSqeedsDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)fetchDiscovered :(User *)user :(SqeedCategory *)category {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"discover",
    @"userId" : [user userId],
    @"categoryId" : [category categoryId]
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Fetching discovered for user: %@", [user username]);
          NSArray *tmp_sqeeds = response[@"result"];
          NSMutableArray *sqeeds = [[NSMutableArray alloc] init];
          Sqeed *tmp_sqeed;
          NSString *sqeedId;
          NSString *title;
          NSString *place;
          SqeedCategory *category;
          NSString *creatorFirstName;
          NSString *creatorName;
          NSString *peopleMin;
          NSString *peopleMax;
          NSDate *dateStart;
          NSDate *dateEnd;

          for (NSDictionary *sqeed in tmp_sqeeds) {
            sqeedId = sqeed[@"id"];
            title = sqeed[@"title"];
            place = sqeed[@"place"];
            category = [[SqeedCategory alloc] initWithId:sqeed[@"category_id"]];
            creatorFirstName = sqeed[@"creator_first_name"];
            creatorName = sqeed[@"creator_name"];
            peopleMin = sqeed[@"people_min"];
            peopleMax = sqeed[@"people_max"];

            if (![sqeed[@"datetime_start"] isKindOfClass:[NSNull class]])
              dateStart = [NSDate dateWithTimeIntervalSince1970:
                                      [sqeed[@"datetime_start"] doubleValue]];
            else
              dateStart = [NSDate dateWithTimeIntervalSince1970:0];
            if (![sqeed[@"datetime_end"] isKindOfClass:[NSNull class]])
              dateEnd = [NSDate dateWithTimeIntervalSince1970:
                                    [sqeed[@"datetime_end"] doubleValue]];
            else
              dateEnd = [NSDate dateWithTimeIntervalSince1970:0];

            tmp_sqeed = [[Sqeed alloc] init:sqeedId];
            [tmp_sqeed setHeaders:
                            title:
                            place:
                         category:
                 creatorFirstName:
                      creatorName:
                        peopleMin:
                        peopleMax:
                        dateStart:dateEnd];

            [sqeeds addObject:tmp_sqeed];
          }
          [user setDiscovered:sqeeds];
          [[CacheHandler instance] setTmpUser:user];

          [[NSNotificationCenter defaultCenter]
              postNotificationName:@"FetchSqeedsDidComplete"
                            object:nil];
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter]
              postNotificationName:@"FetchSqeedsDidFail"
                            object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)fetchFriends :(User *)user {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"listFriends",
    @"userId" : [user userId]
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Fetching friend list for user: %@", [user username]);
          NSArray *tmp_friends = response[@"list"];
          NSMutableArray *friends = [[NSMutableArray alloc] init];
          User *tmp_friend;
          NSString *friendId;

          for (NSDictionary *friend in tmp_friends) {
            friendId = friend[@"id"];
            tmp_friend = [[User alloc] init:friendId];
            [self fetchUser:tmp_friend];
            [friends addObject:tmp_friend];
          }
          [user setFriends:friends];
          [[CacheHandler instance] setTmpUser:user];

          [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchFriendsDidComplete"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter]
              postNotificationName:@"FetchFriendsDidFail"
                            object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)fetchFriendRequests :(User *)user {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"listFriendRequests",
    @"userId" : [user userId]
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Fetching friend requests for user: %@", [user username]);
          NSArray *tmp_friends = response[@"list"];
          NSMutableArray *friends = [[NSMutableArray alloc] init];
          User *tmp_friend;
          NSString *friendId;

          for (NSDictionary *friend in tmp_friends) {
            friendId = friend[@"id"];
            tmp_friend = [[User alloc] init:friendId];
            [self fetchUser:tmp_friend];
            [friends addObject:tmp_friend];
          }
          [user setFriendRequests:friends];
          [[CacheHandler instance] setTmpUser:user];

          [[NSNotificationCenter defaultCenter]
              postNotificationName:@"FetchFriendRequestsDidComplete"
                            object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter]
              postNotificationName:@"FetchFriendRequestsDidFail"
                            object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)fetchSqeed :(Sqeed *)sqeed :(NSIndexPath *)indexPath {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"getEvent",
    @"id" : [sqeed sqeedId]
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Fetching sqeed: %@", [sqeed title]);
          NSDictionary *result = [response valueForKey:@"result"];
          NSString *sqeedDescritpion = [result valueForKey:@"description"];

          NSArray *tmp_going =
              [NSArray arrayWithArray:[result objectForKey:@"going"]];
          NSArray *tmp_waiting =
              [NSArray arrayWithArray:[result objectForKey:@"waiting"]];

          NSMutableArray *going = [[NSMutableArray alloc] init];
          NSMutableArray *waiting = [[NSMutableArray alloc] init];
          User *tmp_user;

          for (NSDictionary *g in tmp_going) {
            tmp_user = [[User alloc] init:g[@"user_id"]];
            [tmp_user setName:g[@"name"]];
            [tmp_user setForname:g[@"forname"]];
            [going addObject:tmp_user];
          }

          for (NSDictionary *w in tmp_waiting) {
            tmp_user = [[User alloc] init:w[@"user_id"]];
            [tmp_user setName:w[@"name"]];
            [tmp_user setForname:w[@"forname"]];
            [waiting addObject:tmp_user];
          }
          [sqeed setDescription:sqeedDescritpion];
          [[CacheHandler instance] setTmpSqeed:sqeed];
          [[[CacheHandler instance] tmpSqeed] setGoing:going];
          [[[CacheHandler instance] tmpSqeed] setWaiting:waiting];
          
          [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchSqeedDidComplete"
                                                              object:nil
                                                            userInfo:[NSDictionary dictionaryWithObject:indexPath
                                                                                                 forKey:@"indexPath"]];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchSqeedDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)fetchCategories {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{ @"function" : @"getCategories" };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Fetching categories");
          SqeedCategory *tmp_cat;
          NSMutableArray *categories = [[NSMutableArray alloc] init];

          for (NSDictionary *category in response) {
            tmp_cat = [[SqeedCategory alloc] init];
            [tmp_cat setCategoryId:category[@"id"]];
            NSLog(@"%@", category[@"title"]);
            [tmp_cat setLabel:category[@"title"]];
            [categories addObject:tmp_cat];
          }
          [[CacheHandler instance] setCategories:categories];
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

# pragma mark - Action on Sqeeds

+ (void)participate :(NSString *)userId :(NSString *)sqeedId {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"participate",
    @"userId" : userId,
    @"sqeedId" : sqeedId
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Participate! (id = %@)", sqeedId);
          [[NSNotificationCenter defaultCenter] postNotificationName:@"ParticipateDidComplete"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"ParticipateDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)notParticipate :(NSString *)userId :(NSString *)sqeedId {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"notParticipate",
    @"userId" : userId,
    @"sqeedId" : sqeedId
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Not participate! (id = %@)", sqeedId);
          [[NSNotificationCenter defaultCenter] postNotificationName:@"NotParticipateDidComplete"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"NotParticipateDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)createSqeed :(NSString *)title
                    :(NSString *)place
                    :(User *)creator
                    :(NSString *)description
                    :(NSString *)peopleMax
                    :(NSString *)peopleMin
                    :(SqeedCategory *)category
                    :(NSDate *)datetimeStart
                    :(NSDate *)datetimeEnd
                    :(NSString *) privateAccess
                    :(NSArray *)friends {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function"         : @"addEvent",
                             @"title"            : title,
                             @"place"            : place,
                             @"creatorId"        : [creator userId],
                             @"description"      : description,
                             @"peopleMax"        : peopleMax,
                             @"peopleMin"        : peopleMin,
                             @"categoryId"       : [category categoryId],
                             @"private"          : privateAccess,
                             @"datetimeStart"    : [NSString stringWithFormat:@"%f",
                                                    [datetimeStart timeIntervalSince1970]],
                             @"datetimeEnd"      : [NSString stringWithFormat:@"%f",
                                                    [datetimeEnd timeIntervalSince1970]],
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSString *sqeedId = response[@"event"][@"id"];
              NSLog(@"Sqeed created! (id = %@)", sqeedId);
              [self invite:sqeedId:friends];
              [[CacheHandler instance] setCreateSqeed:[[Sqeed alloc] init]];
              [[CacheHandler instance] setTmpSqeed:[[Sqeed alloc] init:sqeedId]];
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateSqeedDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateSqeedDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void)deleteSqeed:(NSString *)sqeedId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function" : @"deleteEvent",
                             @"eventId" : sqeedId
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Deleted! (id = %@)", sqeedId);
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteSqeedDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteSqeedDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

# pragma mark - Action on users

+ (void)addFriend :(NSString *)userId :(NSString *)friendId {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"addFriend",
    @"user1Id" : userId,
    @"user2Id" : friendId
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Add friend! (id = %@)", friendId);
          
          [[NSNotificationCenter defaultCenter] postNotificationName:@"AddFriendDidComplete"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"AddFriendDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)deleteFriend :(NSString *)userId :(NSString *)friendId {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{
    @"function" : @"deleteFriend",
    @"user1Id"  : userId,
    @"user2Id"  : friendId
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Remove friend! (id = %@)", friendId);
          
          [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteFriendDidComplete"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteFriendDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)invite :(NSString *)sqeedId :(NSArray *)friendIds {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSError *error;
  NSData *dataFriendIds = [NSJSONSerialization dataWithJSONObject:friendIds
                                                          options:kNilOptions
                                                            error:&error];
  NSString *jsonFriendIds =
      [[NSString alloc] initWithData:dataFriendIds
                            encoding:NSUTF8StringEncoding];
  NSDictionary *params = @{
    @"function"     : @"invite",
    @"sqeedId"      : sqeedId,
    @"friendIds"    : jsonFriendIds
  };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {
          NSLog(@"Friends invited!");
          
          [[NSNotificationCenter defaultCenter] postNotificationName:@"InviteDidComplete"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"InviteDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}

+ (void)updateUser :(NSString *)userId
                   :(NSString *)email
                   :(NSString *)forname
                   :(NSString *)name
                   :(NSString *)phoneExt
                   :(NSString *)phone
                   :(NSString *)facebookUrl {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserDidComplete"
                                                        object:nil];
    
}

+ (void)searchUser :(NSString *)string {
  [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
  AFHTTPRequestOperationManager *manager =
      [AFHTTPRequestOperationManager manager];
  NSDictionary *params = @{ @"function" : @"search",
                            @"query"    : string };
  [manager POST:serverURL
      parameters:params
      success:^(AFHTTPRequestOperation *operation, id response) {

          NSArray *tmp_users = response[@"result"];
          NSMutableArray *users = [[NSMutableArray alloc] init];
          User *tmp_user;
          NSString *userId;

          for (NSDictionary *user in tmp_users) {
              userId = user[@"id"];
              tmp_user = [[User alloc] init:userId];
              [tmp_user setForname:user[@"forname"]];
              [tmp_user setName:user[@"name"]];
              [tmp_user setUsername:user[@"username"]];
              [users addObject:tmp_user];
          }
    
          [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchDidComplete"
                                                              object:nil
                                                            userInfo:[NSDictionary dictionaryWithObject:users
                                                                                                 forKey:@"users"]];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
      }
      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchDidFail"
                                                              object:nil];
          
          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          NSLog(@"Error: %@", error);
      }];
}
@end
