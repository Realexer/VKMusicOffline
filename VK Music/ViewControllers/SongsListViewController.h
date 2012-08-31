//
//  SongsListViewController.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/27/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKAPIClient.h"

@interface SongsListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) VKAPIClient *apiClient;
@property (nonatomic, retain) IBOutlet UITableView *songsTable;
@property (nonatomic, retain) NSArray *songsList;

@end
