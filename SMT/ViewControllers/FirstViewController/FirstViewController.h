#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LocationListViewController.h"
#import "NewLog1ViewController.h"
#import "UIViewController+LoaderCategory.h"
#import "CameraViewController.h"



@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, CameraControllerDelegate>


+ (FirstViewController *)instance;

@end
