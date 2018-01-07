//
//  ViewController.m
//  modularizationDemo
//
//  Created by 李林 on 2017/11/28.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ViewController.h"
#import "ModuleProtocolManager.h"
#import "ModuleAProtocol.h"
#import <signal.h>
#import <execinfo.h>
#import "StackForNSObject.h"
#import "DBManager.h"
#import "Person.h"

#define BeeHiveMod(name) char * k##name##_mod = ""#name"";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self defineTest];
    
    NSMutableDictionary *dict = @{}.mutableCopy;
    dict[@"username"] = @"lilin";
    dict[@"password"] = @"zhouying";
    [self performSelector:@selector(createWithParams:) withObject:[dict copy]];
    
    [self pathComponentsFromURL:@"http://login/result?username=1&password=2"];
    
    [self initHandler];
    [self crashTest];
    
    [self stackTest];
    
    [self hookTest];
}

- (NSString *)createWithParams:(NSDictionary *)params{
    NSLog(@"%@, %@", params[@"username"], params[@"password"]);
    return [NSString stringWithFormat:@"\nusername:%@\npassword:%@", params[@"username"], params[@"password"]];
}

- (void)defineTest {
    char * kHomeServiceProtocol_service = "{ \"""HomeServiceProtocol""\" : \"""BHViewController""\"}";
    NSString *aString = [[NSString alloc] initWithUTF8String:kHomeServiceProtocol_service];
    NSLog(@"aString:%@", aString);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /*
     1. 有时候不希望把类的名称和方法暴露出来，采用protocol的方式。
     2. 我们平时tableView.delegate = self;是将遵守协议的view传过去，由delegate的持有方决定何时出发delegate，执行者还是遵守协议的view。
     3. 实现：遵守协议者及其子类
        调用：遵守协议者、其子类 id<协议名称>
     */
    id<ModuleAProtocol> moduleA = [ModuleProtocolManager serviceAProvideForProtocol:@protocol(ModuleAProtocol)];
    UIViewController *moduleAVC = [moduleA moduleAViewControllerWithId:@"21650148" Name:@"lilin"];
    [self presentViewController:moduleAVC animated:YES completion:nil];
}

#pragma mark - URL parse

- (NSArray *)pathComponentsFromURL:(NSString*)URL {
    NSMutableArray *pathComponents = @[].mutableCopy;
    
    // 把URL的Scheme存放下来
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，存放一个占位符。
        URL = pathSegments.lastObject;
        if (!URL.length) {
            [pathComponents addObject:@"~"];
        }
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    
    return [pathComponents copy];
}

#pragma mark - Crash Catch

- (void)initHandler {
    struct sigaction newSignalAction;
    memset(&newSignalAction, 0,sizeof(newSignalAction));
    newSignalAction.sa_handler = &signalHandler;
    sigaction(SIGABRT, &newSignalAction, NULL);
    sigaction(SIGILL, &newSignalAction, NULL);
    sigaction(SIGSEGV, &newSignalAction, NULL);
    sigaction(SIGFPE, &newSignalAction, NULL);
    sigaction(SIGBUS, &newSignalAction, NULL);
    sigaction(SIGPIPE, &newSignalAction, NULL);
    
    //异常时调用的函数
    NSSetUncaughtExceptionHandler(&handleExceptions);
}

void handleExceptions(NSException *exception) {
    NSLog(@"exception = %@",exception);
    NSLog(@"callStackSymbols = %@",[exception callStackSymbols]);
}

void signalHandler(int sig) {
    NSLog(@"signal = %d", sig);
}

- (void)crashTest {
    NSMutableArray *arr = @[].mutableCopy;
//    [arr addObject:nil];
}

- (void)stackTest {
    StackForNSObject *stack = [[StackForNSObject alloc] init];
    NSLog(@"%d", [stack isEmpty]);
    [stack pushObj:@"1"];
    [stack pushObj:@"2"];
    [stack pop];
    NSLog(@"%@", [stack top]);
    [stack pushObj:@"3"];
    [stack pushObj:[UIViewController new]];
    NSLog(@"%@", [stack getAllObjects]);
}

- (void)hookTest {
    UIViewController *twoVC = [[UIViewController alloc] init];
}

#pragma mark - DataBase


void test() {
    DBManager *mgr = [DBManager sharedManager];
    //查询数据
    NSArray *array = [mgr getAllPersons];
    for (int i = 0; i < array.count; i++) {
        NSLog(@"%@",array[i]);
    }
    /*输出结果
     2015-06-27 15:01:29.290 MySqlTest[2451:145448] 连接成功
     2015-06-27 15:01:29.291 MySqlTest[2451:145448] 1 李文深 男 23 12345678910
     2015-06-27 15:01:29.291 MySqlTest[2451:145448] 2 张三 男 33 13099881235
     2015-06-27 15:01:29.291 MySqlTest[2451:145448] 3 李四 女 20 -
     2015-06-27 15:01:29.291 MySqlTest[2451:145448] 4 敌法师 男 8 18825694821
     */
    /*
     person这个类的属性:
     @property (nonatomic,copy) NSString *ID;
     @property (nonatomic,copy) NSString *name;
     @property (nonatomic,copy) NSString *sex;
     @property (nonatomic,copy) NSString *age;
     @property (nonatomic,copy) NSString *tel;
     */
    
    
    //添加数据
    Person *p = [[Person alloc] init];
    p.name = @"传说哥";
    p.age = @"50";
    p.sex = @"男";
    p.tel = @"11111111111";
    //    [mgr addPerson:p];
    
    /*
     //删除数据
     p.ID = @"1";
     [mgr deletaPerson:p];
     */
}

@end
