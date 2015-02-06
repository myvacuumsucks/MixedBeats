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

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
//    self.beatSectionTitles = @[@"artists",@"albums",@"tracks"];
  
    
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

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchTerm = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [[NetworkController sharedInstance] searchTerm:searchTerm completionHandler:^(NSError *error, NSDictionary *beats) {
        self.beats = beats;
        self.beatSectionTitles = [beats allKeys];
        
        //self.beatsArray = beats;
        [self.tableView reloadData];
    }];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.beatSectionTitles count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.beatSectionTitles objectAtIndex:section];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     NSString *sectionTitle = [self.beatSectionTitles objectAtIndex:section];
      NSArray *sectionNames = [self.beats objectForKey:sectionTitle];
    return [sectionNames count];
 // return self.beatsArray.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, 320.0, 22.0)];
    customView.backgroundColor = [UIColor blackColor];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 40, 50, 50)];
    UIButton *seeAllButton = [[UIButton alloc] initWithFrame:CGRectMake(11, 40, 50, 50)];
    seeAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
    NSString *string = [self.beatSectionTitles objectAtIndex:section];
    NSString *beginning = [NSString stringWithFormat:@"all %@", string];
    
    [seeAllButton setTitle:beginning forState:UIControlStateNormal];
    seeAllButton.frame = CGRectMake(285, 0, 100, 20);
    [seeAllButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor redColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:18];
    headerLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    headerLabel.shadowColor = [UIColor colorWithRed:255.0 green:255.0 blue:102.0 alpha:0.5];
    headerLabel.frame = CGRectMake(11, 1, 353.0, 20.0);
    headerLabel.text = [self.beatSectionTitles objectAtIndex:section];
    

    
    
    [customView addSubview:headerLabel];
    [customView addSubview:seeAllButton];
    
    return customView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
//  Beat *beat = self.beatsArray[indexPath.row];
//  cell.textLabel.text = beat.name;
    
    NSString *sectionTitle = [self.beatSectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionNames = [self.beats objectForKey:sectionTitle];
    NSDictionary *beat = [sectionNames objectAtIndex:indexPath.row];
    cell.textLabel.text = beat[@"display"];
    //cell.imageView.image = [UIImage imageNamed:[self getImageFilename:animal]];
    
  
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



@end
