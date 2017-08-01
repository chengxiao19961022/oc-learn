ios学习笔记 -- 程潇

// 注意代码的执行顺序和刷新,注意头文件的包含

// 有时候是因为背景色所以看不到，先易后难。

// 当元素乱跑，界面不清时，考虑是否约束没加全

// 调用presentViewController  present方法适合用在呈现单独的页面，dissmiss后不会影响当前的堆栈
    [self presentViewController:(nonnull UIViewController *) animated:(BOOL) completion:^(void)completion];
// presentViewController退回
    [self dismissViewControllerAnimated:(BOOL) completion:^(void)completion]；

// pop到根目录下
    [self.navigationController popToRootViewControllerAnimated:YES];

// pop到指定目录
    [self.navigationController popToViewController:VC animated:YES]

// navigationcontroller push
    [self.navigationController pushViewController:rootVC animated:YES];

// 遍历所有根控制器的子控制器并做判断跳转
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[MyOrderViewController class]]) {
        //   pop到指定obj并有跳转动画
            [Utils setNavigationControllerPopWithAnimation:self timingFunction:KYNaviAnimationTimingFunctionEaseInEaseOut type:KYNaviAnimationTypeReveal subType:KYNaviAnimationDirectionDefault duration:0.38 target:obj];
            toMyORderVC = YES;
        }
    }];
// childview的使用方法
    //在ViewController 中添加其他UIViewController，currentVC是一个UIViewController变量，存储当前显示的viewcontroller
    FirstVC * first = [[FirstVC alloc] init];
    [self addChildViewController:first];
    //addChildViewController 会调用 [child willMoveToParentViewController:self] 方法，但是不会调用 didMoveToParentViewController:方法，官方建议显示调用
    [first didMoveToParentViewController:self];
    [first.view setFrame:CGRectMake(0, CGRectGetMaxY(myScrollView.frame), width, height-CGRectGetHeight(myScrollView.frame))];
    currentVC = first;
    [self.view addSubview:currentVC.view];
    //这里没有其他addSubview:方法了，就只有一个，而且可以切换视图，是不是很神奇？
    second = [[SecondVC alloc] init];
    [second.view setFrame:CGRectMake(0,CGRectGetMaxY(myScrollView.frame), width, height-CGRectGetHeight(myScrollView.frame))];


//  遍历所有navigationcontroller堆栈的控制器并做判断跳转，这些控制器确实存在于堆栈中
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[LoginViewController class]]) {
            [self.navigationController popToViewController:VC animated:YES]
        }
    }

// 添加跳转动画
    [current.navigationController.view.layer addAnimation:animation forKey:nil];

// 改变并切换到根目录
    wyTabBarController *rootVC = [[wyTabBarController alloc] init];
    AppDelegate *app = KappDelegate;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    app.window.rootViewController = nav;

// 发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GuidanceToAPP" object:@""];

// 接收通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginApp:) name:@"GuidanceToAPP" object:nil];
    -(void)loginApp:(NSNotification*)aNotification{
        [aNotification object];
    }

// 注销通知
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"GuidanceToApp" object:nil];

// 初始化并定义frame大小
    self.mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];

    CGRect newFrame = self.headerView.frame;
    newFrame.size.height = newFrame.size.height + 36 + 38;
    self.headerView.frame = newFrame;
    [self.tbView beginUpdates];
    [self.tbView setTableHeaderView:self.headerView];
    [self.tbView endUpdates];


// 添加约束
http://www.jianshu.com/p/yuCytg
http://www.cocoachina.com/ios/20160616/16732.html
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.mytableview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rdv_tabBarController.navigationController.navigationBar attribute:NSLayoutAttributeTop multiplier:1.0 constant:self.rdv_tabBarController.navigationController.navigationBar.height];
    [self.view addConstraint:topConstraint];
    __block MASConstraint *constraintNoOrder = nil;
    __block MASConstraint *constraintHasOrder = nil;
    [ViewArr.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.mas_equalTo(20);
    //make.height.mas_equalTo(325);
    int rm_width = [UIScreen mainScreen].bounds.size.width/2 - 25;
    make.height.mas_equalTo(rm_width * 2);
    //make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width/2 - 20);
    constraintNoOrder = make.top.mas_equalTo(20).with.priority(999);
    constraintHasOrder = make.top.equalTo(orderView.mas_bottom).with.offset(20);
    make.right.mas_equalTo(-20);
    }];
    [constraintNoOrder uninstall];
    [constraintHasOrder uninstall];

    self.gifImageView.center = CGPointMake(self.width / 2, self.height / 2 + 130);      //将该view的中心放置在所示位置

// 判断数据类型
    [obj isKindOfClass:[MyOrderViewController class]]

// 设置UIView的背景
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"jbbg"]];
    [naviView.bgView setBackgroundColor:bgColor];

// 隐藏自动刷新状态栏
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;

    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;

// 解决标题栏上移的问题
    定义静态属性：
        BOOL _wasKeyboardManagerEnabled;
    在viewDidappear里：
        _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
        [[IQKeyboardManager sharedManager] setEnable:NO];
    在viewWillDisappear里：
        [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];

