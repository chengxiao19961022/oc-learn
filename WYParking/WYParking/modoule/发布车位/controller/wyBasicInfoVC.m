//
//  wyBasicInfoVC.m
//  TheGenericVersion
//
//  Created by glavesoft on 17/1/6.
//  Copyright © 2017年 李杰. All rights reserved.
//

#import "wyBasicInfoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "wyParkInfoSettingVC.h"
#import "PresentLocationViewController.h"


@interface wyBasicInfoVC ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
- (IBAction)btnCameraClick:(id)sender;
- (IBAction)btnNextClick:(id)sender;
- (IBAction)btnPickAddressClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *TFDetailAddress;
@property (weak, nonatomic) IBOutlet UITextField *lab_park_title;

@property (weak, nonatomic) IBOutlet UITextField *lab_address_Remark; 
@property (copy , nonatomic) NSString *lat; //详细地址的经纬度
@property (weak, nonatomic) IBOutlet UILabel *labAddPic;

@property(copy , nonatomic) NSString *lnt; //详细地址的经纬度

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCheWei;
@property (copy , nonatomic) NSString *imageUrl;
@property (assign , nonatomic) BOOL isEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (copy , nonatomic) NSString *park_id;


- (IBAction)btnClickClick:(id)sender;

@end

@implementation wyBasicInfoVC
//@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.push = [[WYModelPush alloc] init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.TFDetailAddress.userInteractionEnabled = NO;
//    self.view.layer.contents = (id)KbackGroundImage.CGImage;
    self.btnCamera.layer.cornerRadius = 44.0f;
    self.btnCamera.layer.masksToBounds = YES;
    __weak typeof(self) weakSelf = self;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(254, 255, 255, 1)] forBarMetrics:UIBarMetricsDefault]; //设置为白色
    self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"back3"] style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    if (self.isEdit) {
        self.title = @"修改基本信息";
        [self.btnNext setTitle:@"提交" forState:UIControlStateNormal];
    }else{
        self.title = @"设置基本信息";
    }
}

- (void)renderWithIFFix:(BOOL)flag park_id:(NSString *)park_id{
    self.isEdit = flag;
    self.park_id = park_id;
}





#pragma mark - 选择照片
- (void)cameraAction{
    
    UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取",nil];
    //    actionSheet.tag=1000;
    [actionSheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.view endEditing:YES];
    if (buttonIndex == 0) {
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            [self.view makeToast:@"请到设置中允许车位分享使用相机"];
            return;
        }
        
        [self addCarema];
        
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
    
}



#pragma mark - 点击跳转选择地址页面
/**
 点击跳转选择地址页面
 */
- (void)jumpToChooseAddressVC{
    [self.TFDetailAddress resignFirstResponder];
    [self.lab_park_title resignFirstResponder];
    
    PresentLocationViewController * locationVc = [[PresentLocationViewController alloc]init];
    
    __weak typeof(PresentLocationViewController)*weakLocationVc = locationVc;
    __weak typeof(self) weakSelf = self;
    [locationVc setSelectAddressCompleteBlock:^{
        
        if (weakLocationVc.selectedAddress.length == 0) {
            return;
        }
        NSLog(@"%@ %@ %@",weakLocationVc.selectedAddress,weakLocationVc.selectedLatitude,weakLocationVc.selectedLongitude);
        weakSelf.TFDetailAddress.text = weakLocationVc.selectedAddress;
        weakSelf.lnt = weakLocationVc.selectedLongitude;
        weakSelf.lat = weakLocationVc.selectedLatitude;
        
#pragma mark - 刷接口 ， 看地址是否重复
        NSString *urlString = [[NSString alloc] initWithFormat:@"%@parkspot/compare", KSERVERADDRESS];
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        [paramsDict setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
        [paramsDict setObject:weakSelf.TFDetailAddress.text forKey:@"address"];
        [paramsDict setObject:weakSelf.park_id?:@"" forKey:@"park_id"];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeIndeterminate;
        [wyApiManager sendApi:urlString parameters:paramsDict success:^(id obj) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableDictionary *tempDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
            NSLog(@"%@",paramsDict);
            if ([tempDict[@"status"] isEqualToString:@"200"]) {
            }else if ([tempDict[@"status"] isEqualToString:@"101"]){
                [MBProgressHUD showError:@"此地址已发布车位"];
                weakSelf.TFDetailAddress.text = @"";
            }
            
        } failuer:^(NSError *error) {
            [self.view makeToast:@"请检查网络"];
        }];
        
        
        
    }];
    
    [self.navigationController pushViewController:locationVc animated:YES];
}


