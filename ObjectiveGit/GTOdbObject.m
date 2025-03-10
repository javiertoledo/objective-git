//
//  GTOdbObject.m
//  ObjectiveGitFramework
//
//  Created by Timothy Clem on 3/23/11.
//  Copyright 2011 GitHub, Inc. All rights reserved.
//

#import "GTOdbObject.h"
#import "GTRepository.h"
#import "NSString+Git.h"
#import "GTOID.h"
#import "git2/odb.h"

@interface GTOdbObject ()
@property (nonatomic, assign, readonly) git_odb_object *git_odb_object;
@end

@implementation GTOdbObject

- (void)dealloc {
	if (_git_odb_object != NULL) {
		git_odb_object_free(_git_odb_object);
		_git_odb_object = NULL;
	}
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: %p> shaHash: %@, length: %zi, data: %@", NSStringFromClass([self class]), self, [self shaHash], [self length], [self data]];
}


#pragma mark API

// XCode 7+ require overriding super designated initializers
- (instancetype)init
{
	git_odb_object *odbObject = NULL;
	return [self initWithOdbObj:odbObject repository:[GTRepository new]];
}

- (instancetype)initWithOdbObj:(git_odb_object *)object repository:(GTRepository *)repository {
	NSParameterAssert(object != NULL);
	NSParameterAssert(repository != nil);

	self = [super init];
	if (self == nil) return nil;

	_git_odb_object = object;
	_repository = repository;

	return self;
}

- (NSString *)shaHash {
	return self.OID.SHA;
}

- (GTObjectType)type {
	return (GTObjectType) git_odb_object_type(self.git_odb_object);
}

- (size_t)length {
	return git_odb_object_size(self.git_odb_object);
}

- (NSData *)data {
	return [NSData dataWithBytes:git_odb_object_data(self.git_odb_object) length:self.length];
}

- (GTOID *)OID {
	return [GTOID oidWithGitOid:git_odb_object_id(self.git_odb_object)];
}

@end
