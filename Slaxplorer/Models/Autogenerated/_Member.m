// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Member.m instead.

#import "_Member.h"

const struct MemberAttributes MemberAttributes = {
	.id = @"id",
	.image192URL = @"image192URL",
	.image48URL = @"image48URL",
	.isActive = @"isActive",
	.isAdmin = @"isAdmin",
	.isOwner = @"isOwner",
	.optEmail = @"optEmail",
	.optFirstName = @"optFirstName",
	.optLastName = @"optLastName",
	.optPhoneNumber = @"optPhoneNumber",
	.optRealName = @"optRealName",
	.optSkype = @"optSkype",
	.username = @"username",
};

const struct MemberRelationships MemberRelationships = {
	.team = @"team",
};

@implementation MemberID
@end

@implementation _Member

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Member" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Member";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Member" inManagedObjectContext:moc_];
}

- (MemberID*)objectID {
	return (MemberID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isActiveValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isActive"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isAdminValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isAdmin"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isOwnerValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isOwner"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic id;

@dynamic image192URL;

@dynamic image48URL;

@dynamic isActive;

- (BOOL)isActiveValue {
	NSNumber *result = [self isActive];
	return [result boolValue];
}

- (void)setIsActiveValue:(BOOL)value_ {
	[self setIsActive:@(value_)];
}

- (BOOL)primitiveIsActiveValue {
	NSNumber *result = [self primitiveIsActive];
	return [result boolValue];
}

- (void)setPrimitiveIsActiveValue:(BOOL)value_ {
	[self setPrimitiveIsActive:@(value_)];
}

@dynamic isAdmin;

- (BOOL)isAdminValue {
	NSNumber *result = [self isAdmin];
	return [result boolValue];
}

- (void)setIsAdminValue:(BOOL)value_ {
	[self setIsAdmin:@(value_)];
}

- (BOOL)primitiveIsAdminValue {
	NSNumber *result = [self primitiveIsAdmin];
	return [result boolValue];
}

- (void)setPrimitiveIsAdminValue:(BOOL)value_ {
	[self setPrimitiveIsAdmin:@(value_)];
}

@dynamic isOwner;

- (BOOL)isOwnerValue {
	NSNumber *result = [self isOwner];
	return [result boolValue];
}

- (void)setIsOwnerValue:(BOOL)value_ {
	[self setIsOwner:@(value_)];
}

- (BOOL)primitiveIsOwnerValue {
	NSNumber *result = [self primitiveIsOwner];
	return [result boolValue];
}

- (void)setPrimitiveIsOwnerValue:(BOOL)value_ {
	[self setPrimitiveIsOwner:@(value_)];
}

@dynamic optEmail;

@dynamic optFirstName;

@dynamic optLastName;

@dynamic optPhoneNumber;

@dynamic optRealName;

@dynamic optSkype;

@dynamic username;

@dynamic team;

@end

