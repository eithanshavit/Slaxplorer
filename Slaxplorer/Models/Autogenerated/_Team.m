// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Team.m instead.

#import "_Team.h"

const struct TeamAttributes TeamAttributes = {
	.id = @"id",
	.loggedIn = @"loggedIn",
	.name = @"name",
	.token = @"token",
};

const struct TeamRelationships TeamRelationships = {
	.members = @"members",
};

@implementation TeamID
@end

@implementation _Team

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Team";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Team" inManagedObjectContext:moc_];
}

- (TeamID*)objectID {
	return (TeamID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"loggedInValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"loggedIn"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic id;

@dynamic loggedIn;

- (BOOL)loggedInValue {
	NSNumber *result = [self loggedIn];
	return [result boolValue];
}

- (void)setLoggedInValue:(BOOL)value_ {
	[self setLoggedIn:@(value_)];
}

- (BOOL)primitiveLoggedInValue {
	NSNumber *result = [self primitiveLoggedIn];
	return [result boolValue];
}

- (void)setPrimitiveLoggedInValue:(BOOL)value_ {
	[self setPrimitiveLoggedIn:@(value_)];
}

@dynamic name;

@dynamic token;

@dynamic members;

- (NSMutableSet*)membersSet {
	[self willAccessValueForKey:@"members"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"members"];

	[self didAccessValueForKey:@"members"];
	return result;
}

@end

