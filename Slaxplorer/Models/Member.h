#import "_Member.h"

@interface Member : _Member {}

typedef NS_ENUM(NSInteger, MemberListDataStatus) {
  MemberListDataStatusOK,
  MemberListDataStatusAccountInactive,
  MemberListDataStatusUnknown,
};

@end
