//
//  MapViewController.m
//  GeoScan-iOS
//
//  Created by Martin Kuvandzhiev on 5/17/16.
//  Copyright © 2016 Rapid Development Crew. All rights reserved.
//

#import "MapViewController.h"
#import "DatabaseInformation.h"

@interface MapViewController ()
{
    DatabaseInformation * database;
    MKUserLocation * myLocation;
}

@property (strong, nonatomic) CLLocationManager * locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.mapView.delegate = self;
    self.mapView.showsScale = YES;
    self.mapView.showsCompass = YES;
    database = [DatabaseInformation sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationsUpdatedNotificationHandler:) name:LOCATIONDATA_UPDATE object:nil];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [database updateLocationsData];
    
    UIBarButtonItem * findMeButton = [[UIBarButtonItem alloc] initWithTitle:@"Find me" style:UIBarButtonItemStylePlain target:self action:@selector(findMeButtonTapped:)];
    self.parentViewController.navigationItem.rightBarButtonItem = findMeButton;
   
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.parentViewController.navigationItem.rightBarButtonItem = nil
    ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
//        NSLog(@"latitude %+.6f, longitude %+.6f\n",
//              location.coordinate.latitude,
//              location.coordinate.longitude);
    }
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    myLocation = userLocation;
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    __block MKAnnotationView * blockAnnotationView = view;
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Navigation" message:@"Please select type of navigation to point" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * walkingOption = [UIAlertAction actionWithTitle:@"Walking"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self initiateNavigationTo:blockAnnotationView walking:YES];
                                                           }];
    UIAlertAction * drivingOption = [UIAlertAction actionWithTitle:@"Driving"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self initiateNavigationTo:blockAnnotationView walking:NO];
                                                           }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                          }];

    [alertController addAction:walkingOption];
    [alertController addAction:drivingOption];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:^{
    }];

    
}

- (void) initiateNavigationTo: (MKAnnotationView *) annotation walking: (BOOL) walking
{
    Class mapItemClass = [MKMapItem class];
    if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
    {
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:annotation.annotation.coordinate
                                                       addressDictionary:nil];
        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
        [mapItem setName:annotation.annotation.title];
        
        NSDictionary *launchOptions;
        if(walking == YES)
        {
            launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking};
        }
        else
        {
            launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        }
        
        
        // Get the "Current User Location" MKMapItem
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];
        // Pass the current location and destination map items to the Maps app
        // Set the direction mode in the launchOptions dictionary
        [MKMapItem openMapsWithItems:@[currentLocationMapItem, mapItem]
                       launchOptions:launchOptions];
    }
}


- (void) addPointsToMap
{
    for(NSDictionary * aDictionary in database.locations)
    {
        MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
        annotation.title = [aDictionary objectForKey:@"name"];
        annotation.subtitle = [aDictionary objectForKey:@"description"];
        [annotation setCoordinate:
         CLLocationCoordinate2DMake(
                                     [[aDictionary objectForKey:@"latitude"] doubleValue],
                                     [[aDictionary objectForKey:@"longitude"] doubleValue])
         ];
        
        [self.mapView addAnnotation:annotation];
    }
}


- (IBAction)findMeButtonTapped:(UIButton *)sender {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
}

- (void) locationsUpdatedNotificationHandler: (NSNotification *) notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self addPointsToMap];
    });
}
@end
