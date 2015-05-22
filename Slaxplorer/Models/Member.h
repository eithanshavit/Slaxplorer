#import "_Member.h"
#import <FastImageCache/FICEntity.h>

@interface Member : _Member <FICEntity> {}

typedef NS_ENUM(NSInteger, MemberListDataStatus) {
  MemberListDataStatusOK,
  MemberListDataStatusAccountInactive,
  MemberListDataStatusUnknown,
};

@end
