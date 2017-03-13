//
//  CommonMacros.h
//  RaccoonHomeClient
//
//  Created by gaofu on 15/10/20.
//  Copyright © 2015年 gaofu. All rights reserved.
//
/**
 *  一些常用宏
 */

#ifndef CommonMacros_h
#define CommonMacros_h


/**
 *  常用尺寸
 */

//物理屏幕
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [[UIScreen mainScreen] bounds].size.height

//  StatusBar高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

//  NavigationBar高度
#define kNavigationBarHeight self.navigationController.navigationBar.frame.size.height

//  Tabbar高度
#define kTabBarHeight self.tabBarController.tabBar.frame.size.height




//================================================================

/**
 *  字体操作
 */

//根据大小获取粗体字体
#define kAppBoldFontWithSize(fontSize) ([UIFont boldSystemFontOfSize:fontSize])

//根据大小获取普通字体
#define kAppFontWithSize(fontSize) ([UIFont systemFontOfSize:fontSize])





//================================================================

/**
 *  语法糖
 */


//快速生成弱引用self变量
#define kWeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

//强引用
#define kStrongSelf(strongSelf) __strong __typeof(&*self)strongSelf = weakSelf;

//获取window
#define kWindow [[[UIApplication sharedApplication] delegate] window]

//确保字符串不能为空（nil、NULL或NSNull)
#define kEnsureStringNotNullForString(str) [Helper ensureStringToNotNULL:str]

//确保字符串不为空（nil或@""），如果为空就将其设置为“暂无”
#define kEnsureNotNullWithDefaultForString(aString) [Helper isNullOrEmptyString:aString] ? @"暂无" : aString

//确保字符串不为空（nil或@""），如果为空就将其设置为指定的值
#define kEnsureStringNotNullForStringWithStringAndText(aString, text) [Helper isNullOrEmptyString:aString] ? text : aString

//判断字符串是否为空（nil或@"")
#define kIsNullOrEmptyWithString(aString) [Helper isNullOrEmptyString:aString]
#define kIsNotNullOrEmptyWithString(aString) ![Helper isNullOrEmptyString:aString]

//判断对象是否为空（nil、NULL、或NSNull)
#define kIsNullObjectWith(aObject) [Helper isNullObject:aObject]
#define kIsNotNullObjectWith(aObject) ![Helper isNullObject:aObject]

//将整数转成字符串
#define kStringWithInteger(number) [NSString stringWithFormat:@"%d", number]

//将浮点数转成字符串
#define kStringWithFloat(number) [NSString stringWithFormat:@"%f", number]

//读取本地图片
#define kLoadLocalImage(fileName) ([UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:nil]])

//定义UIImage对象
#define kImageNamed(fileName) ([UIImage imageNamed:[UIUtil imageName:fileName]])

//加载xib对象
#define kInstanceFromXib(XIB_Name) ([[[NSBundle mainBundle] loadNibNamed:XIB_Name owner:self options:nil] lastObject])

//加载storyboard对象
#define kInstanceFromStoryboard(SB_Name, Controller_ID) ([[UIStoryboard storyboardWithName:SB_Name bundle:nil] instantiateViewControllerWithIdentifier:Controller_ID])

//快速转到下一个页面
#define kPushViewControllerWithController(controller) ([self.navigationController pushViewController:controller animated:YES])

//快速转到下一个页面
#define kPushViewControllerWithStoryboard(SB_Name, Controller_ID) ([self.navigationController pushViewController:([[UIStoryboard storyboardWithName:SB_Name bundle:nil] instantiateViewControllerWithIdentifier:Controller_ID]) animated:YES])


#define kRegisterNibCell(Nib_Name, Identifier) ([self.tableView registerNib:[UINib nibWithNibName:Nib_Name bundle:nil] forCellReuseIdentifier:Identifier])


//获取DocumentsDirectory目录路径
#define kDocumentsDirectoryPath  ([((NSArray *)NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)) objectAtIndex:0])

//加载plist文件
#define kLoadDictionaryFromPlistFile(fileName) ([[NSDictionary alloc] initWithContentsOfFile:([[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"])])

#define kLoadArrayFromPlistFile(fileName) ([[NSArray alloc] initWithContentsOfFile:([[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"])])

//快速访问NSUserDefaults
#define kSaveToUserDefaults(key, value) ([[NSUserDefaults standardUserDefaults] setObject:value forKey:key])
#define kFetchFromUserDefaults(key) ([[NSUserDefaults standardUserDefaults] objectForKey:key])
#define kSynchronizeForUserDefaults ([[NSUserDefaults standardUserDefaults] synchronize])


//================================================================


/**
 *  TableView 相关
 */

//去掉TableView多余的分隔线
#define kRemoveBottomLinesForTableView(tableView) tableView.tableFooterView = [UIView new]

//注册Cell到TableView，xib方式
#define kRegisterCellForTableView(tableView, xibName, cellIdentifier) [tableView registerNib:[UINib nibWithNibName:xibName bundle:nil] forCellReuseIdentifier:cellIdentifier]


//================================================================

#define ARC4RANDOM_MAX 0x100000000

//随机产生整数(int)
#define kGetRandomInt (arc4random() % ARC4RANDOM_MAX)

//随机产生指定上限(不包括本身)的随机整数(int)
#define kGetRandomIntWithUpperLimit(upperLimit) (arc4random() % (upperLimit))

//随机产生指定下限(不包括本身)的随机整数(int)
#define kGetRandomIntWithLowerLimit(lowerLimit) (arc4random() % (RAND_MAX - lowerLimit) + (lowerLimit + 1))

//随机产生指定上限(不包括本身)和下限(不包括本身)的随机整数(int)
#define kGetRandomIntWithLimit(lowerLimit, upperLimit) (arc4random() % (upperLimit - lowerLimit - 1) + (lowerLimit + 1))

//随机产生指定上限(不包括本身)和下限(不包括本身)的随机整数(int)




//随机产生0到1(包括本身)之间浮点数(float)
#define kGetRandomFloat (arc4random() / (CGFloat)ARC4RANDOM_MAX)

//随机产生指定上限(包括本身)的随机浮点数(float)
#define kGetRandomFloatWithUpperLimit(upperLimit) (kGetRandomFloat * upperLimit)

//随机产生指定下限(包括本身)的随机浮点数(float)
#define kGetRandomFloatWithLowerLimit(lowerLimit) ((kGetRandomFloat * ((CGFloat)RAND_MAX - lowerLimit)) + lowerLimit)

//随机产生指定上限(包括本身)和下限(包括本身)的随机浮点数(float)
#define kGetRandomFloatWithLimit(lowerLimit, upperLimit) (kGetRandomFloat * (upperLimit - lowerLimit) + lowerLimit)




//================================================================


/**
 *  字体 相关
 */


#define kMyFavorityFontName @"HelveticaNeue-UltraLight"



//================================================================


#endif /* CommonMacros_h */



