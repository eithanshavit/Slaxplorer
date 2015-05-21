// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Member.h instead.

@import CoreData;

extern const struct MemberAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *image192;
	__unsafe_unretained NSString *image48;
	__unsafe_unretained NSString *isActive;
	__unsafe_unretained NSString *isAdmin;
	__unsafe_unretained NSString *isOwner;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *localColorNumber;
	__unsafe_unretained NSString *realName;
	__unsafe_unretained NSString *username;
} MemberAttributes;

extern const struct MemberRelationships {
	__unsafe_unretained NSString *team;
} MemberRelationships;

@class Team;

@interface MemberID : NSManagedObjectID {}
@end

@interface _Member : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MemberID* objectID;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* id;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* image192;

//- (BOOL)validateImage192:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* image48;

//- (BOOL)validateImage48:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isActive;

@property (atomic) BOOL isActiveValue;
- (BOOL)isActiveValue;
- (void)setIsActiveValue:(BOOL)value_;

//- (BOOL)validateIsActive:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isAdmin;

@property (atomic) BOOL isAdminValue;
- (BOOL)isAdminValue;
- (void)setIsAdminValue:(BOOL)value_;

//- (BOOL)validateIsAdmin:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isOwner;

@property (atomic) BOOL isOwnerValue;
- (BOOL)isOwnerValue;
- (void)setIsOwnerValue:(BOOL)value_;

//- (BOOL)validateIsOwner:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* localColorNumber;

@property (atomic) int16_t localColorNumberValue;
- (int16_t)localColorNumberValue;
- (void)setLocalColorNumberValue:(int16_t)value_;

//- (BOOL)validateLocalColorNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* realName;

//- (BOOL)validateRealName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Team *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;

@end

@interface _Member (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSString*)primitiveId;
- (void)setPrimitiveId:(NSString*)value;

- (NSString*)primitiveImage192;
- (void)setPrimitiveImage192:(NSString*)value;

- (NSString*)primitiveImage48;
- (void)setPrimitiveImage48:(NSString*)value;

- (NSNumber*)primitiveIsActive;
- (void)setPrimitiveIsActive:(NSNumber*)value;

- (BOOL)primitiveIsActiveValue;
- (void)setPrimitiveIsActiveValue:(BOOL)value_;

- (NSNumber*)primitiveIsAdmin;
- (void)setPrimitiveIsAdmin:(NSNumber*)value;

- (BOOL)primitiveIsAdminValue;
- (void)setPrimitiveIsAdminValue:(BOOL)value_;

- (NSNumber*)primitiveIsOwner;
- (void)setPrimitiveIsOwner:(NSNumber*)value;

- (BOOL)primitiveIsOwnerValue;
- (void)setPrimitiveIsOwnerValue:(BOOL)value_;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSNumber*)primitiveLocalColorNumber;
- (void)setPrimitiveLocalColorNumber:(NSNumber*)value;

- (int16_t)primitiveLocalColorNumberValue;
- (void)setPrimitiveLocalColorNumberValue:(int16_t)value_;

- (NSString*)primitiveRealName;
- (void)setPrimitiveRealName:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

- (Team*)primitiveTeam;
- (void)setPrimitiveTeam:(Team*)value;

@end
