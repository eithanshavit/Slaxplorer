#import "_Team.h"

@interface Team : _Team {}

typedef NS_ENUM(NSInteger, TeamDataStatus) {
  TeamDataStatusOK,
  TeamDataStatusAccountInactive,
  TeamDataStatusUserIsBot,
  TeamDataStatusUnknown,
};

@end
