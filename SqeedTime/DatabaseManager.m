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
#import "VoteOption.h"
#import "Message.h"
#import "AlertHelper.h"

@implementation DatabaseManager

static NSString *serverURL = @"http://sqtdbws.net-production.ch/";

# pragma mark - Log In

+ (void)login :(NSString *)username :(NSString *)password {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function"    : @"login",
                             @"username"    : username,
                             @"password"    : password,
                             @"deviceId"    : [[CacheHandler instance] pn_token],
                             @"connector"   : @1
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Login user %@", username);
              if (200 == [[response valueForKey:@"code"] integerValue]) {
                  [[CacheHandler instance] setToken:[response valueForKey:@"token"]];
                  NSLog(@"Token: %@", [[CacheHandler instance] token]);
                  [[CacheHandler instance] setCurrentUserId:[[[CacheHandler instance] token] componentsSeparatedByString:@":"][0]];
                  [[[CacheHandler instance] currentUser] setUserId:[[CacheHandler instance] currentUserId]];
                  
                  // Store data locally
                  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                  NSString *session = @"on";
                  NSString *userId = [[CacheHandler instance] currentUserId];
                  NSString *token = [[CacheHandler instance] token];
                  [prefs setObject:session forKey:@"session"];
                  [prefs setObject:userId forKey:@"userId"];
                  [prefs setObject:token forKey:@"token"];
                  
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
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }];
}

# pragma mark - Fetch data

+ (void)fetchUser {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{
                             @"function"  : @"getUser",
                             @"token"     : [[CacheHandler instance] token]
                             };
    
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSString *username = [response valueForKey:@"username"];
              NSLog(@"Fetching user: %@", username);
              NSString *name = [response valueForKey:@"name"];
              NSString *email = [response valueForKey:@"email"];
              NSString *phoneExt = [response valueForKey:@"phoneExt"];
              NSString *phone = [response valueForKey:@"phone"];
              NSString *salt = [response valueForKey:@"salt"];
              NSString *facebookUrl = [response valueForKey:@"facebookUrl"];
              
              User *user = [[User alloc] init];
              [user setUserId:[[[CacheHandler instance] token] substringToIndex:1]];
              [user set :username
                        :name
                        :email
                        :phoneExt
                        :phone
                        :salt
                        :facebookUrl];
              [[CacheHandler instance] setCurrentUser:user];
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchUserDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchUserDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error fetch user: %@", error);
          }];
}

+ (void)fetchUser :(User *)user {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    NSDictionary *params = @{
                             @"function"  : @"getUser",
                             @"token"     : [[CacheHandler instance] token],
                             @"id"        : [user userId]
                             };
    
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSString *username = [response valueForKey:@"username"];
              NSLog(@"Fetching user: %@", [user userId]);
              NSString *name = [response valueForKey:@"name"];
              NSString *email = [response valueForKey:@"email"];
              NSString *phoneExt = [response valueForKey:@"phoneExt"];
              NSString *phone = [response valueForKey:@"phone"];
              NSString *salt = [response valueForKey:@"salt"];
              NSString *facebookUrl = [response valueForKey:@"facebookUrl"];
              
              [user set :username
                        :name
                        :email
                        :phoneExt
                        :phone
                        :salt
                        :facebookUrl];
              [[CacheHandler instance] setTmpUser:user];
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchFriendDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchFriendDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error fetch user: %@", error);
          }];
}

+ (void)fetchMySqeeds {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function" : @"eventsByUser",
                             @"token" : [[CacheHandler instance] token]
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Fetching my sqeeds");
              NSArray *tmp_sqeeds = response[@"result"];
              NSLog(@"%@", tmp_sqeeds);
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
              NSString *goingCount;
              NSString *waitingCount;
              NSDate *dateStart;
              NSDate *dateEnd;
              BOOL hasJoined;
              NSString *private;
              
              for (NSDictionary *sqeed in tmp_sqeeds) {
                  sqeedId = sqeed[@"id"];
                  title = sqeed[@"title"];
                  place = sqeed[@"place"];
                  category = [[SqeedCategory alloc] initWithId:sqeed[@"category_id"]];
                  creatorFirstName = sqeed[@"creator_first_name"];
                  creatorName = sqeed[@"creator_name"];
                  peopleMin = sqeed[@"people_min"];
                  peopleMax = sqeed[@"people_max"];
                  
                  hasJoined = [sqeed[@"hasJoined"] isEqualToString:@"true"];
                  private = sqeed[@"private"];
                  
                  goingCount = sqeed[@"going"];
                  waitingCount = sqeed[@"waiting"];
                  
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
                              peopleMax:
                              dateStart:dateEnd];
                  
                  [tmp_sqeed setGoingCount:goingCount];
                  [tmp_sqeed setWaitingCount:waitingCount];
                  [tmp_sqeed setHasJoined:hasJoined];
                  [tmp_sqeed setPrivateAccess:private];
                  
                  
                  [sqeeds addObject:tmp_sqeed];
              }
              [[[CacheHandler instance] currentUser] setMySqeeds:sqeeds];
              
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

