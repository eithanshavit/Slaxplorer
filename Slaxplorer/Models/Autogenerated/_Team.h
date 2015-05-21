// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Team.h instead.

@import CoreData;

extern const struct TeamAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *loggedIn;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *token;
} TeamAttributes;

extern const struct TeamRelationships {
	__unsafe_unretained NSString *members;
} TeamRelationships;

@class Member;

@interface TeamID : NSManagedObjectID {}
@end

@interface _Team : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TeamID* objectID;

@property (nonatomic, strong) NSString* id;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* loggedIn;

@property (atomic) BOOL loggedInValue;
- (BOOL)loggedInValue;
- (void)setLoggedInValue:(BOOL)value_;

//- (BOOL)validateLoggedIn:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* token;

//- (BOOL)validateToken:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *members;

- (NSMutableSet*)membersSet;

@end

@interface _Team (MembersCoreDataGeneratedAccessors)
- (void)addMembers:(NSSet*)value_;
- (void)removeMembers:(NSSet*)value_;
- (void)addMembersObject:(Member*)value_;
- (void)removeMembersObject:(Member*)value_;

@end

@interface _Team (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;

- (NSNumber*)primitiveLoggedIn;
- (void)setPrimitiveLoggedIn:(NSNumber*)value;

- (BOOL)primitiveLoggedInValue;
- (void)setPrimitiveLoggedInValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveToken;
- (void)setPrimitiveToken:(NSString*)value;

- (NSMutableSet*)primitiveMembers;
- (void)setPrimitiveMembers:(NSMutableSet*)value;

@end
