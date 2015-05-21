#import "_Team.h"


@interface Team : _Team {}

typedef NS_ENUM(NSInteger, TeamDataStatus) {
  TeamDataStatusOK,
  TeamDataStatusAccountInactive,
  TeamDataStatusUserIsBot,
  TeamDataStatusUnknown,
};

// Creates a new Team with ID and Name in MOC
//+ (Team *)updateTeamWithTempTeam:(TempTeam *)tempTeam inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
