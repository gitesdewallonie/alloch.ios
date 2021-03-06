//
//  CSMapRouteLayerView.h
//  AlloChambre
//

#import <UIKit/UIKit.h>
#import <MapKit/Mapkit.h>

@interface CSMapRouteLayerView : UIView <MKMapViewDelegate>
{
    MKMapView* _mapView;
    NSArray* _points;
    UIColor* _lineColor;
}

-(id) initWithRoute:(NSArray*)routePoints mapView:(MKMapView*)mapView;

@property (nonatomic, retain) NSArray* points;
@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) UIColor* lineColor;

@end