#pragma mark - 相册
-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{
        }];
    }
}



#pragma mark - 相机
-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的设备没有相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

/**
 点击照相机

 @param sender
 */
- (IBAction)btnCameraClick:(id)sender {
    
    [self cameraAction];
    
}


/**
 点击下一步

 @param sender
 */
- (IBAction)btnNextClick:(id)sender {
    if (self.lab_park_title.text.length == 0||self.TFDetailAddress.text.length == 0 || self.lat.length == 0 ||self.imageUrl.length == 0) {
        [self.view makeToast:@"信息不完善"];
        return;
    }
    if (self.lab_park_title.text.length > 12) {
        [self.view makeToast:@"车位标题长度不能超过12个字"];
        return;
    }
    
    self.push.token = [wyLogInCenter shareInstance].sessionInfo.token;
    self.push.park_title = self.lab_park_title.text;
    self.push.address = self.TFDetailAddress.text;
    self.push.lat = self.lat;
    self.push.lnt = self.lnt;
    if (self.lab_address_Remark.text.length > 0) {
        self.push.addr_note = self.lab_address_Remark.text;
    }
   
    if ([self.btnNext.titleLabel.text isEqualToString:@"提交"]) {
         NSDictionary *dic = self.push.mj_keyValues;
        [self postDataWithDictionary:dic.mutableCopy];
    }else{
        wyParkInfoSettingVC *vc = wyParkInfoSettingVC.new;
        vc.push = self.push;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
    

}



- (void)postDataWithDictionary:(NSMutableDictionary *)dic{
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSString * urlString = [[NSString alloc] initWithFormat:@"%@parkspot3/parkspotinfo", KSERVERADDRESS];
    
    [dic setObject:[wyLogInCenter shareInstance].sessionInfo.token forKey:@"token"];
    [dic setObject:self.park_id forKey:@"park_id"];
    [wyApiManager sendApi:urlString parameters:dic success:^(id obj) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if([paramsDict[@"status"] isEqualToString:@"104"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
        }
        else
        {
            [self.view makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}



/**
 点击跳转选择地址页面

 @param sender
 */
- (IBAction)btnPickAddressClick:(id)sender {
    [self jumpToChooseAddressVC];
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 图片存到本地
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //    self.locationImgView.hidden = NO;
    //    self.locationImgView.image=editImage;
    //
    //    self.locationImgView.userInteractionEnabled = YES;
    //    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSingleTap:)];
    //    [self.locationImgView addGestureRecognizer:singleTap];
    
    
    // 把头像图片存到本地
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"locationImgaa.jpg"]];   // 保存文件的名称
    NSData *imageData = UIImageJPEGRepresentation(editImage, 0.5);
    [imageData writeToFile:filePath atomically:YES];
    
    [self uploadPic];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

- (void)uploadPic{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@user/updatelogo", KSERVERADDRESS];
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];; //path数组里貌似只有一个元素
    NSString *filestr = @"/locationImgaa.jpg";
    NSString *newstr = [documentsDirectory stringByAppendingString:filestr];
    NSData *dd = [NSData dataWithContentsOfFile:newstr];
    
    
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        
        [formData appendPartWithFileData:dd name:@"logo" fileName:[NSString stringWithFormat:@"%@.jpg",fileName] mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        ;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary* paramsDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSString *status=[NSString stringWithFormat:@"%@",paramsDict[@"status"]];
        
        if ([status isEqualToString:@"200"]) {
            
            self.imageUrl = paramsDict[@"data"][@"logo"];
            [self.imageViewCheWei setImageWithURL:[NSURL URLWithString:self.imageUrl] options:YYWebImageOptionShowNetworkActivity];
            
            [self.btnCamera setBackgroundImage:UIImage.new forState:UIControlStateNormal];
            self.labAddPic.hidden = YES;
            self.push.pic = self.imageUrl;
        }else
        {
            [self.view makeToast:paramsDict[@"message"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"上传失败"];
    }];
    

}




@end
