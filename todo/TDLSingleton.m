//
//  TDLSingleton.m
//  todo
//
//  Created by Jeffery Moulds on 5/6/14.
//  Copyright (c) 2014 Jeffery Moulds. All rights reserved.
//

#import "TDLSingleton.h"

@interface TDLSingleton ()

@property (nonatomic) NSMutableArray * listItems;


@end

@implementation TDLSingleton



+(TDLSingleton *)sharedCollection

{
static dispatch_once_t create;
static TDLSingleton * singleton = nil;

dispatch_once(&create, ^{
    singleton = [[TDLSingleton alloc] init];
});

return singleton;

}


-(id)init

{

    self = [super init];
    if(self)
    {
        [self loadListItems];
        
    }
    return self;
    
}



// pre-built getter; not letting it == nil (creates an empty array when accessed first time)
-(NSMutableArray *)listItems
{
    if(_listItems == nil)
    {
        _listItems = [@[] mutableCopy];
    }
    
//    NSLog(@"%@", _listItems);
          
    return _listItems;
    
    
}


-(void)addListItem:(NSDictionary *)listItem
{
//  calls getter method above and creates the new array before item is added
    [self.listItems addObject:listItem];
    [self saveData];

}



-(NSArray *)allListItems
{

    return [self.listItems copy];
    // or  these do the same.  Copy is immutable... can use simultanesously.  It is a new item entirely with copy.
    return [NSArray arrayWithArray:self.listItems];

}

-(void)removeListItem:(NSDictionary *)listItem;
{
    [self.listItems removeObjectIdenticalTo:listItem];
    [self saveData];
    
}



-(void)removeListItemAtIndex:(NSInteger)index;
{
    [self.listItems removeObjectAtIndex:index];
    [self saveData];
    
}





- (void)saveData
{
    NSString *path = [self listArchivePath];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.listItems];
    [data writeToFile:path options:NSDataWritingAtomic error: nil];
    
}


- (NSString *) listArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = documentDirectories[0];
    return [documentDirectory stringByAppendingPathComponent:@"listdata.data"];
    
}


-(void)loadListItems
{
    
    NSString *path = [self listArchivePath];
    if([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        self.listItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
}





@end