+ (void)fetchDiscovered {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"  : @"discover",
                             @"token"     : [[CacheHandler instance] token]
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSArray *tmp_sqeeds;
              if ([response[@"result"] isKindOfClass:[NSNull class]])
                  tmp_sqeeds = [[NSArray alloc] init];
              else
                  tmp_sqeeds = response[@"result"];
              NSLog(@"Fetching discovered");
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
              NSString *goingCount;
              NSString *waitingCount;
              NSDate *dateStart;
              NSDate *dateEnd;
              BOOL hasJoined;
              
              for (NSDictionary *sqeed in tmp_sqeeds) {
                  sqeedId = sqeed[@"id"];
                  title = sqeed[@"title"];
                  place = sqeed[@"place"];
                  category = [[SqeedCategory alloc] initWithId:sqeed[@"category_id"]];
                  creatorFirstName = sqeed[@"creator_first_name"];
                  creatorName = sqeed[@"creator_name"];
                  peopleMin = sqeed[@"people_min"];
                  peopleMax = sqeed[@"people_max"];
                  hasJoined = [sqeed[@"hasJoined"] isEqualToString:@"true"];
                  
                  goingCount = sqeed[@"going"];
                  waitingCount = sqeed[@"waiting"];
                  
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
                              peopleMax:
                              dateStart:dateEnd];
                  
                  [tmp_sqeed setGoingCount:goingCount];
                  [tmp_sqeed setWaitingCount:waitingCount];
                  [tmp_sqeed setHasJoined:hasJoined];
                  
                  [sqeeds addObject:tmp_sqeed];
              }
              [[[CacheHandler instance] currentUser] setDiscovered:sqeeds];
              
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

+ (void)fetchDiscovered :(NSString *)categoryId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"      : @"discover",
                             @"token"         : [[CacheHandler instance] token],
                             @"categoryId"    : categoryId
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Fetching discovered (%@)", categoryId);
              NSArray *tmp_sqeeds = response[@"result"];
              if ([response[@"result"] isKindOfClass:[NSNull class]])
                  tmp_sqeeds = [[NSArray alloc] init];
              else
                  tmp_sqeeds = response[@"result"];
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
              NSString *goingCount;
              NSString *waitingCount;
              NSDate *dateStart;
              NSDate *dateEnd;
              BOOL hasJoined;
              
              for (NSDictionary *sqeed in tmp_sqeeds) {
                  sqeedId = sqeed[@"id"];
                  title = sqeed[@"title"];
                  place = sqeed[@"place"];
                  category = [[SqeedCategory alloc] initWithId:sqeed[@"category_id"]];
                  creatorFirstName = sqeed[@"creator_first_name"];
                  creatorName = sqeed[@"creator_name"];
                  peopleMin = sqeed[@"people_min"];
                  peopleMax = sqeed[@"people_max"];
                  
                  hasJoined = [sqeed[@"hasJoined"] isEqualToString:@"true"];
                  
                  goingCount = sqeed[@"going"];
                  waitingCount = sqeed[@"waiting"];
                  
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
                              peopleMax:
                              dateStart:dateEnd];
                  
                  [tmp_sqeed setGoingCount:goingCount];
                  [tmp_sqeed setWaitingCount:waitingCount];
                  [tmp_sqeed setHasJoined:hasJoined];
                  
                  [sqeeds addObject:tmp_sqeed];
              }
              [[[CacheHandler instance] currentUser] setDiscovered:sqeeds];
              
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

