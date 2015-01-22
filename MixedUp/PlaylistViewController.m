//
//  PlaylistViewController.m
//  MixedUp
//
//  Created by Brian Mendez on 12/16/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

#import "PlaylistViewController.h"


@interface PlaylistViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PlaylistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlistArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.textLabel.text = [self.playlistArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
