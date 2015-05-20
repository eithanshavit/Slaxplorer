#import "Team.h"

@interface Team ()

@end

@implementation Team

+ (Team *)createTeamWithID:(NSString *)teamID name:(NSString *)teamName inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
  Team *team = [NSEntityDescription insertNewObjectForEntityForName:[Team entityName] inManagedObjectContext:managedObjectContext];
  team.name = teamName;
  team.id = teamID;
  return team;
}

@end
