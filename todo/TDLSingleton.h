//
//  TDLSingleton.h
//  todo
//
//  Created by Jeffery Moulds on 5/6/14.
//  Copyright (c) 2014 Jeffery Moulds. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDLSingleton : NSObject

+ (TDLSingleton *)sharedCollection;

-(void)addListItem:(NSDictionary *)listItem;
-(void)removeListItem:(NSDictionary *)listItem;
-(void)removeListItemAtIndex:(NSInteger)index;
-(NSArray *)allListItems;


@end
