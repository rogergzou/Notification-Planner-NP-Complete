//
//  ViewController.m
//  Notification Planner NP Complete
//
//  Created by Roger on 11/1/14.
//  Copyright (c) 2014 Roger Zou. All rights reserved.
//

#import "ViewController.h"
#import <EventKit/EventKit.h>

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *scheduleNotifButton;
@property (weak, nonatomic) IBOutlet UITextField *textField; //start date
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;
@property (weak, nonatomic) IBOutlet UITextView *eventTitleTextView;
@property (weak, nonatomic) IBOutlet UITextField *occurenceTextField;
@property (weak, nonatomic) IBOutlet UITextField *frequencyTextField;

@property (nonatomic, strong) UIDatePicker *startDatePicker;
@property (nonatomic, strong) UIDatePicker *endDatePicker;
@property (nonatomic, strong) NSArray *totalTimesArray;
@property (nonatomic, strong) NSArray *frequencyArray;
@property (nonatomic, strong) UIPickerView *totalTimesPicker;
@property (nonatomic, strong) UIPickerView *frequencyPicker;

@property (nonatomic) int totalTimes;
@property (nonatomic) int frequencyInMins;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.scheduleNotifButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //self.scheduleNotifButton.titleLabel setTextAlignment
    [self initializeDateViewsInputView];
    [self initializeTextFieldInputView];
    
    //to resign keyboard. One liner lol. http://stackoverflow.com/questions/5306240/iphone-dismiss-keyboard-when-touching-outside-of-textfield
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)scheduleNotificationButtonPressed:(id)sender {
    NSLog(@"%@, %@", self.startDatePicker.date, self.endDatePicker.date);
    int someOccurNum = abs( [self.endDatePicker.date timeIntervalSinceDate:self.startDatePicker.date]/(60 * self.frequencyInMins) );
    NSLog(@"first occ %i vs total %i", someOccurNum, self.totalTimes);
    someOccurNum = (someOccurNum < self.totalTimes) ? someOccurNum : self.totalTimes; //chooses least
    
    NSLog(@"final occ %i", someOccurNum);
    if (someOccurNum <= 0) {
        return;
    }
    NSDate *now = [NSDate date];
    for (int i = 0; i < someOccurNum; i++) {
        NSLog(@"i %i", i);
        NSDate *myDate = [self.startDatePicker.date dateByAddingTimeInterval:i*60*self.frequencyInMins];
        NSLog(@"theDate %@", myDate);
        if ([myDate compare:now] != NSOrderedAscending)
            [self scheduleEventWithDate:myDate occurrenceNumber:i];
    }
}

-(void)scheduleEventWithDate:(NSDate *)fireDate occurrenceNumber:(int)occNum{

    UILocalNotification *notif = [[UILocalNotification alloc]init];
    notif.fireDate = fireDate;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.alertBody = [NSString stringWithFormat:@"%@. Occurance # %i", self.eventTitleTextView.text, occNum];
    notif.alertAction = @"OK";
    notif.soundName = UILocalNotificationDefaultSoundName;
    //notif.applicationIconBadgeNumber = 1;
    //adjust timeString for grammar later
    //notif.userInfo = @{@"typeKey": @"reminder", @"timeStringKey": timeString};
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    NSLog(@"scheduled for %@ w/ %@", notif.fireDate, notif.alertBody);
    //[self.reminderButton setTitle:[NSString stringWithFormat:@"%@", [NSDateFormatter localizedStringFromDate:notificationDate dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle]] forState:UIControlStateNormal];
}


//lazy instantiation
-(int)totalTimes
{
    if (!_totalTimes) _totalTimes = 1;
    return _totalTimes;
}
-(int)frequencyInMins
{
    if (!_frequencyInMins) _frequencyInMins = 2;
    return _frequencyInMins;
}
- (NSArray *)totalTimesArray
{
    if (!_totalTimesArray) {
        NSMutableArray *holder = [NSMutableArray array];
        for (int i = 1; i < 20; i++) {
            [holder addObject:@(i)];
        }
        [holder addObjectsFromArray:@[@20,@25,@30,@35,@40,@45,@50,@60,@80,@100,@125,@150,@175,@200,@250,@300,@350,@400,@500]]; //slowly increasing in interval
        _totalTimesArray = [NSArray arrayWithArray:holder];
    }
    return _totalTimesArray;
}
- (NSArray *)frequencyArray
{
    if (!_frequencyArray) {
        NSMutableArray *holder = [NSMutableArray arrayWithObject:@2];
        for (int i = 5; i < 30; i+=5) {
            [holder addObject:@(i)];
        }
        for (int j = 30; j < 120; j+=15) {
            [holder addObject:@(j)];
        }
        for (float k = 120; k < 180; k+=30) {
            [holder addObject:@(k)];
        }
        [holder addObjectsFromArray:@[@180,@240,@300,@360,@480,@600,@720,@960,@1200,@1800,@2400]];
        _frequencyArray = [NSArray arrayWithArray:holder];
    }
    return _frequencyArray;
}

- (void)initializeDateViewsInputView
{
    self.startDatePicker = [self makeDatePickerForBox];
    self.startDatePicker.tag = 0; //0 for start
    self.textField.inputView = self.startDatePicker;
    self.endDatePicker = [self makeDatePickerForBox];
    self.endDatePicker.tag = 1; //1 for end
    self.endDateTextField.inputView = self.endDatePicker;
}
- (UIDatePicker *)makeDatePickerForBox {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 5;
    datePicker.backgroundColor = [UIColor whiteColor];
    return datePicker;
}
- (void) dateUpdated:(UIDatePicker *)datePicker {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd 'at' HH:mm"];
    if (datePicker.tag == 0)
        self.textField.text = [formatter stringFromDate:datePicker.date];
    else if (datePicker.tag == 1)
        self.endDateTextField.text = [formatter stringFromDate:datePicker.date];
}


#pragma mark - UIDatePicker methods for UITextField of Frequency

//http://stackoverflow.com/questions/23208809/replace-ios7-keyboard-by-a-date-picker-in-tableviewcontroller
- (void) initializeTextFieldInputView {
    //self.totalTimesPicker = [self makePickerForTextField];
    //self.totalTimesPicker.tag = 0; //0 for occ
    //self.occurenceTextField.inputView = self.totalTimesPicker;
    
    self.frequencyPicker = [self makePickerForTextField];
    //self.frequencyPicker.tag = 1; //1 for freq
    self.frequencyTextField.inputView = self.frequencyPicker;
}
- (UIPickerView *)makePickerForTextField {
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    picker.delegate = self;
    picker.dataSource = self;
    picker.backgroundColor = [UIColor whiteColor];
    return picker;
}

#pragma mark - UIPickerView DataSource/Delegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.frequencyArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    int mins = [self.frequencyArray[row] intValue];
    if (mins < 180)
        return [NSString stringWithFormat:@"%i minutes", mins];
    else
        return [NSString stringWithFormat:@"%i hours", mins/60];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.frequencyInMins = [self.frequencyArray[row] intValue];
    self.frequencyTextField.text = [self pickerView:pickerView titleForRow:row forComponent:component];
}
//meh didn't work
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 160;
}


@end
