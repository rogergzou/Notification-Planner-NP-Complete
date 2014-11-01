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
@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;

@property (nonatomic, strong) UIDatePicker *startDatePicker;
@property (nonatomic, strong) UIDatePicker *endDatePicker;
@property (nonatomic, strong) NSArray *totalTimesArray;
@property (nonatomic, strong) NSArray *frequencyArray;
@property (nonatomic) int totalTimes;
@property (nonatomic) int frequencyInMins;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.scheduleNotifButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //self.scheduleNotifButton.titleLabel setTextAlignment
    [self initializeTextFieldInputView];
    
    //to resign keyboard. One liner lol. http://stackoverflow.com/questions/5306240/iphone-dismiss-keyboard-when-touching-outside-of-textfield
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)scheduleNotificationButtonPressed:(id)sender {
    
}

-(void)scheduleEventWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    EKEventStore *eventStore = [[EKEventStore alloc]init];
    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    NSString *cat;
    
    event.title = self.eventTitleTextField.text;
    event.startDate = self.startDate;
    event.endDate = self.endDate;
    //event.location for later updates
    
    int mins = floor(self.seconds/60);
    int secs = self.seconds - (mins * 60);
    int hours = 0;
    if (mins > 59) {
        hours = floor(mins/60);
        mins -= hours * 60;
    }
    int pmins = floor(self.pausedSeconds/60);
    int psecs = floor(self.pausedSeconds - (pmins * 60));
    int phours = 0;
    if (pmins > 59) {
        phours = floor(pmins/60);
        pmins -= phours * 60;
    }
    NSString *timeString;
    NSString *pTimeString;
    if (hours == 0)
        timeString = [NSString stringWithFormat:@"%i:%02i", mins, secs];
    else
        timeString = [NSString stringWithFormat:@"%i:%02i:%02i", hours, mins, secs];
    if (phours == 0)
        pTimeString = [NSString stringWithFormat:@"%i:%02i", pmins, psecs];
    else
        pTimeString = [NSString stringWithFormat:@"%i:%02i:%02i", phours, pmins, psecs];
    event.notes = [NSString stringWithFormat:@"%@ active, %@ inactive, paused %i times", timeString, pTimeString, self.pauseNumber];
    [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (granted) {
            //user lets calendar access
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *err;
            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
            
        } else {
            //user no calendar access
            //NSLog(@"No access :(");
            UIAlertView *accessAlert = [[UIAlertView alloc]initWithTitle:@"Please allow calendar access for full app functionality" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            // tag for identification when handling
            accessAlert.tag = calendarAccessMissingAlertTag;
            [accessAlert show];
            
            [event setCalendar:[eventStore defaultCalendarForNewEvents]];
            NSError *err;
            [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
        }
    }];
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


#pragma mark - UIDatePicker methods for UITextFields
- (IBAction)startDatePickerBeganEdits:(id)sender {
    //touch up inside
    
    //[self dateUpdated:self.startDatePicker];
        [self.endDatePicker removeTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
}
- (IBAction)endDatePickerBeganEdits:(id)sender {
    [self.startDatePicker removeTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    //[self dateUpdated:self.endDatePicker];
}
- (IBAction)startDatePickerEndedEdits:(id)sender {
    [self dateUpdated:self.startDatePicker];
    [self.endDatePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
}
- (IBAction)endDatePickerEndedEdits:(id)sender {
    [self dateUpdated:self.endDatePicker];
    [self.startDatePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
}

//http://stackoverflow.com/questions/23208809/replace-ios7-keyboard-by-a-date-picker-in-tableviewcontroller
- (void) initializeTextFieldInputView {
    self.startDatePicker = [self makeDatePickerForTextField];
    self.startDatePicker.tag = 0; //0 for start
    //[startDatePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    self.textField.inputView = self.startDatePicker;
    self.endDatePicker = [self makeDatePickerForTextField];
    self.endDatePicker.tag = 1; //1 for end
    //[startDatePicker addTarget:self action:@selector(dateUpdated:) forControlEvents:UIControlEventValueChanged];
    self.endDateTextField.inputView = self.endDatePicker;
    
}
- (UIDatePicker *)makeDatePickerForTextField {
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

#pragma mark - UIPickerView DataSource/Delegate
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 0)
        return [self.totalTimesArray count];
    else if (pickerView.tag == 1)
        return [self.frequencyArray count];
    else
        return 0;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 0)
        return [self.totalTimesArray[row] stringValue];
    else if (pickerView.tag == 1) {
        int mins = [self.frequencyArray[row] intValue];
        if (mins < 180)
            return [NSString stringWithFormat:@"%i minutes", mins];
        else
            return [NSString stringWithFormat:@"%i hours", mins/60];
    } else
        return @"";
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 0)
        self.totalTimes = [self.totalTimesArray[row] intValue];
    else if (pickerView.tag == 1)
        self.frequencyInMins = [self.frequencyArray[row] intValue];
}
//meh didn't work
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView.tag == 0)
        return 50;
    else if (pickerView.tag == 1)
        return 160;
    else
        return 0;
}


@end
