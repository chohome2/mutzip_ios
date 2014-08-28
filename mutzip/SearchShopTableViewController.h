//
//  SearchShopTableViewController.h
//  mutzip
//
//  Created by taeho.cho on 14. 8. 14..
//  Copyright (c) 2014년 taeho.cho. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchShopTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
    NSMutableArray *array;
}
@property (nonatomic, strong) NSString *from;

@end
