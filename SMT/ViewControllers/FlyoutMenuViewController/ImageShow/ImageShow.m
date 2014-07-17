#import "ImageShow.h"
#import "UIViewController+LoaderCategory.h"

#define DOWNLOAD_IMAGE_SUCCES @"image is download"
#define ActiveTag 12321

@implementation ImageShow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIActivityIndicatorView * a = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.contentView addSubview:a];
        
        //CGPoint point = self.center;
        //point.y = self.contentView.frame.size.height/2 + 25;
        a.center = self.center;
        
        a.color = [UIColor blackColor];
        a.hidesWhenStopped = YES;
        a.tag = ActiveTag;
    }
    return self;
}

- (void)setImageWithURL:(NSURL *) url andImageID:(NSString *)photoID descriptions:(NSString *)str andUserName:(NSString *)name
{
    dispatch_queue_t newQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(newQueue, ^(){
        UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            [self setPhotoDescriptions:str andUserName:name andImage:image];
            //self.img.image = image;
            [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOAD_IMAGE_SUCCES object:self userInfo:@{photoID: image}];
        });
    });

}

- (void)setPhotoDescriptions:(NSString *)str andUserName:(NSString *)name andImage:(UIImage *)image
{
    self.lbName.text = name;
    self.img.image = image;
    if (!str) {
        //self.heigthImage.constant = 0.0;
        //[self updateConstraints];
    } else {
        //self.heigthImage.constant = 17.0;
        //[self updateConstraints];
        self.lbDescriptions.text = str;
    }
}


- (void)setImage:(UIImage *)image
{
    self.img.contentMode = UIViewContentModeScaleToFill;
    //self.heigthImage.constant = 0.0;
    //[self updateConstraints];
    self.img.image = image;
}


- (void)startLaderInCell
{
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.contentView viewWithTag:ActiveTag];
    [a startAnimating];
}


- (void)stopLoaderInCell
{
    UIActivityIndicatorView * a = (UIActivityIndicatorView* )[self.contentView viewWithTag:ActiveTag];
    [a stopAnimating];
}


- (void)prepareForReuse
{
    self.lbName.text = @"";
    self.img.image = [UIImage imageNamed:@"placeholderImage.png"];
}


@end
