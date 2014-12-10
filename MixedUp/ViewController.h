//
//  ViewController.h
//  MixedUp
//
//  Created by Kori Kolodziejczak on 12/5/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate, UISearchBarDelegate, UIWebViewDelegate>

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;


@end

