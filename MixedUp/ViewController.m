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
@property (strong, nonatomic) PlaylistViewController *playlistVC;
@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation ViewController

- (void)viewDidLoad {
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
  
//  CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height -100, [[UIScreen mainScreen] bounds].size.width, 44);
//  UIToolbar* toolBar = [[UIToolbar alloc]initWithFrame:frame];
//  toolBar.barStyle = UIBarStyleBlackTranslucent;
//  [toolBar sizeToFit];
//
//  [self.playlistVC.view addSubview:toolBar];
  
  if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"authToken"] isKindOfClass:[NSString class]]){
    self.token = [[NSUserDefaults standardUserDefaults] valueForKey:@"authToken"];
    
    NetworkController *sharedNetworkController = [NetworkController sharedInstance];
    sharedNetworkController.token = self.token;
    
  }else{
    
    self.alert = [UIAlertController alertControllerWithTitle:nil message:@"MixedBeats will present a web browser to BeatsMusic user athenication" preferredStyle:UIAlertControllerStyleAlert];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.beatsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
  Beat *beat = self.beatsArray[indexPath.row];
  cell.textLabel.text = beat.name;
  
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
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


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  NSString *searchTerm = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
  
  [[NetworkController sharedInstance] searchTerm:searchTerm completionHandler:^(NSError *error, NSMutableArray *beats) {
    self.beatsArray = beats;
    [self.tableView reloadData];
  }];
  
}

@end
