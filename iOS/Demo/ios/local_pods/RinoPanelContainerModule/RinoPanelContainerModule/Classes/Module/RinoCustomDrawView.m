//
//  RinoCustomDrawView.m
//  RinoPanelContainerModule
//
//  Created by jeff on 2024/10/30.
//

#import "RinoCustomDrawView.h"

@implementation RinoCustomDrawView

- (void)drawWithJSONString:(NSString *)jsonString {
    // 解析 JSON 字符串
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    if (error) {
        NSLog(@"JSON 解析失败: %@", error.localizedDescription);
        return;
    }
    
    // 获取宽高、颜色、透明度等信息
    CGFloat width = [jsonDict[@"width"] floatValue];
    CGFloat height = [jsonDict[@"height"] floatValue];
    CGFloat strokeWidth = [jsonDict[@"strokeWidth"] floatValue];
    CGFloat opacity = [jsonDict[@"opacity"] floatValue] / 100.0;
    NSString *strokeColorHex = jsonDict[@"strokeColor"];
    
    self.frame = CGRectMake(0, 0, width, height);
    
    // 解析颜色
    UIColor *strokeColor = [self colorFromHexString:strokeColorHex];
    UIColor *fillColor = [strokeColor colorWithAlphaComponent:opacity];
    
    // 获取点坐标，并按比例缩放到视图大小范围
    NSArray *points = jsonDict[@"points"];
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = strokeWidth;
    
    for (int i = 0; i < points.count; i++) {
        NSDictionary *pointDict = points[i];
//        CGFloat x = [pointDict[@"x"] floatValue] / 1000.0 * width;
        CGFloat x = [pointDict[@"x"] floatValue];
//        CGFloat y = [pointDict[@"y"] floatValue] / 1000.0 * height;
        CGFloat y = [pointDict[@"y"] floatValue];
        if (i == 0) {
            [path moveToPoint:CGPointMake(x, y)];
        } else {
            [path addLineToPoint:CGPointMake(x, y)];
        }
    }
    
    [path closePath];
    
    // 绘制图形
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.lineWidth = strokeWidth;
    
    [self.layer addSublayer:shapeLayer];
}

// 将视图截图成图片
- (UIImage *)captureImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *capturedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capturedImage;
}

// 辅助方法：将十六进制颜色字符串转换为 UIColor
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // 跳过“#”字符
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0x00FF00) >> 8) / 255.0
                            blue:(rgbValue & 0x0000FF) / 255.0
                           alpha:1.0];
}

- (void)saveImageToSandbox:(UIImage *)image withFileName:(NSString *)fileName finish:(void(^)(NSString *path, NSError *error))finish {
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        BOOL success = [imageData writeToFile:filePath atomically:YES];
        if (success) {
            NSLog(@"图片保存成功，路径: %@", filePath);
            if (finish) {
                finish(filePath, nil);
            }
        } else {
            NSLog(@"图片保存失败");
            if (finish) {
                finish(@"", [NSError errorWithDomain:@"com.rino.saveImageError" code:1002 userInfo:@{NSLocalizedDescriptionKey : @"save error"}]);
            }
        }
    } else {
        if (finish) {
            finish(@"", [NSError errorWithDomain:@"com.rino.saveImageError" code:1002 userInfo:@{NSLocalizedDescriptionKey : @"create image error"}]);
        }
    }
}
@end