+ (void)fetchFriends {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"  : @"friends",
                             @"token"     : [[CacheHandler instance] token]
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Fetching friends");
              NSArray *tmp_friends = response[@"friends"];
              NSMutableArray *friends = [[NSMutableArray alloc] init];
              NSMutableArray *pending = [[NSMutableArray alloc] init];
              NSMutableArray *requests = [[NSMutableArray alloc] init];
              
              User *tmp_friend;
              NSString *friendId;
              NSString *state;
              
              for (NSDictionary *friend in tmp_friends) {
                  friendId = friend[@"userId"];
                  state = friend[@"state"];
                  
                  tmp_friend = [[User alloc] init:friendId];
                  [self fetchUser:tmp_friend];
                  
                  if ([state integerValue] == 0) {
                      [pending addObject:tmp_friend];
                  } else if ([state integerValue] == 1) {
                      [requests addObject:tmp_friend];
                  } else if ([state integerValue] == 3) {
                      [friends addObject:tmp_friend];
                  }
              }
              
              [[[CacheHandler instance] currentUser] setFriends:friends];
              [[[CacheHandler instance] currentUser] setRequests:requests];
              [[[CacheHandler instance] currentUser] setPending:pending];
              
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

+ (void)fetchSqeed :(Sqeed *)sqeed :(NSIndexPath *)indexPath {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"  : @"getEvent",
                             @"token"     : [[CacheHandler instance] token],
                             @"id"        : [sqeed sqeedId]
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Fetching sqeed: %@", [sqeed title]);
              NSDictionary *result = [response valueForKey:@"result"];
              NSLog(@"%@", result);
              NSString *sqeedDescritpion = [result valueForKey:@"description"];
              
              NSArray *tmp_going =
              [NSArray arrayWithArray:[result objectForKey:@"going"]];
              NSArray *tmp_waiting =
              [NSArray arrayWithArray:[result objectForKey:@"waiting"]];
              NSArray *tmp_options =
              [NSArray arrayWithArray:[result objectForKey:@"datetime_options"]];
              
              NSMutableArray *going = [[NSMutableArray alloc] init];
              NSMutableArray *waiting = [[NSMutableArray alloc] init];
              NSMutableArray *options = [[NSMutableArray alloc] init];
              NSMutableArray *voteIds = [[NSMutableArray alloc] init];
              User *tmp_user;
              VoteOption *tmp_option;
              
              for (NSDictionary *g in tmp_going) {
                  tmp_user = [[User alloc] init:g[@"user_id"]];
                  [tmp_user setName:g[@"name"]];
                  [going addObject:tmp_user];
              }
              
              for (NSDictionary *w in tmp_waiting) {
                  tmp_user = [[User alloc] init:w[@"user_id"]];
                  [tmp_user setName:w[@"name"]];
                  [waiting addObject:tmp_user];
              }
              
              for (NSDictionary *o in tmp_options) {
                  tmp_option = [[VoteOption alloc] init
                                :o[@"id"]
                                :[NSDate dateWithTimeIntervalSince1970 :[o[@"datetime_start"] doubleValue]]
                                :[NSDate dateWithTimeIntervalSince1970 :[o[@"datetime_start"] doubleValue]]
                                :o[@"voteCount"]];

                  [options addObject:tmp_option];
              }
              [sqeed setDescription:sqeedDescritpion];
              [[CacheHandler instance] setTmpSqeed:sqeed];
              
              VoteOption *option;
              
              for (NSDictionary *datetime_option_id in (NSArray *)result[@"voteId"]) {
                  option = [[VoteOption alloc] init];
                  [option setVoteId:datetime_option_id[@"datetime_option_id"]];
                  [voteIds addObject:option];
              }
              
              [[[CacheHandler instance] tmpSqeed] setVoteIds:voteIds];
              [[[CacheHandler instance] tmpSqeed] setGoing:going];
              [[[CacheHandler instance] tmpSqeed] setWaiting:waiting];
              [[[CacheHandler instance] tmpSqeed] setDateOptions:options];
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchSqeedDidComplete"
                                                                  object:nil
                                                                userInfo:[NSDictionary dictionaryWithObject:indexPath
                                                                                                     forKey:@"indexPath"]];
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"WillDisplayChat"
                                                                  object:nil];
              
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
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{ @"function" : @"getCategories" };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Fetch categories!");
              SqeedCategory *tmp_cat;
              NSMutableArray *categories = [[NSMutableArray alloc] init];
              
              for (NSDictionary *category in response) {
                  tmp_cat = [[SqeedCategory alloc] init];
                  [tmp_cat setCategoryId:category[@"id"]];
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

+ (void)participate :(NSString *)sqeedId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"  : @"participate",
                             @"token"     : [[CacheHandler instance] token],
                             @"sqeedId"   : sqeedId
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

+ (void)notParticipate :(NSString *)sqeedId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"  : @"notParticipate",
                             @"token"     : [[CacheHandler instance] token],
                             @"sqeedId"   : sqeedId
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
                    :(NSString *)description
                    :(NSString *)peopleMax
                    :(SqeedCategory *)category
                    :(NSDate *)datetimeStart
                    :(NSDate *)datetimeEnd
                    :(NSString *) privateAccess {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"        : @"addEvent",
                             @"token"           : [[CacheHandler instance] token],
                             @"title"           : title,
                             @"place"           : place,
                             @"creatorId"       : [[CacheHandler instance] currentUserId],
                             @"description"     : description,
                             @"peopleMax"       : peopleMax,
                             @"peopleMin"       : @"1",
                             @"categoryId"      : [category categoryId],
                             @"private"         : privateAccess,
                             @"datetimeStart"   : [NSString stringWithFormat:@"%f",
                                                   [datetimeStart timeIntervalSince1970]],
                             @"datetimeEnd"     : [NSString stringWithFormat:@"%f",
                                                   [datetimeEnd timeIntervalSince1970]],
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSString *sqeedId = response[@"event"][@"id"];
              NSLog(@"Sqeed created! (id = %@)", sqeedId);
              
              [[[CacheHandler instance] createSqeed] setSqeedId:sqeedId];
              [[CacheHandler instance] setLastInsertSqeedId:sqeedId];
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateSqeedDidComplete"
                                                                  object:nil
                                                                userInfo:@{@"index":@"0"}];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"CreateSqeedDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void)addDatetimeOption :(NSString *)sqeedId :(VoteOption *)voteOption :(int)index {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"        : @"addDatetimeOption",
                             @"token"           : [[CacheHandler instance] token],
                             @"sqeedId"         : sqeedId,
                             @"datetimeStart"   : [NSString stringWithFormat:@"%f",
                                                   [[voteOption datetimeStart] timeIntervalSince1970]],
                             @"datetimeEnd"     : [NSString stringWithFormat:@"%f",
                                                   [[voteOption datetimeEnd] timeIntervalSince1970]],
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Add datetime option! (%d)", index);
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDatetimeOptionDidComplete"
                                                                  object:nil
                                                                userInfo:@{@"index":[NSString stringWithFormat:@"%d", index + 1]}];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDatetimeOptionDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}



