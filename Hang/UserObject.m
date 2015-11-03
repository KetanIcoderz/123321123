//
//  UserObject.m
//  Hang
//
//  Created by iCoderz_Ankit on 9/18/15.
//  Copyright (c) 2015 iCoderz. All rights reserved.
//

#import "UserObject.h"

@implementation UserObject

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.user_acccessToken forKey:@"user_acccessToken"];
    [encoder encodeObject:self.user_deviceInfo forKey:@"user_deviceInfo"];
    [encoder encodeObject:self.user_email forKey:@"user_email"];
    [encoder encodeObject:self.user_facebookSync forKey:@"user_facebookSync"];
    [encoder encodeObject:self.user_firstName forKey:@"user_firstName"];
    [encoder encodeObject:self.user_id forKey:@"user_id"];
    [encoder encodeObject:self.user_isBlocked forKey:@"user_isBlocked"];
    [encoder encodeObject:self.user_isPrivate forKey:@"user_isPrivate"];
    [encoder encodeObject:self.user_lastChange forKey:@"user_lastChange"];
    [encoder encodeObject:self.user_lastLogin forKey:@"user_lastLogin"];
    [encoder encodeObject:self.user_lastName forKey:@"user_lastName"];
    [encoder encodeObject:self.user_mobileNo forKey:@"user_mobileNo"];
    [encoder encodeObject:self.user_name forKey:@"user_name"];
    [encoder encodeObject:self.user_osVersion forKey:@"user_osVersion"];
    [encoder encodeObject:self.user_profilePictureURL forKey:@"user_profilePictureURL"];
    [encoder encodeObject:self.user_RegDate forKey:@"user_RegDate"];
    [encoder encodeObject:self.user_type forKey:@"user_type"];
    [encoder encodeObject:self.ProfileImage forKey:@"ProfileImage"];
    

}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        //decode properties, other class vars
        self.user_acccessToken = [decoder decodeObjectForKey:@"user_acccessToken"];
        self.user_deviceInfo = [decoder decodeObjectForKey:@"user_deviceInfo"];
        self.user_email = [decoder decodeObjectForKey:@"user_email"];
        self.user_facebookSync = [decoder decodeObjectForKey:@"user_facebookSync"];
        self.user_firstName = [decoder decodeObjectForKey:@"user_firstName"];
        self.user_id = [decoder decodeObjectForKey:@"user_id"];
        self.user_isBlocked = [decoder decodeObjectForKey:@"user_isBlocked"];
        self.user_isPrivate = [decoder decodeObjectForKey:@"user_isPrivate"];
        self.user_lastChange = [decoder decodeObjectForKey:@"user_lastChange"];
        self.user_lastLogin = [decoder decodeObjectForKey:@"user_lastLogin"];
        self.user_lastName = [decoder decodeObjectForKey:@"user_lastName"];
        self.user_mobileNo = [decoder decodeObjectForKey:@"user_mobileNo"];
        self.user_name = [decoder decodeObjectForKey:@"user_name"];
        self.user_osVersion = [decoder decodeObjectForKey:@"user_osVersion"];
        self.user_profilePictureURL = [decoder decodeObjectForKey:@"user_profilePictureURL"];
        self.user_RegDate = [decoder decodeObjectForKey:@"user_RegDate"];
        self.user_type = [decoder decodeObjectForKey:@"user_type"];
        self.ProfileImage = [decoder decodeObjectForKey:@"ProfileImage"];
    }
    return self;
}


@end
