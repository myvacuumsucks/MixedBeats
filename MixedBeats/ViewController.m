//
//  ViewController.m
//  MixedBeats
//
//  Created by Brian Mendez on 12/5/14.
//  Copyright (c) 2014 Brian Mendez. All rights reserved.
//

#import "ViewController.h"
#import "Beat.h"
#import "NetworkController.h"

@interface ViewController ()

@property (strong, nonatomic) NSString *OAuthClientKey;
@property (strong, nonatomic) NSString *OAuthClientSecret;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSArray *beatsArray;

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.OAuthClientKey = @"t3uz7rxmzq2a57hnqdxjzwbh";
    self.OAuthClientSecret = @"Amg4eHtxe4Wt2QANTwHzHa8m";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.webView.delegate = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.beatsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    Beat *beat = self.beatsArray[indexPath.row];
    cell.textLabel.text = beat.name;
    
    return cell;
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [[NetworkController sharedManager] searchTerm:searchTerm completionHandler:^(NSError *error, NSMutableArray *beats) {
        self.beatsArray = beats;
        [self.tableView reloadData];
    }];
    
}

@end