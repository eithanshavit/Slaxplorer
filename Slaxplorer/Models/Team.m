#import "Team.h"

@interface Team ()

@end

@implementation Team

/*
+ (Team *)updateTeamWithTempTeam:(TempTeam *)tempTeam inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
  // See if team with ID already exists
  NSEntityDescription *entityDescription = [NSEntityDescription entityForName:[Team entityName] inManagedObjectContext:managedObjectContext];
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:entityDescription];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@",teamID];
  [request setPredicate:predicate];
  NSError *error;
  NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
  NSAssert(array != nil, @"Unable to perform fetch from Core Data");
  
  Team *team;
  if (array.count) {
    team = array.firstObject;
  } else {
    team = [NSEntityDescription insertNewObjectForEntityForName:[Team entityName] inManagedObjectContext:managedObjectContext];
    team.id = teamID;
  }
  team.name = teamName;
  team.token = token;
  return team;
}
 */

@end
