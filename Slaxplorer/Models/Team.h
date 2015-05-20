#import "_Team.h"

@interface Team : _Team {}

typedef NS_ENUM(NSInteger, TeamDataStatus) {
  TeamDataStatusOK,
  TeamDataStatusAccountInactive,
  TeamDataStatusUnknown,
};

// Creates a new Team with ID and Name in MOC
+ (Team *)createTeamWithID:(NSString *)teamID name:(NSString *)teamName inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
