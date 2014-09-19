//
//  ViewController.m
//  iBeacon
//
//  Created by raviranjan on 01/07/14.
//  Copyright (c) 2014 NK. All rights reserved.
//

#import "ViewController.h"

static NSString * uuid = @"8CF62DF5-A317-4A90-B90D-2829D1D5985B";
static NSString * treasureId = @"com.eden.treasure";
static CLBeaconMajorValue majorID = 1;
static CLBeaconMinorValue minorID = 1;

@interface ViewController ()

    // transmitter properties
@property CLBeaconRegion * beaconRegion;
@property CBPeripheralManager * peripheralManager;
@property NSMutableDictionary * peripheralData;

    // receiver properties
@property CLLocationManager * locationManager;
@property CLProximity previousProximity;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
        // Regardless of whether the device is a transmitter or receiver, we need a beacon region.
    NSUUID * uid = [[NSUUID alloc] initWithUUIDString:uuid];
        // for transmitter
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uid
                                                                major:majorID
                                                                minor:minorID
                                                           identifier:treasureId];
    
    // When set to YES, the location manager sends beacon notifications when the user turns on
        // the display and the device is already inside the region.
    [self.beaconRegion setNotifyEntryStateOnDisplay:YES];
    [self.beaconRegion setNotifyOnEntry:YES];
    [self.beaconRegion setNotifyOnExit:YES];
    [self configureTransmitter];

}

-(void)configureTransmitter {
        // The received signal strength indicator (RSSI) value (measured in decibels) for the device.
        // This value represents the measured strength of the beacon from one meter away and is used during ranging.
        // Specify nil to use the default value for the device.
    NSNumber * power = [NSNumber numberWithInt:-63];
    self.peripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:power];
        // Get the global dispatch queue.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        // Create a peripheral manager.
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:queue];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    // CBPeripheralManagerDelegate delegate methods
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
        // The peripheral is now active, this means the bluetooth adapter is all good so we can start advertising.
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheralManager startAdvertising:self.peripheralData];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"Powered Off");
        [self.peripheralManager stopAdvertising];
    }  
}





@end
