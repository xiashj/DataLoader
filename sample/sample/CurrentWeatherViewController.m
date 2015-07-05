//
//  CurrentWeatherViewController.m
//  sample
//
//  Created by Jason on 15/6/23.
//  Copyright (c) 2015年 Jason. All rights reserved.
//

#import "CurrentWeatherViewController.h"
#import "Weather.h"
#import "DataLoader.h"

typedef NS_ENUM(NSInteger, DataLoadStatus) {
    DataLoadStatusNone,
    DataLoadStatusInitial,
    DataLoadStatusRefresh,
    DataLoadStatusMore
};

@interface CurrentWeatherViewController ()

@property (strong, nonatomic) DataLoader *currentWeatherDataLoader;
@property (assign, nonatomic) DataLoadStatus dataLoadStatus;
@property (strong, nonatomic) Weather *currentWeather;

@end

@implementation CurrentWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.currentWeatherDataLoader = [self createCurrentWeatherDataLoader];
    [self.currentWeatherDataLoader startLoad];
    self.dataLoadStatus = DataLoadStatusInitial;
}

- (DataLoader *)createCurrentWeatherDataLoader
{
    __weak CurrentWeatherViewController *weakViewController = self;
    DataLoader *dataLoader = [DataLoader dataLoaderForCurrentWeatherWithCityName:@"Shanghai,cn" cachedDataHandler:NULL dataHandler:^(Weather *currentWeather, NSError *error) {
        if (currentWeather)
        {
            weakViewController.currentWeather = currentWeather;
            [weakViewController.tableView reloadData];
        }
        else
        {
            NSString *message;
            
            if ([error.domain isEqualToString:DataErrorDomain])
            {
                message = @"数据有误";
            }
            else
            {
                message = @"请求失败，请检查网络";
            }

            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
        weakViewController.currentWeatherDataLoader = nil;
        weakViewController.dataLoadStatus = DataLoadStatusNone;
    }];
    
    return dataLoader;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.currentWeather.main;
    cell.detailTextLabel.text = self.currentWeather.weatherDescription;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
