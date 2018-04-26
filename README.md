## ImageTools

UIImage 是开发中最常用的控件,为了满足开发需求我们时常会对图片做一些处理,例如: 图片缩放,生成纯色图片,截取屏幕等.在这针对于开发中用到的图片处理,使用类扩展(extension)形式进行了简单总结.

- 截取视图

```swift
    /// 截取视图
    ///
    /// - Parameters:
    ///   - currentView: 要截取的视图
    ///   - size: 将来创建出来的bitmap的大小
    ///   - opaque: 设置透明YES代表透明，NO代表不透明
    ///   - scale: 代表缩放,0代表不缩放
    /// - Returns: 要截取视图对应的 UIImage 对象
    static func captureScreen(currentView: UIView, opaque: Bool, scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(currentView.bounds.size, opaque, scale)
        currentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
```

- 根据颜色生成图片

```swift
    /// 根据颜色生成图片
    ///
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    static func initWithColor(_ color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
```
