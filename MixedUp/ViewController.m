//
//  ViewController.m
//  MixedUp
//
//  Created by Kori Kolodziejczak on 12/5/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSString *token;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIAlertController *alert;
@property (strong, nonatomic) PlaylistViewController *playlistVC;
@property (strong, nonatomic)  NSArray* beatSectionTitles;
@property (strong, nonatomic) NSDictionary* beats;
@property (strong, nonatomic)  NSString *searchTerm;

@end

@implementation ViewController

-(void)viewDidLoad {
  [super viewDidLoad];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.searchBar.delegate = self;
  
  UISwipeGestureRecognizer *leftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandler:)];
  UISwipeGestureRecognizer *rightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandler:)];
  
  [leftGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
  [rightGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
  
  
  [self.view addGestureRecognizer:leftGestureRecognizer];
  [self.view addGestureRecognizer:rightGestureRecognizer];
  
}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear: animated];
  
  self.playlistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PLAYLIST_VC"];
  
  self.playlistVC.playlistArray = [[NSMutableArray alloc]init];
  
  self.playlistVC.view.frame = CGRectMake(self.view.frame.size.width * 1.0, 0, self.view.frame.size.width,self.view.frame.size.height);
  
  
  if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"authToken"] isKindOfClass:[NSString class]]){
    self.token = [[NSUserDefaults standardUserDefaults] valueForKey:@"authToken"];
    
    NetworkController *sharedNetworkController = [NetworkController sharedInstance];
    sharedNetworkController.token = self.token;
    
  }else{
    
    self.alert = [UIAlertController alertControllerWithTitle:nil message:@"MixedBeats will present a web browser to BeatsMusic user authentication" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [[NetworkController sharedInstance]requestOAuthAccess];
      
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    
    [self.alert addAction:okAction];
    [self.alert addAction:cancelAction];
    [self presentViewController:self.alert animated:YES completion:nil];
  }
}

//<<<<<<< HEAD
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//  return self.beatsArray.count;
//=======
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    self.searchTerm = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [[NetworkController sharedInstance] federatedSearchTerm:self.searchTerm completionHandler:^(NSError *error, NSDictionary *beats) {
        self.beats = beats;
        self.beatSectionTitles = [beats allKeys];
      
    [self.tableView reloadData];
  }];

}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
  return [self.beatSectionTitles count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 55, 18)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTag:section];
    
    if (button.tag == 0) {
        [button addTarget:self action:@selector(moreArtistButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }else if (button.tag == 1) {
        [button addTarget:self action:@selector(moreAlbumsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [button addTarget:self action:@selector(moreTracksButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }

    [button setTitle:@"more>" forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = CGPointMake(tableView.frame.size.width - 50, 9);
    
    
    
    
    
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    NSString *string = [self.beatSectionTitles objectAtIndex:section];
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view addSubview:button];
    
    //[view addSubview:button];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSString *sectionTitle = [self.beatSectionTitles objectAtIndex:section];
      NSArray *sectionNames = [self.beats objectForKey:sectionTitle];
    return [sectionNames count];
 // return self.beatsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];

    NSString *sectionTitle = [self.beatSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionNames = [self.beats objectForKey:sectionTitle];
    NSDictionary *beat = [sectionNames objectAtIndex:indexPath.row];
  cell.textLabel.text = beat[@"display"];
  
  return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  Beat *beat = self.beatsArray[indexPath.row];
  [self.playlistVC.playlistArray addObject:beat];
  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)leftSwipeHandler:(UISwipeGestureRecognizer *)recognizer {
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.view addSubview:self.playlistVC.view];
    [self.playlistVC didMoveToParentViewController:(self)];
    [self addChildViewController:self.playlistVC];
    self.playlistVC.view.frame = CGRectMake(self.view.frame.size.width * 0, 0, self.view.frame.size.width, self.view.frame.size.height);
  } completion:^(BOOL finished) {
    [self.playlistVC.tableView reloadData];
    
  }];
}

-(void)rightSwipeHandler:(UISwipeGestureRecognizer *)recognizer {
  
  [UIView animateWithDuration:0.3 animations:^{
    self.playlistVC.view.frame = CGRectMake(self.view.frame.size.width * .98, 0, self.view.frame.size.width, self.view.frame.size.height);
  } completion:^(BOOL finished) {
  }];
  
}

-(void)moreArtistButtonAction{
  NSLog(@"More Artist");
  [[NetworkController sharedInstance] moreSearchTerm:self.searchTerm type:@"artist" completionHandler:^(NSError *error, NSDictionary *beats) {
    self.beats = beats;
    self.beatSectionTitles = [beats allKeys];
    
    [self.tableView reloadData];
  }];
}

//-(void)moreArtistButtonAction{
//    NSLog(@"More Artist");
//    [[NetworkController sharedInstance] moreSearchTerm:self.searchTerm type:@"artist" completionHandler:^(NSError *error, NSDictionary *beats) {
//        self.beats = beats;
//        self.beatSectionTitles = [beats allKeys];
//        
//        [self.tableView reloadData];
//    }];
//}

-(void)moreAlbumsButtonAction{
    NSLog(@"More Albums");
}

-(void)moreTracksButtonAction{
    NSLog(@"More Tracks");

}

//-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//  NSString *searchTerm = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//  
//  [[NetworkController sharedInstance] searchTerm:searchTerm completionHandler:^(NSError *error, NSMutableArray *beats) {
//    self.beatsArray = beats;
//    [self.tableView reloadData];
//  }];
//  
//}

@end