+ (void)deleteDatetimeOption :(NSString *)sqeedId :(NSString *)optionId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"        : @"deleteDatetimeOption",
                             @"token"           : [[CacheHandler instance] token],
                             @"optionId"         : optionId
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Add datetime option!");
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDatetimeOptionDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDatetimeOptionDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void)vote :(NSString *)sqeedId :(NSString *)optionId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"        : @"vote",
                             @"token"           : [[CacheHandler instance] token],
                             @"sqeedId"         : sqeedId,
                             @"optionId"        : optionId
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Vote!");
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"VoteDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"VoteDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void)deleteSqeed :(NSString *)sqeedId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"    : @"deleteEvent",
                             @"token"       : [[CacheHandler instance] token],
                             @"eventId"     : sqeedId
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

+ (void)addFriend :(NSString *)friendId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function" : @"addFriend",
                             @"token"     : [[CacheHandler instance] token],
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

+ (void)deleteFriend :(NSString *)friendId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"  : @"deleteFriend",
                             @"token"     : [[CacheHandler instance] token],
                             @"user2Id"   : friendId
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
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSError *error;
    NSData *dataFriendIds = [NSJSONSerialization dataWithJSONObject:friendIds
                                                            options:kNilOptions
                                                              error:&error];
    NSString *jsonFriendIds =
    [[NSString alloc] initWithData:dataFriendIds
                          encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{
                             @"function"      : @"invite",
                             @"token"         : [[CacheHandler instance] token],
                             @"sqeedId"       : sqeedId,
                             @"friendIds"     : jsonFriendIds
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

+ (void)updateUser :(NSString *)email
                   :(NSString *)name
                   :(NSString *)phoneExt
                   :(NSString *)phone
                   :(NSString *)facebookUrl {
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{
                             @"function"    : @"updateUser",
                             @"token"       : [[CacheHandler instance] token],
                             @"email"       : email,
                             @"name"        : name,
                             @"phoneExt"    : phoneExt,
                             @"phone"       : phone,
                             @"facebookUrl" : facebookUrl
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"User updated!");
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateUserDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void) getGroups {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{ @"function"   : @"getGroups",
                              @"token"      : [[CacheHandler instance] token]
                              };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Get groups");
              
              NSLog(@"%@", response);
              
              // TODO
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGroupsDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"GetGroupsDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void) addGroup:(NSString *)title :(NSArray *)friendIds {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    
    NSError *error;
    NSData *dataFriendIds = [NSJSONSerialization dataWithJSONObject:friendIds
                                                            options:kNilOptions
                                                              error:&error];
    NSString *jsonFriendIds =
    [[NSString alloc] initWithData:dataFriendIds
                          encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{ @"function"   : @"addGroup",
                              @"token"      : [[CacheHandler instance] token],
                              @"title"      : title,
                              @"userIds"    : jsonFriendIds
                              };
    
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Add group");
              
              // TODO
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"AddGroupDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"AddGroupDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void) updateGroup:(NSString *)groupId :(NSArray *)friendIds {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    
    NSError *error;
    NSData *dataFriendIds = [NSJSONSerialization dataWithJSONObject:friendIds
                                                            options:kNilOptions
                                                              error:&error];
    NSString *jsonFriendIds =
    [[NSString alloc] initWithData:dataFriendIds
                          encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{ @"function"   : @"updateGroup",
                              @"token"      : [[CacheHandler instance] token],
                              @"groupId"    : groupId,
                              @"userIds"           : jsonFriendIds
                              };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Update group");
              
              // TODO
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateGroupDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void) delGroup:(NSString *)groupId :(NSArray *)friendIds {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    
    NSError *error;
    NSData *dataFriendIds = [NSJSONSerialization dataWithJSONObject:friendIds
                                                            options:kNilOptions
                                                              error:&error];
    NSString *jsonFriendIds =
    [[NSString alloc] initWithData:dataFriendIds
                          encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{ @"function"   : @"delGroup",
                              @"token"      : [[CacheHandler instance] token],
                              @"groupId"    : groupId,
                              @"userIds"        : jsonFriendIds
                              };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Del group");
              
              // TODO
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"DelGroupDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"DelGroupDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void) addToGroup:(NSString *)groupId :(NSArray *)friendIds {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    
    NSError *error;
    NSData *dataFriendIds = [NSJSONSerialization dataWithJSONObject:friendIds
                                                            options:kNilOptions
                                                              error:&error];
    NSString *jsonFriendIds =
    [[NSString alloc] initWithData:dataFriendIds
                          encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = @{ @"function"   : @"getGroups",
                              @"token"      : [[CacheHandler instance] token],
                              @"groupId"    : groupId,
                              @"userIds"    : jsonFriendIds
                              };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Add to group");
              
              // TODO
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToGroupDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"AddToGroupDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void)searchUser :(NSString *)string {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{ @"function"   : @"search",
                              @"token"      : [[CacheHandler instance] token],
                              @"query"      : string
                              };
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

+ (void)searchByPhones :(NSArray *)phoneArray {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSError *error;
    NSData *dataPhoneArray = [NSJSONSerialization dataWithJSONObject:phoneArray
                                                            options:kNilOptions
                                                              error:&error];
    NSString *jsonPhoneArray =
    [[NSString alloc] initWithData:dataPhoneArray
                          encoding:NSUTF8StringEncoding];
    NSDictionary *params = @{
                             @"function"      : @"searchByPhones",
                             @"token"         : [[CacheHandler instance] token],
                             @"phones"        : jsonPhoneArray
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Search by phones!");
              
              User *tmp_phoneMatch;
              NSMutableArray *phoneMatches = [[NSMutableArray alloc] init];
              
              for (NSDictionary *match in response[@"result"]) {
                  tmp_phoneMatch = [[User alloc] init];
                  [tmp_phoneMatch setName:match[@"name"]];
                  [tmp_phoneMatch setUserId:match[@"userId"]];
                  [phoneMatches addObject:tmp_phoneMatch];
              }
              [[CacheHandler instance] setPhoneMatches:phoneMatches];
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchByPhonesDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchByPhonesDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}


+ (void)postMessage :(NSString *)sqeedId :(NSString *)message {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{ @"function"       : @"postMessage",
                              @"token"          : [[CacheHandler instance] token],
                              @"sqeedId"        : sqeedId,
                              @"message"        : message
                              };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Posted \"%@\"", message);
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"PostMessageDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"PostMessageDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void)fetchMessages :(NSString *)sqeedId {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{ @"function"       : @"listMessages",
                              @"token"          : [[CacheHandler instance] token],
                              @"sqeedId"        : sqeedId
                              };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Fetching messages");
              if (204 == [response[@"exception"][@"code"] integerValue]) {
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"NoMessage"
                                    object:nil];
              } else if (400 == [response[@"exception"][@"code"] integerValue]) {
                  NSLog(@"%@", response[@"exception"][@"message"]);
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchMessagesDidFail"
                                                                      object:nil];
              } else if (403 == [response[@"exception"][@"code"] integerValue]) {
                  NSLog(@"%@", response[@"exception"][@"message"]);
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchMessagesDidFail"
                                                                      object:nil];
              } else if (404 == [response[@"exception"][@"code"] integerValue]) {
                  NSLog(@"%@", response[@"exception"][@"message"]);
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchMessagesDidFail"
                                                                      object:nil];
              } else {
                  
                  NSArray *tmp_messages = response[@"list"];
                  NSMutableArray *messages = [[NSMutableArray alloc] init];
                  Message *tmp_message;
                  
                  for (NSDictionary *message in tmp_messages) {
                      tmp_message = [[Message alloc] init];
                      [tmp_message setMessage:message[@"message"]];
                      [tmp_message setDatetime:[NSDate dateWithTimeIntervalSince1970:[message[@"datetime"] doubleValue]]];
                      [tmp_message setName:message[@"name"]];
                      [tmp_message setFromMe:(1 == [message[@"currentUser"] integerValue])];
                      [messages addObject:tmp_message];
                  }

                  [[CacheHandler instance] setChatMessages:messages];
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchMessagesDidComplete"
                                    object:nil];
              }
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"FetchMessagesDidFail"
                                object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void) logout {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:[[CacheHandler instance] token] forHTTPHeaderField:@"token"];
    [manager setRequestSerializer:requestSerializer];
    NSDictionary *params = @{ @"function"       : @"logout",
                              @"token"          : [[CacheHandler instance] token]
                              };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Log out");
              
              [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutDidComplete"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [[NSNotificationCenter defaultCenter] postNotificationName:@"LogoutDidFail"
                                                                  object:nil];
              
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
              NSLog(@"Error: %@", error);
          }];
}

