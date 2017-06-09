//
//  WSRestKitMappableModel.h
//  SWGitHub
//
//  Created by Sergiy Bekker on 15.03.17.
//  Copyright © 2017 SBApps. All rights reserved.
//

#ifndef SWRestKitMappableModel_h
#define SWRestKitMappableModel_h


@protocol SWRestKitMappableModel <NSObject>

+ (NSDictionary<NSString *, NSString *> *)attributesMapping;
+ (NSString *)pathPattern;
+ (NSString *)pathPatternExtrn;
+ (NSString *)pathPatternDelete;
+ (NSString *)keyPath;
+ (NSDictionary *)parameters;


@end


#endif /* SWRestKitMappableModel_h */
