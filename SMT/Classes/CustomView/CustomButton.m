#import "CustomButton.h"

@interface CustomButton ()
{
    NSMutableArray * inputArray;
    NSString * selectItem;
    Species * selectSpecie;
    NSString * questionID;
    NSString * btnType;
}

- (void)click:(id)sender;
@end


@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        selectItem = @"";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        selectItem = @"";
    }
    return self;
}



- (void)removeSelectIthem
{
    if (selectSpecie) {
        [inputArray removeObject:selectSpecie];
        if (inputArray.count) {
            [self setSelectedSpecies:[inputArray firstObject]];
        } else {
            selectSpecie = nil;
            [self setTitle:@"" forState:UIControlStateNormal];
        }
    }
}

- (void) addSpecie:(Species *)spec
{
    if (inputArray.count == 0) {
        [inputArray addObject:spec];
        [self setSelectedSpecies:spec];
    } else {
        [inputArray addObject:spec];
    }
}

- (void) setInputArray:(NSArray *)array
{
    inputArray = [[NSMutableArray alloc]initWithArray:array];
    //[self setTitle:@"Nother Pike" forState:UIControlStateNormal];
}
- (void) setWithInputDictionary:(NSDictionary *)dict
{
    questionID = [dict objectForKey:@"id"];
    [self setTitle:[dict objectForKey:@"question"] forState:UIControlStateNormal];
    btnType = [NSString stringWithFormat:@"%@: ",[dict objectForKey:@"question"]];
    inputArray = [[NSMutableArray alloc]init];
    for (NSDictionary * obj in [dict objectForKey:@"options"]) {
        [inputArray addObject:[obj objectForKey:@"myoption"]];
    }
    selectItem = [inputArray firstObject];
    [self setSelectedIthem:selectItem];
}

- (void) setButtonWithKillingDictionary:(NSDictionary *) dict
{
    [self setTitle:[dict objectForKey:@"killingquestion"] forState:UIControlStateNormal];
    inputArray = [[NSMutableArray alloc]init];
    for (NSDictionary * obj in [dict objectForKey:@"killingOptions"]) {
        [inputArray addObject:[obj objectForKey:@"optionText"]];
    }

}


- (NSString *)getQuestion
{
    return questionID;
}

- (NSString *) getSelectedIthem
{
    return selectItem;
}

- (Species *) getSelectedSpecie
{
    //if (inputArray.count > 1) {
        return selectSpecie;
//    } else {
//        Species * ret = selectSpecie;
//        [inputArray removeObject:selectSpecie];
//        selectSpecie = nil;
//        return ret;
//    }
}

- (void) setSelectedIthem:(NSString *)str
{
    if (str) {
    for (NSString * obj in inputArray) {
        if ([obj isEqualToString:str]) {
            selectItem = str;
            [self setTitle:[btnType stringByAppendingString:str] forState:UIControlStateNormal];
        }
    }
    }
}

- (void) setSelectedSpecies:(Species *)spec
{
    for (Species * obj in inputArray) {
        if ([obj isEqual:spec]) {
            selectSpecie = obj;
            [self setTitle:spec.name forState:UIControlStateNormal];
        }
    }
}

- (void)click:(id)sender
{
    id<ButtonControllerDelegate> delegate = self.delegate;
    if ([delegate respondsToSelector:@selector(openPickerWithData:andTag:)]) {
        [delegate openPickerWithData:inputArray andTag:self.tag];
    }
}

@end
