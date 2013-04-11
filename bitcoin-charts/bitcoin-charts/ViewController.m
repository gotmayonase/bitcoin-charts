//
//  ViewController.m
//  bitcoin-charts
//
//  Created by Mike Mayo on 4/10/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "ViewController.h"
#import "SBJson.h"
#import "SocketIOPacket.h"
#define DEBUG_LOGS 0

@interface ViewController ()

@end

@implementation ViewController {
  SocketIO *socketIO;
  BOOL connected;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self connect:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connect:(id)sender {
  connected = NO;
  socketIO = [[SocketIO alloc] initWithDelegate:self];
  [socketIO connectToHost:@"socketio.mtgox.com" onPort:80 withParams:nil withNamespace:@"/mtgox"];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

//lag 85174711-be64-4de1-b783-0628995d7914

- (void)subscribeToChannel:(NSString *)channelID {
  SBJsonWriter *parser = [[SBJsonWriter alloc] init];
  NSDictionary *subMsg = @{@"channel": channelID, @"op": @"subscribe"};
  NSString *msg = [parser stringWithObject:subMsg];
  NSLog(@"sending message: %@", msg);
//  [_webSocket send:msg];
}

#pragma mark - SocketIODelegate

- (void)socketIODidConnect:(SocketIO *)socket {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
  [socket sendJSON:@{@"op":@"mtgox.subscribe", @"channel":@"trade.lag"}];
  NSLog(@"socketIODidConnect");
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
//  NSLog(@"socketIO didDisconnect: %@", error);
}

- (void)socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
//  NSLog(@"socketIO didSendMessage: %@", packet.data);
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
//  NSLog(@"socketIO didReceiveEvent: %@", packet);
}

- (void)socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
  NSDictionary *jsonData = packet.dataAsJSON;
  NSDictionary *lag = [jsonData objectForKey:@"lag"];
  if (lag) {
    float age = [((NSString *)[lag objectForKey:@"age"]) floatValue];
    NSLog(@"Lag: %f", age / 1000000.0);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:age / 1000000.0];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"m:ss.SSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    [self.lagLabel setText:[NSString stringWithFormat:@"Lag: %@", [formatter stringFromDate:date]]];
  }
}

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
//  NSLog(@"socketIO didReceiveMessage: %@", packet.data);
}

- (void)socketIO:(SocketIO *)socket onError:(NSError *)error {
//  NSLog(@"socketIO onError: %@", error);
}

@end
