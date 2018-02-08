//
//  ViewController.m
//  Pixomatic task
//
//  Created by Lilit Avetisyan on 2/7/18.
//  Copyright © 2018 Lil. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    IBOutlet UIView *captureView;
    IBOutlet UIImageView *captureImageView;
    UIImage *capturedImage;
    IBOutlet UILabel *lblEditPhoto;
    IBOutlet UILabel *lblChoosePhoto;
    IBOutlet UIButton *btnSave;
    IBOutlet UIButton *btnPhoto;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    lblChoosePhoto.hidden = NO;
    lblEditPhoto.hidden = YES;
    btnSave.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnTakePhoto:(id)sender {
    
    [self loadPhoto];
}
- (IBAction)btnSavePhoto:(id)sender {
    UIImageWriteToSavedPhotosAlbum([self imageWithView:captureView], nil, nil, nil);
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Thank you"
                                          message:@"Photo saved to your photo album"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}


- (void) loadPhoto {
    
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (UIImage *)imageWithView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0f);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

#pragma mark - UIImagePickerViewController Methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    capturedImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    [self addPhotoToView];
    lblChoosePhoto.hidden = YES;
    lblEditPhoto.hidden = NO;
    btnPhoto.hidden = YES;
    btnSave.hidden = NO;
    
    
}

-(void)addPhotoToView{
    UIImageView *imgNew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, captureImageView.frame.size.width, captureImageView.frame.size.height)];
    
    [imgNew sd_setIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [imgNew sd_setShowActivityIndicatorView:YES];
    imgNew.image = capturedImage;
    imgNew.contentMode = UIViewContentModeCenter;
    imgNew.contentMode = UIViewContentModeScaleAspectFit;
    imgNew.userInteractionEnabled = YES;
    imgNew.multipleTouchEnabled = YES;
//    imgNew.center = captureView.center;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [imgNew addGestureRecognizer:panGesture];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    pinchGesture.delegate = self;
    [imgNew addGestureRecognizer:pinchGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotate:)];
    rotationGesture.delegate = self;
    [imgNew addGestureRecognizer:rotationGesture];
    
    [captureView addSubview:imgNew];
    
    
}





#pragma mark - Guestures

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer {
    static CGPoint initialCenter;
  
    initialCenter = recognizer.view.center;
    CGPoint translation = [recognizer translationInView:captureView];
    
    
    recognizer.view.center = CGPointMake(initialCenter.x + translation.x,
                                         initialCenter.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:captureView];
    
    
    
}


- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (IBAction)handleRotate:(UIRotationGestureRecognizer *)recognizer {
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}



@end
