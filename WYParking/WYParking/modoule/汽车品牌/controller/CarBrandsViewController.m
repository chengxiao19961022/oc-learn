//
//  CarBrandsViewController.m
//  WYParking
//
//  Created by glavesoft on 17/3/11.
//  Copyright © 2017年 glavesoft. All rights reserved.
//

#import "CarBrandsViewController.h"

#import "CarBrandsCell.h"
#define CARBRANDSCELL @"CarBrandsCell"

@interface CarBrandsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    __weak IBOutlet UITableView *mTableView;
    
    __weak IBOutlet UIView *mSearchBgView;
    __weak IBOutlet UITextField *mTextField;
    
    NSMutableArray *mBrandsTitleArr;//品牌数据源
    NSMutableDictionary *mGroupDict;//排好序品牌信息
    NSMutableArray *mIndexArray;//tableview索引

    NSMutableDictionary *mInitialDict;//存储最初
    NSMutableArray *mInitialArray;
    BOOL INITIAARR;//数组是否最初
    BOOL INITIADICT;//字典是否最初
    
}

@end

@implementation CarBrandsViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    mBrandsTitleArr = [NSMutableArray array];
    mGroupDict = [NSMutableDictionary dictionary];
    mIndexArray = [NSMutableArray array];
    
    [mInitialDict removeAllObjects];
    [mInitialArray removeAllObjects];
    INITIAARR = YES;
    INITIADICT = YES;
    
    [self initialization];
    [self getCarInfo];
}

