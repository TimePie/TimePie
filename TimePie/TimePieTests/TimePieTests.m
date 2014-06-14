//
//  TimePieTests.m
//  TimePieTests
//
//  Created by Storm Max on 3/27/14.
//  Copyright (c) 2014 TimePieOrg. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TimingItemStore.h"
#import "TimingItem1.h"
#import "ColorThemes.h"
#import "Tag.h"
#import "Daily.h"
#import "BasicUIColor+UIPosition.h"

@interface TimePieTests : XCTestCase

@end

@implementation TimePieTests

- (void)setUp
{
    [[TimingItemStore timingItemStore] deleteAllData];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


//1
- (void)testIfTimingItemStoreEmpty
{
    [[TimingItemStore timingItemStore] restoreData];
    XCTAssertTrue(0==[[[TimingItemStore timingItemStore] allItems] count],@"testIfTimingItemStoreEmpty");
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


//2
- (void)testCreateItem
{
    [[TimingItemStore timingItemStore] createItem];
    NSArray* allItems = [[TimingItemStore timingItemStore] allItems];
    XCTAssertTrue(1==[allItems count],@"testCreateItem");
    XCTAssertTrue(YES==[[(TimingItem*)[allItems objectAtIndex:0] itemName] isEqualToString:@"An item"],@"testCreateItem Name: An item");
}

//3
- (void)testDeleteItem
{
    [[TimingItemStore timingItemStore] deletaAllItem];
    NSArray* allItems = [[TimingItemStore timingItemStore] allItems];
    XCTAssertTrue(0==[allItems count],@"testCreateItem");
}

//4
- (void)testCreateItemFromItem
{
    TimingItem *i = [TimingItem randomItem];
    i.itemName = @"new item";
    i.itemColor = [[ColorThemes colorThemes] getAColor];
    NSArray * allItems = [[TimingItemStore timingItemStore] allItems];
    [[TimingItemStore timingItemStore] createItem:i];
    XCTAssertTrue(1==[allItems count],@"testCreateItemFromItem");
    XCTAssertTrue(YES==[[(TimingItem*)[allItems objectAtIndex:0] itemName] isEqualToString:@"new item"],@"testCreateItemFromItem");
}

//5
- (void)testViewAllItem
{
    [[TimingItemStore timingItemStore] deletaAllItem];
    for(int i = 0; i<10;i++){
        [[TimingItemStore timingItemStore] createItem];
    }
    [[TimingItemStore timingItemStore] saveData];
    
    XCTAssertTrue(10==(int)[[TimingItemStore timingItemStore] viewAllItem] ,@"testViewAllItem");
}

//6 failed
- (void) testMoveItemAtIndexToIndex
{
    int number = 10;
    int atIndex = 3;
    int toIndex = 5;
    int toIndexOutOfRange = 12;
    
    [[TimingItemStore timingItemStore] deletaAllItem];
    for(int i = 0; i < number; i++){
        TimingItem* temp = [[TimingItemStore timingItemStore] createItem];
        temp.itemName = [NSString stringWithFormat:@"tempName_%d",i];
    }
    [[TimingItemStore timingItemStore] saveData];
    
    [[TimingItemStore timingItemStore] moveItemAtIndex:atIndex toIndex:toIndex];
    TimingItem* getItem = [[TimingItemStore timingItemStore] getItemAtIndex:atIndex];
    NSString* toIndexName = [NSString stringWithFormat:@"tempName_%d",toIndex - 1];
     XCTAssertTrue([toIndexName isEqualToString: getItem.itemName] ,@"testMoveItemAtIndexToIndex");
    
    //out of array range, failed
//    
//    [[TimingItemStore timingItemStore] deletaAllItem];
//    for(int i = 0; i < number; i++){
//        TimingItem* temp = [[TimingItemStore timingItemStore] createItem];
//        temp.itemName = [NSString stringWithFormat:@"tempName_%d",i];
//    }
//    [[TimingItemStore timingItemStore] saveData];
//    [[TimingItemStore timingItemStore] moveItemAtIndex:atIndex toIndex:toIndexOutOfRange];
//    getItem = [[TimingItemStore timingItemStore] getItemAtIndex:atIndex];
//    toIndexName = [NSString stringWithFormat:@"tempName_%d",toIndexOutOfRange];
//    XCTAssertTrue([toIndexName isEqualToString:getItem.itemName],@"testMoveItemAtIndexToIndex");
}

//7
- (void)testAddTag
{
    [[TimingItemStore timingItemStore] deleteAllData];
    [[TimingItemStore timingItemStore] addTag:@"testTag"];
    XCTAssertTrue(1==[[[TimingItemStore timingItemStore] getAllTags] count],@"testAddTag");
    XCTAssertTrue(YES==[((Tag*)[[[TimingItemStore timingItemStore] getAllTags] objectAtIndex:0]).tag_name isEqualToString:@"testTag"],@"testAddTag");
}

//8
- (void)testAddTagWithItem
{
    [[TimingItemStore timingItemStore] deleteAllData];
    TimingItem* item = [[TimingItemStore timingItemStore] createItem];
    [[TimingItemStore timingItemStore] saveData];
    [[TimingItemStore timingItemStore] addTag:item TagName:@"testTag"];
    XCTAssertTrue(1==[[[TimingItemStore timingItemStore] getAllTags] count],@"testAddTagWithItem");
    XCTAssertTrue(YES==[((Tag*)[[[TimingItemStore timingItemStore] getAllTags] objectAtIndex:0]).tag_name isEqualToString:@"testTag"],@"testAddTagWithItem");
    NSArray* itemAry = [[TimingItemStore timingItemStore] getTimingItemsByTagName:@"testTag"];
    XCTAssertTrue([itemAry count]==1,@"testAddTagWithItem");
    TimingItemEntity * item1 = [itemAry objectAtIndex:0];
    XCTAssertTrue([item.dateCreated isEqualToDate:item1.date_created],@"testAddTagWithItem");
    XCTAssertTrue([item.itemName isEqualToString:item1.item_name],@"testAddTagWithItem");
}

//9
- (void) testGetTimingItemsByTagName
{
    [[TimingItemStore timingItemStore] deleteAllData];
    
    int number = 20;
    for (int i = 0; i < number; i++) {
        TimingItem* item = [[TimingItemStore timingItemStore] createItem];
        [[TimingItemStore timingItemStore] saveData];
        [[TimingItemStore timingItemStore] addTag:item TagName:@"testTag"];
    }
    NSArray *allItem = [[TimingItemStore timingItemStore] getTimingItemsByTagName:@"testTag"];
    XCTAssertTrue([allItem count] == number,@"testGetTimingItemsByTagName");
}

//10
- (void) testGetAllTag
{
    [[TimingItemStore timingItemStore] deleteAllData];
    
    int number = 20;
    for (int i = 0; i < number; i++) {
        [[TimingItemStore timingItemStore] addTag:[NSString stringWithFormat:@"TestTag_%d",i]];
        [[TimingItemStore timingItemStore] saveData];
    }
    NSArray *allTag = [[TimingItemStore timingItemStore] getAllTags];
    XCTAssertTrue([allTag count] == number,@"testGetTimingItemsByTagName");
}


//11
- (void)testAddDaily
{
    [[TimingItemStore timingItemStore] deleteAllData];
    [[TimingItemStore timingItemStore] addTag:@"testTag"];
    [[TimingItemStore timingItemStore] addDaily:@"testDaily" tag:@"testTag"];
    NSArray * allDaily  = [[TimingItemStore timingItemStore] getAllDaily];
    XCTAssertTrue([allDaily count]==1, @"testAddDaily");
    XCTAssertTrue([[(Daily*)[allDaily objectAtIndex:0] tag_name] isEqualToString:@"testTag"], @"testAddDaily");
}

//12
- (void)testRemoveDaily
{
    [[TimingItemStore timingItemStore] deleteAllData];
    [[TimingItemStore timingItemStore] addTag:@"testTag"];
    [[TimingItemStore timingItemStore] addDaily:@"testDaily" tag:@"testTag"];
    [[TimingItemStore timingItemStore] removeDaily:@"testDaily"];
    NSArray * allDaily  = [[TimingItemStore timingItemStore] getAllDaily];
    XCTAssertTrue([allDaily count]==0, @"testRemoveDaily");
    
}

//13
- (void)testUpdateDaily
{
    [[TimingItemStore timingItemStore] deleteAllData];
    [[TimingItemStore timingItemStore] addTag:@"testTag"];
    [[TimingItemStore timingItemStore] addDaily:@"testDaily" tag:@"testTag"];
    [[TimingItemStore timingItemStore] updateDaily:@"testDaily" toName:@"testDaily1"];
    NSArray * allDaily  = [[TimingItemStore timingItemStore] getAllDaily];
    XCTAssertTrue([allDaily count]==1, @"testUpdateDaily");
    XCTAssertTrue([[(Daily*)[allDaily objectAtIndex:0] item_name] isEqualToString:@"testDaily1"], @"testUpdateDaily");
}

//14
- (void)testGetAllDaily
{
    [[TimingItemStore timingItemStore] deleteAllData];
    
    //creat
    int number = 100;
    for (int i = 0; i < number; i++) {
        NSString *tagName = [NSString stringWithFormat:@"testTag_%d",i];
        NSString *dailyName = [NSString stringWithFormat:@"dailyName_%d",i];
        [[TimingItemStore timingItemStore] addTag:tagName];
        [[TimingItemStore timingItemStore] addDaily:dailyName tag:tagName];
    }
    NSArray * allDaily  = [[TimingItemStore timingItemStore] getAllDaily];
    
    XCTAssertTrue([allDaily count] == number, @"testgetAllDaily");
}

//15
- (void) testGetColor
{
    NSMutableArray * testColorTheme = [[NSMutableArray alloc] init];
    [testColorTheme addObject:REDNO1];
    [testColorTheme addObject:BLUENO2];
    [testColorTheme addObject:GREENNO3];
    [testColorTheme addObject:PINKNO04];
    [testColorTheme addObject:BROWNN05];
    [testColorTheme addObject:YELLOWN06];
    [testColorTheme addObject:PURPLEN07];
    [testColorTheme addObject:P01N08];
    [testColorTheme addObject:P01N09];
    [testColorTheme addObject:P01N10];
    
    ColorThemes * colorThemes = [ColorThemes colorThemes];
    UIColor *tempColor1 = (UIColor*)[colorThemes getColorAt:4];
    UIColor *temoColor2 = (UIColor*)[testColorTheme objectAtIndex:4];
    XCTAssertTrue( [temoColor2 isEqual:tempColor1] , @"testGetColor");
}










@end
