//
//  HNAMapController.m
//  MedicalNet
//
//  Created by gengliming on 15/12/14.
//  Copyright © 2015年 HaiHang. All rights reserved.
//

#import "HNAMapController.h"
#import <MapKit/MapKit.h>
#import "HNAAnnotation.h"

@interface HNAMapController() <MKMapViewDelegate> {
    CLPlacemark *_toPm;
}
- (IBAction)back:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *clmgr;
@property (strong, nonatomic) CLGeocoder *geocoder;
@end

@implementation HNAMapController

- (CLLocationManager *)clmgr{
    if (_clmgr == nil) {
        _clmgr = [[CLLocationManager alloc] init];
    }
    return _clmgr;
}

- (CLGeocoder *)geocoder{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 0.提示用户是否允许使用其位置
    if ([self.clmgr respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.clmgr requestWhenInUseAuthorization];
    }
    
    // 1.地图类型
    [self.mapView setMapType : MKMapTypeStandard];
    
    // 2.用户跟踪位置
    [self.mapView setUserTrackingMode : MKUserTrackingModeFollow];
    
    // 3.设置代理
    self.mapView.delegate = self;
    
    NSString *addr1 = @"天安门广场";
    NSString *addr2 = @"房山";
    
    [self.geocoder geocodeAddressString:addr1 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error)  return;
        
        CLPlacemark *fromPm = [placemarks firstObject];
        
        [self.geocoder geocodeAddressString:addr2 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) return;
            
            CLPlacemark *toPm = [placemarks firstObject];
            
            [self addLineFrom:fromPm to:toPm];
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil;
    [self.mapView removeFromSuperview];
    self.mapView = nil;
}

- (void)addLineFrom:(CLPlacemark *)fromPm to:(CLPlacemark *)toPm{
    HNAAnnotation *fromAnno = [[HNAAnnotation alloc] init];
    fromAnno.coordinate = fromPm.location.coordinate;
    fromAnno.title = fromPm.name;
    [self.mapView addAnnotation:fromAnno];
    
    HNAAnnotation *toAnno = [[HNAAnnotation alloc] init];
    toAnno.coordinate = toPm.location.coordinate;
    toAnno.title = toPm.name;
    [self.mapView addAnnotation:toAnno];
    
    // 2.查找路线
    
    // 方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    // 设置起点
    MKPlacemark *sourcePm = [[MKPlacemark alloc] initWithPlacemark:fromPm];
    request.source = [[MKMapItem alloc] initWithPlacemark:sourcePm];
    
    // 设置终点
    MKPlacemark *destinationPm = [[MKPlacemark alloc] initWithPlacemark:toPm];
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationPm];
    
    // 方向对象
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 计算路线
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse * _Nullable response, NSError * _Nullable error) {
        HNALog(@"%ld",(long)response.routes.count);
        // 遍历所有的路线
        for (MKRoute *route in response.routes) {
            [self.mapView addOverlay:route.polyline];
        }
    }];
}

#pragma mark - mapView代理
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    userLocation.title = @"天朝帝都";
    userLocation.subtitle = @"是个美丽的国度";
    
    CLLocationCoordinate2D center = userLocation.location.coordinate;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.001f, 0.001f);
    MKCoordinateRegion region = {center,span};
    
    [mapView setRegion:region];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    return renderer;
}

- (IBAction)back:(UIButton *)sender {
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    HNALog(@"%s",__FUNCTION__);
}

@end
