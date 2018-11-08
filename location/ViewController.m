//
//  ViewController.m
//  location
//
//  Created by yutaozhao on 25/9/18.
//  Copyright © 2018年 yutaozhao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationmanager;//定位服务
    UILabel *lablel;
    NSString *currentCity;//当前城市
    NSString *latitudestr;//经度
    NSString *strlongitude;//纬度
    UIButton *btn;
}
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getLocation];
    [self initWithUI];
    
}

- (void)initWithUI{
    lablel = [[UILabel alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth, 200)];
    lablel.backgroundColor = [UIColor clearColor];
    lablel.textColor = [UIColor redColor];
    lablel.numberOfLines = 0;
    lablel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lablel];
    
    btn = [[UIButton alloc]initWithFrame:CGRectMake(40, kScreenHeight-100, kScreenWidth-80, 50)];
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor grayColor];
    
    [btn addTarget:self action:@selector(BtnClick) forControlEvents:UIControlEventTouchUpInside];
}
- (void)BtnClick{
    lablel.text = @"";
    [self getLocation];
}
#pragma mark 获取用户定位信息
-(void)getLocation
{
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationmanager = [[CLLocationManager alloc]init];
        locationmanager.delegate = self;
        [locationmanager requestAlwaysAuthorization];
        currentCity = [NSString new];
        [locationmanager requestWhenInUseAuthorization];
        
        //设置寻址精度
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        locationmanager.distanceFilter = 5.0;
        [locationmanager startUpdatingLocation];
    }
}



#pragma mark CoreLocation delegate (定位失败)
//定位失败后调用此代理方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"获取定位失败");
    //设置提示提醒用户打开定位服务
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"允许定位提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:nil];
    //
    //    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //    [alert addAction:okAction];
    //    [alert addAction:cancelAction];
    //    [self presentViewController:alert animated:YES completion:nil];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [locationmanager stopUpdatingHeading];
    //旧址
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    //打印当前的经度与纬度
    NSLog(@"得到经纬度:%f,%f",currentLocation.coordinate.latitude,currentLocation.coordinate.longitude);
//    location = [NSString stringWithFormat:@"(%f,%f)",currentLocation.coordinate.longitude,currentLocation.coordinate.latitude];
    //反地理编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            if (!currentCity) {
                currentCity = @"无法定位当前城市";
            }
            /*看需求定义一个全局变量来接收赋值*/
            NSLog(@"----%@",placeMark.country);//当前国家
            NSLog(@"%@",currentCity);//当前的城市
            NSLog(@"%@",placeMark.subLocality);//当前的位置
            NSLog(@"%@",placeMark.thoroughfare);//当前街道
            NSLog(@"%@",placeMark.name);//具体地址
            
            lablel.text = [NSString stringWithFormat:@" 国家: %@  \n城市:%@  \n 位置: %@   \n 街道: %@  \n 地址1: %@  \n ",placeMark.country,currentCity,placeMark.subLocality,placeMark.thoroughfare,placeMark.name];
            
        }
    }];
    
}
@end
