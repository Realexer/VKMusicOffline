//
//  SynchronizationViewController.h
//  VK Music
//
//  Created by Vitaliy Volokh on 8/28/12.
//  Copyright (c) 2012 Softheme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileDownloader.h"

@interface SynchronizationViewController : UIViewController<FileDownloaderDelegate, UITableViewDelegate, UITableViewDataSource> 
{
    NSMutableArray *downloadingManagers;
}

@property (nonatomic, retain) IBOutlet UITableView *songsTable;
@property (nonatomic, retain) NSArray *musicList;

@end
