//
//  PhotoVideoViewController.h
//  SMT
//
//  Created by Mac on 5/6/14.
//  Copyright (c) 2014 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCell.h"

@interface PhotoVideoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSMutableArray * list;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionTable;
@property (strong, nonatomic) NSArray *list;

- (IBAction)actTakePhoto:(id)sender;
- (IBAction)actChooseExisting:(id)sender;

@end