// 延时操作
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [keyWindow makeToast:@"您还未登录，请先登录！"];
});

//为了避免界面在处理耗时的操作时卡死，比如读取网络数据，IO,数据库读写等，
//我们会在另外一个线程中处理这些操作，然后通知主线程更新界面。
//详细：http://zhangmingwei.iteye.com/blog/1748431
//关于多线程：http://www.jianshu.com/p/0b0d9b1f1f19
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // 下载图片
        NSURL * url = [NSURL URLWithString:@"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"];
        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc]initWithData:data];
        if (data != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
    // 返回主线程时要做的操作
                self.imageView.image = image;
            });
        }
    });
可理解为给当前线程派发异步任务，而不是新建线程。新建线程要dispatch_queue_create。

//dispatch_group_async的使用
dispatch_group_async可以实现监听一组任务是否完成，完成后得到通知执行其他的操作。这个方法很有用，比如你执行三个下载任务，当三个任务都下载完成后你才通知界面说完成的了。下面是一段例子代码：
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, queue, ^{
    [NSThread sleepForTimeInterval:1];
    NSLog(@"group1");
});
dispatch_group_async(group, queue, ^{
    [NSThread sleepForTimeInterval:2];
    NSLog(@"group2");
});
dispatch_group_async(group, queue, ^{
    [NSThread sleepForTimeInterval:3];
    NSLog(@"group3");
});
dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    NSLog(@"updateUi");
});
dispatch_release(group);
dispatch_group_async是异步的方法，运行后可以看到打印结果：


2012-09-25 16:04:16.737 gcdTest[43328:11303] group1
2012-09-25 16:04:17.738 gcdTest[43328:12a1b] group2
2012-09-25 16:04:18.738 gcdTest[43328:13003] group3
2012-09-25 16:04:18.739 gcdTest[43328:f803] updateUi

每个一秒打印一个，当第三个任务执行后，upadteUi被打印。

//dispatch_barrier_async的使用
dispatch_barrier_async是在前面的任务执行结束后它才执行，而且它后面的任务等它执行完成之后才会执行

例子代码如下：



dispatch_queue_t queue = dispatch_queue_create("gcdtest.rongfzh.yc", DISPATCH_QUEUE_CONCURRENT);并行队列
dispatch_async(queue, ^{
    [NSThread sleepForTimeInterval:2];
    NSLog(@"dispatch_async1");
});
dispatch_async(queue, ^{
    [NSThread sleepForTimeInterval:4];
    NSLog(@"dispatch_async2");
});
dispatch_barrier_async(queue, ^{
    NSLog(@"dispatch_barrier_async");
    [NSThread sleepForTimeInterval:4];
    
});
dispatch_async(queue, ^{
    [NSThread sleepForTimeInterval:1];
    NSLog(@"dispatch_async3");
});

打印结果：


2012-09-25 16:20:33.967 gcdTest[45547:11203] dispatch_async1

2012-09-25 16:20:35.967 gcdTest[45547:11303] dispatch_async2

2012-09-25 16:20:35.967 gcdTest[45547:11303] dispatch_barrier_async

2012-09-25 16:20:40.970 gcdTest[45547:11303] dispatch_async3

请注意执行的时间，可以看到执行的顺序如上所述。

//dispatch_apply
执行某个代码片段N次。
dispatch_apply(5, globalQ, ^(size_t index) {
    // 执行5次
    
});

// NSBlockOperation
1.任务一：下载图片
NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"下载图片 - %@", [NSThread currentThread]);
    [NSThread sleepForTimeInterval:1.0];
}];
2.任务二：打水印
NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"打水印   - %@", [NSThread currentThread]);
    [NSThread sleepForTimeInterval:1.0];
}];
3.任务三：上传图片
NSBlockOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
    NSLog(@"上传图片 - %@", [NSThread currentThread]);
    [NSThread sleepForTimeInterval:1.0];
}];
4.设置依赖
[operation2 addDependency:operation1];      //任务二依赖任务一
[operation3 addDependency:operation2];      //任务三依赖任务二
5.创建队列并加入任务
NSOperationQueue *queue = [[NSOperationQueue alloc] init];
[queue addOperations:@[operation3, operation2, operation1] waitUntilFinished:NO];

// block的回掉学习，附近的车位，__block学习，主页

// cocoapods相关
    http://www.jianshu.com/p/b64b4fd08d3c
    1.安装：
    sudo gem update --system
    sudo gem install  cocoapods
    （增强版：
        which pod 得到路径 一般是usr/local/bin
        sudo gem install -n <路径> cocoapods
    ）
    pod setup
    2.卸载
    which pod 得到路径
    sudo rm -rf <路径>
    3.使用
    pod search 第三方库

    文本打开podfile，然后加上pod 第三方库，然后
    pod install

// 刷新的第三方
    MJRefresh 可执行上下的刷新，不能执行左右的刷新
    注意加刷新的位置，一般是放在最后。





