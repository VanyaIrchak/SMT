#import "CameraViewController.h"
#import "DataLoader.h"
#import "UIViewController+LoaderCategory.h"

@interface CameraViewController ()
{
    DataLoader * dataLoader;
}
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tabBarWidth;
@property (strong, nonatomic) IBOutlet UIButton *btnOpenGalery;
@property (strong, nonatomic) IBOutlet UIButton *btnSetAvatar;
@property (strong, nonatomic) IBOutlet UIButton *btnAddToGalery;


- (IBAction)actSelectPhoto:(id)sender;
- (IBAction)actSetAvatar:(id)sender;
- (IBAction)actAddGalery:(id)sender;

- (void)actTakePhoto;
@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataLoader = [DataLoader instance];
    [self AddActivityIndicator:[UIColor grayColor] forView:self.view];
    UIButton * btn = (UIButton *)[self.tabBar viewWithTag:3];
    [btn setBackgroundImage:[UIImage imageNamed:@"camera_icon_press.png"] forState:UIControlStateNormal];
    self.isCamera = YES;
    
    self.screenName = @"Camera screen";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.btnSetAvatar.userInteractionEnabled = NO;
    [self.btnSetAvatar setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.btnAddToGalery.userInteractionEnabled = NO;
    [self.btnAddToGalery setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.tabBarWidth.constant = self.view.frame.size.width;
    [self.view updateConstraintsIfNeeded];
    if (_isCamera) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
            UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                  message:@"Device has no camera"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
        
            [myAlertView show];
        
        } else {
            [self actTakePhoto];
        }
        _isCamera = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.image.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:^{
        self.btnSetAvatar.userInteractionEnabled = YES;
        [self.btnSetAvatar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnAddToGalery.userInteractionEnabled = YES;
        [self.btnAddToGalery setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isCamera = NO;
    }];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        self.btnSetAvatar.userInteractionEnabled = NO;
        [self.btnSetAvatar setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnAddToGalery.userInteractionEnabled = NO;
        [self.btnAddToGalery setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _isCamera = NO;
    }];
    
}

- (IBAction)actSelectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)actSetAvatar:(id)sender {
    if (self.image.image) {
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        [dataLoader setUserAvatar:self.image.image];
        
        dispatch_async(dispatch_get_main_queue(),^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error upload avatar");
                [self endLoader];
            } else {
                
                id<CameraControllerDelegate> delegate = self.delegate;
                if ([delegate respondsToSelector:@selector(newUserAvatar:)]) {
                    [delegate newUserAvatar:self.image.image];
                }
                [self endLoader];
            }
            
        });
    });
    }

}

- (IBAction)actAddGalery:(id)sender {
    if (self.image.image) {
    [self startLoader];
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        
        NSString * str_id = [dataLoader uploadPhoto:self.image.image];
        
        dispatch_async(dispatch_get_main_queue(),^(){
            
            if(!dataLoader.isCorrectRezult) {
                NSLog(@"Error upload avatar");
                [self endLoader];
            } else {
                //self.imgUser.image = image;
                [dataLoader setDescriptionWithPhotoID:[str_id intValue] andDescription:@"first comment"];
                [self endLoader];
            }
            
        });
    });
    }
}



- (void)actTakePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.view addSubview:picker.cameraOverlayView];
    //[self presentViewController:picker animated:YES completion:NULL];
}

-(void) setIsPresent:(BOOL)present
{
    isPresent = present;
    if (isPresent) {
        [((UIButton *)[self.tabBar viewWithTag:1]) setBackgroundImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:2]) setBackgroundImage:[UIImage imageNamed:@"global_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:3]) setBackgroundImage:[UIImage imageNamed:@"camera_icon_press.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:4]) setBackgroundImage:[UIImage imageNamed:@"note_icon.png"] forState:UIControlStateNormal];
        [((UIButton *)[self.tabBar viewWithTag:5]) setBackgroundImage:[UIImage imageNamed:@"st_icon.png"] forState:UIControlStateNormal];
    } else {
        [((UIButton *)[self.tabBar viewWithTag:3]) setBackgroundImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
    }
}



@end