+ (void) signup:(NSString *)email :(NSString *)password :(NSString *)phone :(NSString *)phoneExt :(NSString *)gender :(NSString *)birthYear {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{
                             @"function"    : @"signup",
                             @"email"       : email,
                             @"password"    : password,
                             @"phone"       : phone,
                             @"phoneExt"    : phoneExt,
                             @"gender"      : gender,
                             @"birthyear"   : birthYear
                             };
    [manager POST:serverURL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id response) {
              NSLog(@"Signed up!");
              if (200 == [[response valueForKey:@"code"] integerValue]) {
                  [[CacheHandler instance] setToken:[response valueForKey:@"token"]];
                  NSLog(@"Token: %@", [[CacheHandler instance] token]);
                  [[CacheHandler instance] setCurrentUserId:[[[CacheHandler instance] token] componentsSeparatedByString:@":"][0]];
                  [[[CacheHandler instance] currentUser] setUserId:[[CacheHandler instance] currentUserId]];
                  
                  // Store data locally
                  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                  NSString *session = @"on";
                  NSString *userId = [[CacheHandler instance] currentUserId];
                  NSString *token = [[CacheHandler instance] token];
                  [prefs setObject:session forKey:@"session"];
                  [prefs setObject:userId forKey:@"userId"];
                  [prefs setObject:token forKey:@"token"];
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"SignupDidComplete"
                                                                      object:nil];
              } else {
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"SignupDidFail"
                                                                      object:nil
                                                                    userInfo:@{@"message":[response valueForKey:@"message"]}];
              }
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
          }];
}
@end