-(void)initialization{
    
    mSearchBgView.backgroundColor = [UIColor whiteColor];
    mSearchBgView.layer.cornerRadius = mSearchBgView.frame.size.height/2;
    mSearchBgView.layer.borderWidth = 1.0f;
    mSearchBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    mSearchBgView.layer.masksToBounds = YES;
    
    mTextField.delegate = self;
    [mTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    mTableView.rowHeight = UITableViewAutomaticDimension;
    mTableView.estimatedRowHeight = 100.0f;
    [mTableView registerNib:[UINib nibWithNibName:CARBRANDSCELL bundle:nil] forCellReuseIdentifier:CARBRANDSCELL];
    
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    
    NSMutableArray *allArr = [NSMutableArray array];
    for (NSString *str in mInitialArray) {
        NSMutableArray *arr = [mInitialDict objectForKey:str];
        for (NSDictionary *book in arr) {
            [allArr addObject:book];
        }
    }
    NSMutableArray *numArr = [NSMutableArray array];
    
    for (NSDictionary *book in allArr) {
        if ([book[@"name"] rangeOfString:textField.text].location != NSNotFound||[book[@"name"] rangeOfString:textField.text].location != NSNotFound) {
            [numArr addObject:book];
        }
    }
    
    [mBrandsTitleArr removeAllObjects];
    [mGroupDict removeAllObjects];
    [mIndexArray removeAllObjects];
    
    
    [mBrandsTitleArr addObjectsFromArray:numArr];
    [self setRuleGroup];
    [mTableView reloadData];
    
    
    return YES;
}

- (void) textFieldDidChange:(UITextField *) textField{
    NSLog(@"text=======%@",textField.text);
    
    
    NSMutableArray *allArr = [NSMutableArray array];
    for (NSString *str in mInitialArray) {
        NSMutableArray *arr = [mInitialDict objectForKey:str];
        for (NSDictionary *book in arr) {
            [allArr addObject:book];
        }
    }
    NSMutableArray *numArr = [NSMutableArray array];
    
    
    if (![textField.text isEqualToString:@""]) {
        for (NSDictionary *book in allArr) {
            if ([book[@"name"] rangeOfString:textField.text].location != NSNotFound||[book[@"name"] rangeOfString:textField.text].location != NSNotFound) {
                [numArr addObject:book];
            }
        }
        
        [mBrandsTitleArr removeAllObjects];
        [mGroupDict removeAllObjects];
        [mIndexArray removeAllObjects];
        
        
        [mBrandsTitleArr addObjectsFromArray:numArr];
        [self setRuleGroup];
        [mTableView reloadData];
        
    }else{
        
//        [numArr addObjectsFromArray:allArr];
    
        [mBrandsTitleArr removeAllObjects];
        [mGroupDict removeAllObjects];
        [mIndexArray removeAllObjects];
        
        
//        [mBrandsTitleArr addObjectsFromArray:numArr];
        [mBrandsTitleArr addObjectsFromArray:allArr];
        [self setRuleGroup];
        [mTableView reloadData];
        
    }
    
    
}


#pragma mark 取消按钮
- (IBAction)cancelBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - 获取车数据
-(void)getCarInfo{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"获取中";
    
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@user/brandlist", KSERVERADDRESS];
    
    [wyApiManager sendApi:urlString parameters:nil success:^(id obj) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        NSMutableDictionary *paramsDict=[NSJSONSerialization  JSONObjectWithData:obj options:0 error:nil];
        
        if ([paramsDict[@"status"] isEqualToString:@"200"]) {
            
            NSArray *arr = paramsDict[@"data"];
            
            [mBrandsTitleArr addObjectsFromArray:arr];
            
            [self setRuleGroup];
            [mTableView reloadData];

        }else if([paramsDict[@"status"] isEqualToString:@"104"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Kloginexpired" object:nil];
            
        }else{
            
            [self.view makeToast:paramsDict[@"message"]];
        }
        
    } failuer:^(NSError *error) {
        [self.view makeToast:@"请检查网络"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

#pragma mark 对品牌数据源排序
-(void)setRuleGroup{
    
    NSMutableArray *nameArr = [NSMutableArray array];
    for (NSDictionary * brandDict in mBrandsTitleArr) {
        
        NSString * name = [NSString stringWithFormat:@"%@",brandDict[@"name"]];
        
        if ([name isEqualToString:@""]) {
            name = @"#";
        }
        
        [nameArr addObject:name];
        
    }
    //中文换成拼音后的数组
    NSMutableArray *pinyinArr = [NSMutableArray array];
    for (NSString *str in nameArr) {
        NSString *newStr = [self transform:str];
        [pinyinArr addObject:newStr];
        
    }
    //排序后的数组
    NSArray *lastArr = [NSArray arrayWithArray:[self dataArrayUsingComparator:pinyinArr]];
    
    //取出首字母
    NSMutableArray *firstCharArr = [NSMutableArray array];
    for (NSString *str in lastArr) {
        NSString *firstChar = [str substringToIndex:1];
        [firstCharArr addObject:firstChar];
    }
    
    
    
    //去除相同元素
    NSString *str = [NSString string];
    for (str in firstCharArr) {
        
        char ch = [str characterAtIndex:0];
        if (!((ch >= 65 && ch <= 106) || (ch >= 97 && ch <= 122)))
        {
            // 非字母
            str = @"#";
        }
        
        if (![mIndexArray containsObject:str]) {
            
            [mIndexArray addObject:str];
        }
        
    }
    
    //如果有＃，则放在最后
    for (NSString *str1 in mIndexArray) {
        if ([str1 isEqualToString: @"#"]) {
            [mIndexArray removeObject:str1];
            [mIndexArray addObject:str1];
            break;
        }
    }
    
    if (INITIAARR) {
        mInitialArray = [NSMutableArray arrayWithArray:mIndexArray];
        INITIAARR = NO;
    }
    
    //品牌字典
    for (NSDictionary * brandDict in mBrandsTitleArr) {
        mGroupDict = [self dataDealWithMobileContactsModel:brandDict mobileContactsDictionary:mGroupDict];
        
    }
    
    
    if (INITIADICT) {
        mInitialDict  = [NSMutableDictionary dictionaryWithDictionary:mGroupDict];
        INITIADICT = NO;
        
    }
    
    NSLog(@"numberGroup===%li",mGroupDict.count);
    
}



//中文转拼音
- (NSString *)transform:(NSString *)chinese
{
    if ([chinese isEqualToString:@""]) {
        chinese = @"#";
    }
    
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    
    return [pinyin uppercaseString];
    
}



- (NSMutableDictionary *)dataDealWithMobileContactsModel:(NSDictionary *)brandDict mobileContactsDictionary:(NSMutableDictionary *)mobileContactsDictionary
{
    // 截取第一个首字母
    NSString *keyString = [self transform:[NSString stringWithFormat:@"%@",brandDict[@"name"]]];
    if (keyString.length != 0)
    {
        NSString *keyTemp = [keyString substringToIndex:1];
        
        // 判断 字符是不是字母  不是把key 设置成#
        // 转换成字符
        char ch = [keyTemp characterAtIndex:0];
        if (!((ch >= 65 && ch <= 106) || (ch >= 97 && ch <= 122)))
        {
            // 非字母
            keyTemp = @"#";
            
        }
        
        NSArray *keyAll = [mobileContactsDictionary allKeys];
        
        if ([keyAll containsObject:keyTemp])
        {
            [[mobileContactsDictionary objectForKey:keyTemp] addObject:brandDict];
        }
        else
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObject:brandDict];
            [mobileContactsDictionary setObject:tempArray forKey:keyTemp];
        }
    }else{
        NSLog(@"============");
    }
    
    return mobileContactsDictionary;
}



//按字母排序（传入字母）
- (NSArray *)dataArrayUsingComparator:(NSArray *)array
{
    
    if ([array containsObject:@"#"]) // 数组中包含#
    {
        NSMutableArray *arrayTemp = [[NSMutableArray alloc] initWithArray:array];
        [arrayTemp removeObject:@"#"];
        
        NSArray *arrayTemp1 = [[NSArray alloc] initWithArray:arrayTemp];
        
        NSArray *arrayTemp2 = [arrayTemp1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
        
        [arrayTemp removeAllObjects];
        [arrayTemp addObjectsFromArray:arrayTemp2];
        [arrayTemp addObject:@"#"];
        
        NSArray *resultArray = [[NSArray alloc] initWithArray:arrayTemp];
        return resultArray;
    }
    else
    {
        return  [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            return [obj1 compare:obj2 options:NSNumericSearch];
        }];
    }
}


#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return mGroupDict.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [mGroupDict objectForKey:mIndexArray[section]];
    return arr.count;
    
}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return mIndexArray[section];
   
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return mIndexArray;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarBrandsCell *cell = [tableView dequeueReusableCellWithIdentifier:CARBRANDSCELL];
    
    NSMutableArray *arr = [mGroupDict objectForKey:mIndexArray[indexPath.section]];
    NSDictionary *dict = arr[indexPath.row];
    
    [cell.brandImgView setImageWithURL:[NSURL URLWithString:dict[@"logo"]] placeholder:KPlaceHolderImg];
    cell.brandNameLab.text = dict[@"name"];
    return cell;
}


#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSMutableArray *arr = [mGroupDict objectForKey:mIndexArray[indexPath.section]];
    NSDictionary *dict = arr[indexPath.row];
    NSString *brandId = dict[@"brand_id"];
    [self.delegate chooseCarBrandsId:brandId brandName:dict[@"name"]];
    
    [self.navigationController popViewControllerAnimated:YES];

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
