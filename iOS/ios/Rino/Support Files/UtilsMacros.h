//
//  define.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/18.
//  Copyright © 2017年 徐阳. All rights reserved.
//

// 全局工具类宏定义

#ifndef define_h
#define define_h

//-------------------打印日志-------------------------
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#define KLog(format, ...) printf("[%s][Rino][Line:%d]%s%s\n", __TIME__, __LINE__, __FUNCTION__,  [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String]);
#else
#define KLog(format, ...)
#endif

//强弱引用
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;

#endif /* define_h */
