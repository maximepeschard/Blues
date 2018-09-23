@import IOBluetooth;

// Private APIs

// https://github.com/w0lfschild/macOS_headers/blob/master/macOS/Frameworks/IOBluetooth/6.0.8f6/IOBluetoothDevice.h
@interface IOBluetoothDevice (Private)
@property(nonatomic) unsigned char batteryPercentCombined;
@property(nonatomic) unsigned char batteryPercentCase;
@property(nonatomic) unsigned char batteryPercentRight;
@property(nonatomic) unsigned char batteryPercentLeft;
@property(nonatomic) unsigned char batteryPercentSingle;
@end

// https://github.com/toy/blueutil/blob/master/blueutil.m
int IOBluetoothPreferenceGetControllerPowerState();
void IOBluetoothPreferenceSetControllerPowerState(int state);
