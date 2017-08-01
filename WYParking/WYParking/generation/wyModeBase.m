//
//  wyModeBase.m
//  WYParking
//
//  Created by Leon on 17/2/6.
//  Copyright © 2017年 Leon. All rights reserved.
//

#import "wyModeBase.h"
#include <objc/runtime.h>

@implementation wyModeBase

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (void)encodeWithCoder:(NSCoder *)encoder {
    Class cls = [self class];
    while (cls != [NSObject class]) {
        unsigned int numberOfIvars = 0;
        Ivar *ivars = class_copyIvarList(cls, &numberOfIvars);
        for (const Ivar *p=ivars; p<ivars+numberOfIvars; p++) {
            Ivar const ivar = *p;
            const char *type = ivar_getTypeEncoding(ivar);
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            if (key == nil) {
                continue;
            }
            if ([key length] == 0) {
                continue;
            }
            
            id value = [self valueForKey:key];
            if (value) {
                switch (type[0]) {
                    case _C_STRUCT_B: {
                        NSUInteger ivarSize = 0;
                        NSUInteger ivarAlignment = 0;
                        NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                        NSData *data = [NSData dataWithBytes:(const char *)((__bridge void *)self) + ivar_getOffset(ivar) length:ivarSize];
                        [encoder encodeObject:data forKey:key];
                    } break;
                    default: {
                        [encoder encodeObject:value forKey:key];
                    } break;
                }
            }
        }
        
        if (ivars) {
            free(ivars);
        }
        
        cls = class_getSuperclass(cls);
    }
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init]) {
        Class cls = [self class];
        while (cls != [NSObject class]) {
            unsigned int numberOfIvars = 0;
            Ivar *ivars = class_copyIvarList(cls, &numberOfIvars);
            
            for (const Ivar *p=ivars; p<ivars+numberOfIvars; p++) {
                Ivar const ivar = *p;
                const char *type = ivar_getTypeEncoding(ivar);
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
                if (key == nil) {
                    continue;
                }
                
                if ([key length] == 0) {
                    continue;
                }
                
                id value = [decoder decodeObjectForKey:key];
                
                if (value) {
                    switch (type[0]) {
                        case _C_STRUCT_B: {
                            NSUInteger ivarSize = 0;
                            NSUInteger ivarAlignment = 0;
                            NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
                            NSData *data = [decoder decodeObjectForKey:key];
                            char *sourceIvarLocation = (char*)((__bridge void *)self)+ ivar_getOffset(ivar);
                            [data getBytes:sourceIvarLocation length:ivarSize];
                            memcpy((char *)((__bridge void *)self) + ivar_getOffset(ivar), sourceIvarLocation, ivarSize);
                        } break;
                        default: {
                            [self setValue:value forKey:key];
                        } break;
                    }
                }
            }
            
            if (ivars) {
                free(ivars);
            }
            
            cls = class_getSuperclass(cls);
        }
    }
    
    return self;
}


- (NSData *)archiveToData2{
     return [NSKeyedArchiver archivedDataWithRootObject:self];
}



+ (instancetype)unArchiveWithData:(NSData *)data{
    id result = nil;
    if ([data isKindOfClass:NSData.class]) {
        result = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return result;
}

@end
