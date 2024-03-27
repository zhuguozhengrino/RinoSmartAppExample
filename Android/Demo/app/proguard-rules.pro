# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile
-obfuscationdictionary dic.txt
-classobfuscationdictionary dic.txt
-packageobfuscationdictionary dic.txt
-keep class net.cloudshields.*{*;}
-keep class net.cloudshields.bean.*{*;}
-keep class net.cloudshields.base.*{*;}
-keep class com.google.gson.*
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,SourceFile,LineNumberTable,Annotation,EnclosingMethod,MethodParameters

-keep class *.R$ {
*;
}
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
-keep class com.google.gson.stream.** { *; }
-keepattributes EnclosingMethod

#-------------------------------------------基本不用动区域--------------------------------------------
#---------------------------------基本指令区----------------------------------
-dontskipnonpubliclibraryclassmembers
-printmapping proguardMapping.txt
-keepattributes *Annotation*,InnerClasses
-keepattributes SourceFile,LineNumberTable
#----------------------------------------------------------------------------

#---------------------------------默认保留区---------------------------------
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference
-keep public class * extends android.view.View

-keepclasseswithmembernames class * {
    native <methods>;
}
-keepclassmembers class * extends android.app.Activity{
    public void *(android.view.View);
}
-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keep class * implements android.os.Parcelable {
}
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
-keep class **.R$* {
 *;
}
-keepclassmembers class * {
    void *(**On*Event);
}
#----------------------------------------------------------------------------


# Application classes that will be serialized/deserialized over Gson
# Prevent proguard from stripping interface information from TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

##---------------End: proguard configuration for Gson  ----------


#指定代码的压缩级别
-optimizationpasses 5
#包明不混合大小写
-dontusemixedcaseclassnames
#不去忽略非公共的库类
-dontskipnonpubliclibraryclasses
#预校验
-dontpreverify
#混淆时是否记录日志
-verbose
 # 混淆时所采用的算法
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

#优化  不优化输入的类文件
# -dontshrink # = shrinkResources false
-dontoptimize

-dontwarn com.google.android.**
-dontwarn android.webkit.**
-dontwarn org.apache.**
-dontwarn retrofit2.**
-dontwarn rx.**
-dontwarn javax.**
-dontwarn android.**
-dontwarn androidx.**
-dontwarn kotlin.jvm.**
-dontwarn kotlin.coroutines.**
-dontwarn org.springframework.**
-dontwarn org.glassfish.**

-keep class com.smart.rinoiot.bean.**{*;}
-keep class com.smart.rinoiot.common_sdk.bean.**{*;}
-keep class com.smart.rinoiot.connect_sdk.bean.**{*;}
-keep class com.smart.rinoiot.connect_ui.bean.**{*;}
-keep class com.smart.rinoiot.device_sdk.bean.**{*;}
-keep class com.smart.rinoiot.device_ui.bean.**{*;}
-keep class com.smart.rinoiot.family_kit.bean.**{*;}
-keep class com.smart.rinoiot.family_ui.bean.**{*;}
-keep class com.smart.rinoiot.feedback_kit.bean.**{*;}
-keep class com.smart.rinoiot.feedback_ui.bean.**{*;}
-keep class com.smart.rinoiot.ipc.bean.**{*;}
-keep class com.smart.rinoiot.map.bean.**{*;}
-keep class com.smart.rinoiot.matter.bean.**{*;}
-keep class com.smart.rinoiot.msg_sdk.bean.**{*;}
-keep class com.smart.rinoiot.msg_ui.bean.**{*;}
-keep class com.smart.rinoiot.module_ble.bean.**{*;}
-keep class com.smart.rinoiot.mqtt_sdk.bean.**{*;}
-keep class com.smart.rinoiot.panel_sdk.bean.**{*;}
-keep class com.smart.rinoiot.scan.bean.**{*;}
-keep class com.smart.rinoiot.scan_ui.bean.**{*;}
-keep class com.smart.rinoiot.scene_sdk.bean.**{*;}
-keep class com.smart.rinoiot.scene_ui.bean.**{*;}
-keep class com.smart.rinoiot.shop.bean.**{*;}
-keep class com.smart.rinoiot.upush.bean.**{*;}
-keep class com.smart.rinoiot.user_sdk.bean.**{*;}
-keep class com.smart.rinoiot.user_ui.bean.**{*;}
-keep class com.lxj.xpopup.bean.**{*;}
-keep class com.smart.rinoiot.nfc_sdk.bean.**{*;}
-keep class com.smart.rinoiot.nfc_ui.bean.**{*;}
-keep class com.smart.rinoiot.device_shared_kit.model.**{*;}
-keep class com.smart.rinoiot.panel_sdk.ipc.**{*;}
-keep class com.rinoiot.oss.model.**{*;}
-keep class com.smart.rinoiot.chat.bean.**{*;}



-keep public class com.smart.rinoiot.R$*{
    public static final int *;
}

# -keep class * extends java.lang.annotation.Annotation {*;}

-keepattributes Exceptions,InnerClasses,Signature
-keepattributes *Annotation*
-keep public class com.google.vending.licensing.ILicensingService

-keep class android.** {*;}
-keep class androidx.** {*;}
-keep class com.google.android** {*;}

-keep public class * extends android.view
-keep public class * extends android.app.Fragment
-keep public class * extends androidx.fragment.app.Fragment
-keep public class * extends android.app.Activity
-keep public class * extends android.support.v7.app.AppCompatActivity
-keep public class * extends androidx.appcompat.app.AppCompatActivity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.pm
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.preference.Preference

-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}

-keep public class * extends android.view.View {
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
    public void set*(...);
    public void get*(...);
}

-keepclasseswithmembernames class * {
    native <methods>;
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}


-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

-keepnames class * implements java.io.Serializable
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    !private <fields>;
    !private <methods>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

-keepclassmembers class **.R$* {
    public static <fields>;
}


-dontwarn android.net.**
-keep class android.net.SSLCertificateSocketFactory{*;}

#-libraryjars D:/kdcl_projects/submodule/android_submodule/lib-common/libs/BaiduLBS_Android.jar
-keep class com.baidu.** { *; }
-keep class vi.com.gdi.bgl.android.**{*;}
-keep class com.baidu.location.** {*;}

####################友盟推送##########################
-dontwarn com.umeng.**
-dontwarn com.taobao.**
-dontwarn anet.channel.**
-dontwarn anetwork.channel.**
-dontwarn org.android.**
-dontwarn org.apache.thrift.**
-dontwarn com.xiaomi.**
-dontwarn com.huawei.**
-dontwarn com.meizu.**

-keepattributes *Annotation*

-keep class com.taobao.** {*;}
-keep class org.android.** {*;}
-keep class anet.channel.** {*;}
-keep class com.umeng.** {*;}
-keep class com.xiaomi.** {*;}
-keep class com.huawei.** {*;}
-keep class com.meizu.** {*;}
-keep class org.apache.thrift.** {*;}

-keep class com.alibaba.sdk.android.** {*;}
-keep class com.ut.** {*;}
-keep class com.uc.** {*;}
-keep class com.ta.** {*;}

-keep public class **.R$* {
    public static final int *;
}
####################友盟推送##########################

###########################涂鸦SDK混淆开始###########################
#fastJson
-keep class com.alibaba.fastjson.**{*;}
-dontwarn com.alibaba.fastjson.**
#
##mqtt
-keep class com.tuya.smart.mqttclient.mqttv3.** { *; }
-dontwarn org.eclipse.paho.client.mqttv3.**
#
#OkHttp3
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**

-keep class okio.** { *; }
-dontwarn okio.**


############################glide混淆开始###########################
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep class * extends com.bumptech.glide.module.AppGlideModule {
 <init>(...);
}
-keep public enum com.bumptech.glide.load.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}
-keep class com.bumptech.glide.load.data.ParcelFileDescriptorRewinder$InternalRewinder {
  *** rewind();
}
# for DexGuard only
#-keepresourcexmlelements manifest/application/meta-data@value=GlideModule
############################glide混淆结束###########################
############################状态栏混淆开始###########################
-keep class com.gyf.immersionbar.* {*;}
-dontwarn com.gyf.immersionbar.**
############################状态栏混淆结束###########################

############################Arouter混淆开始###########################
-keep public class com.alibaba.android.arouter.routes.**{*;}
-keep public class com.alibaba.android.arouter.facade.**{*;}
-keep class * implements com.alibaba.android.arouter.facade.template.ISyringe{*;}

# If you use the byType method to obtain Service, add the following rules to protect the interface:
-keep interface * implements com.alibaba.android.arouter.facade.template.IProvider

# If single-type injection is used, that is, no interface is defined to implement IProvider, the following rules need to be added to protect the implementation
# -keep class * implements com.alibaba.android.arouter.facade.template.IProvider
############################Arouter混淆结束###########################

##############视频播放开始###############
-keep class com.shuyu.gsyvideoplayer.video.** { *; }
-dontwarn com.shuyu.gsyvideoplayer.video.**
-keep class com.shuyu.gsyvideoplayer.video.base.** { *; }
-dontwarn com.shuyu.gsyvideoplayer.video.base.**
-keep class com.shuyu.gsyvideoplayer.utils.** { *; }
-dontwarn com.shuyu.gsyvideoplayer.utils.**
-keep class tv.danmaku.ijk.** { *; }
-dontwarn tv.danmaku.ijk.**

-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
##############视频播放结束###############

############ com.qiniu:qiniu-android-sdk:8.3.+ 七牛 ###############
-keep class com.qiniu.**{*;}
-keep class com.qiniu.**{public <init>();}
-ignorewarnings
############## com.qiniu:qiniu-android-sdk:8.3.+ ###########


#小米厂家 适配   这里com.xiaomi.mipushdemo.DemoMessageRreceiver改成app中定义的完整类名
-keep class com.xiaomi.mipush.sdk.DemoMessageReceiver {*;}
#可以防止一个误报的 warning 导致无法成功编译，如果编译使用的 Android 版本是 23。
-dontwarn com.xiaomi.push.**

###############facebook.react开始#####################
-keep @com.facebook.proguard.annotations.DoNotStrip class *
-keep @com.facebook.common.internal.DoNotStrip class *
-keepclassmembers class * {
 @com.facebook.proguard.annotations.DoNotStrip *;
 @com.facebook.common.internal.DoNotStrip *;
}

-keepclassmembers @com.facebook.proguard.annotations.KeepGettersAndSetters class * {
 void set*(***);
 *** get*();
}

-keep class com.facebook.** { *; }
-dontwarn com.facebook.react.**

-dontwarn com.cmonbaby.**
-keep class com.cmonbaby.utils.crash.**{*;}
################facebook.react结束##################

################视频播放器####
-keep public class cn.jzvd.JZMediaSystem {*; }
-keep public class cn.jzvd.demo.CustomMedia.CustomMedia {*; }
-keep public class cn.jzvd.demo.CustomMedia.JZMediaIjk {*; }
-keep public class cn.jzvd.demo.CustomMedia.JZMediaSystemAssertFolder {*; }

-keep class tv.danmaku.ijk.media.player.** {*; }
-dontwarn tv.danmaku.ijk.media.player.*
-keep interface tv.danmaku.ijk.media.player.** { *; }
-keep class com.google.protobuf.**{*;}
#-dontwarn com.google.protobuf.**
#-keep class com.google.protobuf.** { *;}
#-keep interface com.google.protobuf.** { *;}
#-keep class com.google.protobuf.** {
#*;
#}
#-keep class com.google.protobuf.WebSocketProtobuf.** {
#*;
#}
#######数据库
-keepclassmembers class * extends org.greenrobot.greendao.AbstractDao {
public static java.lang.String TABLENAME;
}
-keep class **$Properties { *; }

# If you DO use SQLCipher:
-keep class org.greenrobot.greendao.database.SqlCipherEncryptedHelper { *; }

# If you do NOT use SQLCipher:
-dontwarn net.sqlcipher.database.**
# If you do NOT use RxJava:
#rx
-dontwarn rx.**
-keep class rx.** {*;}
-keep class io.reactivex.**{*;}
-dontwarn io.reactivex.**
-keep class rx.**{ *; }
-keep class rx.android.**{*;}

# react-native
-keep public class com.horcrux.svg.** {*;}
-keep class com.swmansion.reanimated.** { *; }
-keep class com.facebook.jni.** { *; }
-keep class com.facebook.react.turbomodule.** { *; }
-keep,allowobfuscation @interface com.facebook.common.internal.DoNotStrip
-keep,allowobfuscation @interface com.facebook.proguard.annotations.DoNotStrip
-keep,allowobfuscation @interface com.facebook.proguard.annotations.KeepGettersAndSetters
# Do not strip any method/class that is annotated with @DoNotStrip
-keep @com.facebook.proguard.annotations.DoNotStrip class *
-keep @com.facebook.common.internal.DoNotStrip class *
-keepclassmembers class * {
	@com.facebook.proguard.annotations.DoNotStrip *;
	@com.facebook.common.internal.DoNotStrip *;
}
-keepclassmembers @com.facebook.proguard.annotations.KeepGettersAndSetters class * {
	void set*(***);
	*** get*();
}
-keep class * extends com.facebook.react.bridge.JavaScriptModule { *; }
-keep class * extends com.facebook.react.bridge.NativeModule { *; }
-keepclassmembers,includedescriptorclasses class * { native <methods>; }
-keepclassmembers class *  { @com.facebook.react.uimanager.UIProp <fields>; }
-keepclassmembers class *  { @com.facebook.react.uimanager.annotations.ReactProp <methods>; }
-keepclassmembers class *  { @com.facebook.react.uimanager.annotations.ReactPropGroup <methods>; }
-dontwarn com.facebook.react.**
-keep,includedescriptorclasses class com.facebook.react.bridge.** { *; }

#高德地图
 #3D 地图 V5.0.0之前：
    -keep   class com.amap.api.maps.**{*;}
    -keep   class com.autonavi.amap.mapcore.*{*;}
    -keep   class com.amap.api.trace.**{*;}

-dontwarn com.amap.**
#3D 地图 V5.0.0之后：
-keep class com.amap.api.maps.** { *; }
-keep class com.autonavi.** { *; }
-keep class com.amap.api.trace.** { *; }
#导航
-keep class com.amap.api.navi.** { *; }
-keep class com.autonavi.** { *; }
# 定位
-keep class com.amap.api.location.** { *; }
-keep class com.loc.**{*;}
-keep class com.amap.api.fence.** { *; }
-keep class com.autonavi.aps.amapapi.model.** { *; }

-keep class com.amap.api.maps.model.** { *; }
# 搜索
-keep class com.amap.api.services.** { *; }
#2D地图
-keep class com.amap.api.maps2d.**{*;}
-keep class com.amap.api.mapcore2d.**{*;}
#Google Play Services
-keep class com.google.android.gms.common.** {*;}
-keep class com.google.android.gms.ads.identifier.** {*;}
-keepattributes Signature,*Annotation*,EnclosingMethod
-dontwarn com.google.android.gms.**

#MPAndroidChart
-keep class com.github.mikephil.charting.** { *; }
-dontwarn com.github.mikephil.charting.**

-keep class com.tuya.**.**{*;}
-dontwarn com.tuya.**.**

-keep class com.smart.rinoiot.post.**{*;}
-keep class com.smart.rinoiot.push.**{*;}
-keep,includedescriptorclasses class com.facebook.v8.** { *; }

#灯带


#---------------------------------默认保留区---------------------------------

-keepclasseswithmembernames class * {
    native <methods>;
}
-keepclassmembers class * extends android.app.Activity{
    public void *(android.view.View);
}

-keep public class * extends android.view.View{
    *** get*();
    void set*(***);
    public <init>(android.content.Context);
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keep class * implements android.os.Parcelable {
}
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}
-keep class **.R$* {
 *;
}
-keepclassmembers class * {
    void *(**On*Event);
}
#----------------------------------------------------------------------------

#---------------------------------webview------------------------------------
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView, java.lang.String, android.graphics.Bitmap);
    public boolean *(android.webkit.WebView, java.lang.String);
}
-keepclassmembers class * extends android.webkit.WebViewClient {
    public void *(android.webkit.WebView);
}
#----------------------------------------------------------------------------
#---------------------------------------------------------------------------------------------------

# Application classes that will be serialized/deserialized over Gson
# Prevent proguard from stripping interface information from TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}


# 保留ServiceLoaderInit类，需要反射调用
-keep class com.sankuai.waimai.router.generated.ServiceLoaderInit { *; }
# 避免注解在shrink阶段就被移除，导致obfuscate阶段注解失效、实现类仍然被混淆
-keep @interface com.sankuai.waimai.router.annotation.RouterService
#微信和QQ第三方登录混淆
-dontwarn com.tencent.bugly.**
-keep public class com.tencent.**{*;}


-keep public class com.horcrux.svg.** {*;}
#友盟混淆
-keep class com.umeng.** { *; }

-keep class com.uc.** { *; }

-keep class com.efs.** { *; }

-keepclassmembers enum *{
      publicstatic**[] values();
      publicstatic** valueOf(java.lang.String);
}
-keep class com.umeng.**{*;}

-keepclassmembers class *{
public <init> (org.json.JSONObject);
}

-keepclassmembers enum *{
public static **[] values();
public static ** valueOf(java.lang.String);
}
-keepattributes *Annotation*
-keepclassmembers class * {
    @org.greenrobot.eventbus.Subscribe <methods>;
}
-keep enum org.greenrobot.eventbus.ThreadMode { *; }

# If using AsyncExecutord, keep required constructor of default event used.
# Adjust the class name if a custom failure event type is used.
-keepclassmembers class org.greenrobot.eventbus.util.ThrowableFailureEvent {
    <init>(java.lang.Throwable);
}

# Accessed via reflection, avoid renaming or removal
-keep class org.greenrobot.eventbus.android.AndroidComponentsImpl

-keep class com.smart.rinoiot.common.mqtt.payload.** { *; }

#华为扫码混淆
-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep class com.huawei.hianalytics.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}

#第三方图片选择库
-keep class com.luck.picture.lib.** { *; }

# use Camerax
-keep class com.luck.lib.camerax.** { *; }

# use Camerax use uCrop
-dontwarn com.yalantis.ucrop**
-keep class com.yalantis.ucrop** { *; }
-keep interface com.yalantis.ucrop** { *; }
#混淆权限
-keep class pub.devrel.easypermissions.**{*;}
-keep class com.smart.rinoiot.common_sdk.permission.**{*;}

#声网混淆
-keep class io.agora.**{*;}
#微信和QQ第三方登录混淆
-dontwarn com.tencent.bugly.**
-keep public class com.tencent.**{*;}

#vivo推送混淆
-dontwarn com.vivo.push.**

-keep class com.vivo.push.**{*; }

-keep class com.vivo.vms.**{*; }

-keep class com.smart.rinoiot.upush.vivo.RinoVivoPushMessageReceiverImpl{*;}

#oppo推送混淆
-keep public class * extends android.app.Service
-keep class com.heytap.msp.** { *;}
#声网混淆
-keep class io.agora.**{*;}
-dontwarn javax.**
-dontwarn com.google.devtools.build.android.**

#阿里支付
-keep class com.alipay.android.app.IAlixPay{*;}
-keep class com.alipay.android.app.IAlixPay$Stub{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback{*;}
-keep class com.alipay.android.app.IRemoteServiceCallback$Stub{*;}
-keep class com.alipay.sdk.app.PayTask{ public *;}
-keep class com.alipay.sdk.app.AuthTask{ public *;}
-keep class com.alipay.sdk.app.H5PayCallback {
    <fields>;
    <methods>;
}
-keep class com.alipay.android.phone.mrpc.core.** { *; }
-keep class com.alipay.apmobilesecuritysdk.** { *; }
-keep class com.alipay.mobile.framework.service.annotation.** { *; }
-keep class com.alipay.mobilesecuritysdk.face.** { *; }
-keep class com.alipay.tscenter.biz.rpc.** { *; }
-keep class org.json.alipay.** { *; }
-keep class com.alipay.tscenter.** { *; }
-keep class com.ta.utdid2.** { *;}
-keep class com.ut.device.** { *;}

#bridge
-keep class * extends android.widget.BaseAdapter{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public static <fields>;#保持该类下所有的共有内容不被混淆
}

#-keep class com.smart.rinoiot.bridge.*{
#      public <methods>;#保持该类下所有的共有方法不被混淆
#      public <fields>;#保持该类下所有的共有内容不被混淆
#}

-keep class com.smart.rinoiot.bridge.listener.**{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.bridge.manager.**{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#chat

-keep class com.smart.rinoiot.chat.bean.** {*;}

-keep class com.smart.rinoiot.chat.dao.**{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.chat.emojick.EmojickUtils{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.chat.listener.**{*;}

-keep class com.smart.rinoiot.chat.manager.**{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.chat.network.ChatHostManager{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.chat.network.RetrofitChatUtils{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.chat.utils.**{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.chat.websocket.**{*;}

#common_sdk

-keep class com.smart.rinoiot.common_sdk.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.common_sdk.bean**{*;}

-keep class com.smart.rinoiot.common_sdk.base.*{
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
      protected <fields>;#保持该类下所有的共有方法不被混淆
}
-keep class com.smart.rinoiot.common_sdk.page.*{
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
      protected <fields>;#保持该类下所有的共有方法不被混淆
}
#内部类补混淆
-keep class com.smart.rinoiot.common_sdk.**$*{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#connect_sdk

-keep class com.smart.rinoiot.connect_sdk.bean.** {*;}

-keep class com.smart.rinoiot.connect_sdk.ble.listener**{*;}


-keep class com.smart.rinoiot.connect_sdk.ble.manager.**{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.connect_sdk.ble.utils.**{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.connect_sdk.ble.BleConfigConstant{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.connect_sdk.ble.BleResponseCodeConstant{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.connect_sdk.enums.**{*;}

-keep class com.smart.rinoiot.connect_sdk.wifi.WifiManagerProxy{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.connect_sdk.wifi.WifiConnectPanelListener{*;}

-keep class com.smart.rinoiot.connect_sdk.ConnectConstant{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.connect_sdk.wifi.CacheWifiSsidManager{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.connect_sdk.udp.UdpTools{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.connect_sdk.udp.UdpAlertUtils{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

#connect_ui

-keep class com.smart.rinoiot.connect_ui.bean.** {*;}

-keep class com.smart.rinoiot.connect_ui.view.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.connect_ui.ConnectUiConstant {*;}

#crash
-keep class com.smart.rinoiot.crash.inter.FileSaveStatusListener { *;}

-keep class com.smart.rinoiot.crash.CrashHandler{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#device_sdk
-keep class com.smart.rinoiot.device_sdk.DeviceConstant{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.device_sdk.cache.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.device_sdk.device.listener.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.device_sdk.device.manager.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.device_sdk.group.GroupManager{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.device_sdk.group.manager.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.device_sdk.matter.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.device_sdk.utils.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.device_sdk.bean.**{*;}
-keep class com.smart.rinoiot.device_sdk.bean.**$**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}

#device_shared
-keep class com.smart.rinoiot.device_shared_kit.manager.*{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}

#device_shared_ui
-keep class com.smart.rinoiot.device_shared.DeviceShareConstant {*;}

#device_ui
-keep class com.smart.rinoiot.device_ui.bean.** {*;}

-keep class com.smart.rinoiot.device_ui.device.view.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.device_ui.DeviceUiConstant {*;}

#family-kit

-keep class com.smart.rinoiot.family_kit.bean.** {*;}

-keep class com.smart.rinoiot.family_kit.FamilyNetworkManager{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#family-ui

-keep class com.smart.rinoiot.family_ui.bean.** {*;}

-keep class com.smart.rinoiot.family_ui.listener.** {*;}

-keep class com.smart.rinoiot.family_ui.manager.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.family_ui.view.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.family_ui.FamilyConstant {*;}

-keep class com.smart.rinoiot.family_ui.viewmodel.FamilyViewModel {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.family_ui.fragment.RoomFragment {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.family_ui.fragment.FamilyFragment {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}

#feedback-kit
-keep class com.smart.rinoiot.feedback_kit.network.FeedBackHostManager{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#feedback-ui
-keep class com.smart.rinoiot.feedback_ui.manager.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.feedback_ui.view.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}

#ipc
-keep class com.p2p.pppp_api.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}
#内部类补混淆
-keep class com.p2p.pppp_api.**$*{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public static <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.rino.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}
#内部类补混淆
-keep class com.rino.**$*{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public static <fields>;#保持该类下所有的共有内容不被混淆
}

#map
-keep class com.smart.rinoiot.map.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public static <fields>;#保持该类下所有的共有内容不被混淆
}

#matter
-keep class com.smart.rinoiot.matter.manager.** {
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.matter.model.**{*;}

-keep class com.smart.rinoiot.matter.util.** {
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#module_ble
-keep class com.smart.rinoiot.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
}

#mqtt_sdk
-keep class com.smart.rinoiot.mqtt_sdk.bean.** { *;}
-keep class com.smart.rinoiot.mqtt_sdk.listener.** { *;}

-keep class com.smart.rinoiot.mqtt_sdk.Manager.**{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.mqtt_sdk.MqttConstant{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#msg_sdk
-keep class com.smart.rinoiot.msg_sdk.bean.** {*;}

-keep class com.smart.rinoiot.msg_sdk.manager.**{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#msg_ui
-keep class com.smart.rinoiot.msg_ui.listener.** { *;}
-keep class com.smart.rinoiot.msg_ui.manager.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.msg_ui.view.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.msg_ui.MsgConstant {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

#nfc_sdk
-keep class com.smart.rinoiot.nfc_sdk.bean.** {*;}

-keep class com.smart.rinoiot.nfc_sdk.NfcConstant{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#nfc_ui
-keep class com.smart.rinoiot.nfc_ui.bean.** {*;}

-keep class com.smart.rinoiot.nfc_ui.listener.** {*;}

-keep class com.smart.rinoiot.nfc_ui.manager.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.nfc_ui.view.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}

#oss
-keep class com.rinoiot.oss.enums.** { *;}

-keep class com.rinoiot.oss.model.**{*;}

-keep class com.rinoiot.oss.OssConstant{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.rinoiot.oss.OSSUpdateManager{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.rinoiot.oss.inter.**{*;}
#内部类不混淆
-keep class com.rinoiot.oss.**$*{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.rinoiot.oss.OssManager{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#panel_sdk

-keep class com.smart.rinoiot.panel_sdk.bean.** {*;}

-keep class com.smart.rinoiot.panel_sdk.comfun.CommonCloseListener {*;}

-keep class com.smart.rinoiot.panel_sdk.comfun.CommonEventManager {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.comfun.CommonPanelUtils {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.confignetwork.** {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.ipc.AgoraBusinessPlugin {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.ipc.AgoraBusinessPlugin.*$** {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.manager.** {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.module.NativeSystemEnum {*;}

-keep class com.smart.rinoiot.panel_sdk.module.** {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.nofitycallback.** {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.rnfs.** {
        public <methods>;#保持该类下所有的共有方法不被混淆
        protected <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
        protected <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.rnfs.**$** {
        public <methods>;#保持该类下所有的共有方法不被混淆
        protected <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
        protected <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.utils.** {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.BundleJSONConverter {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.RinoReactNativeHost {
        public <methods>;#保持该类下所有的共有方法不被混淆
        protected <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
        protected <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.RinoReactNativeHost.$** {
        public <methods>;#保持该类下所有的共有方法不被混淆
        protected <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
        protected <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.RnConstant {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.RNLanguageUtils {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.RNNotifyConstant {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.UniversalPanelUtils {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.panel_sdk.view.CommonFunView {
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

#scan

-keep class com.smart.rinoiot.scan.manager.MNScanManager{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public static <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.scan.utils.CreateQrCodeUtils{
      public <methods>;#保持该类下所有的共有方法不被混淆
      public static <fields>;#保持该类下所有的共有内容不被混淆
}
#保留这个实现类不被混淆
-keep interface com.smart.rinoiot.scan.listener.ScanCodeListener{*;}
#内部类不被混淆
-keep class com.smart.rinoiot.**$* {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public static <fields>;#保持该类下所有的共有内容不被混淆
}

#scan_ui

-keep class com.smart.rinoiot.scan_ui.bean.** {*;}

-keep class com.smart.rinoiot.scan_ui.Manager.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}

#scene_sdk

-keep class com.smart.rinoiot.scene_sdk.bean.** { *;}
-keep class com.smart.rinoiot.scene_sdk.enumbean.** { *;}

-keep class com.smart.rinoiot.scene_sdk.manager.**{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.scene_sdk.SceneConstant{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

#scene_ui

-keep class com.smart.rinoiot.scene_ui.view.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.scene_ui.NFCSceneEventBean {*;}

-keep class com.smart.rinoiot.scene_ui.SceneUiConstant {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

#upush

-keep class com.smart.rinoiot.upush.bean.** {*;}

-keep class com.smart.rinoiot.upush.NotificationUtil{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.upush.PushManager{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.upush.umeng.PushConstants{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.upush.UPushConstant{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}
-keep class com.smart.rinoiot.verify.RinoUMVerifyHelper{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.upush.listener.DialogNotifyListener {*;}

-keep class com.smart.rinoiot.verify.VerifyListener {*;}

#user_sdk

-keep class com.smart.rinoiot.user_sdk.bean.** {*;}

-keep class com.smart.rinoiot.user_sdk.config.**{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.user_sdk.listener.**{*;}

-keep class com.smart.rinoiot.user_sdk.manager.**{
       public <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.user_sdk.userenum.**{*;}

-keep class com.smart.rinoiot.user_sdk.UserConstant{
        public <methods>;#保持该类下所有的共有方法不被混淆
        public <fields>;#保持该类下所有的共有内容不被混淆
}

#user_ui

-keep class com.smart.rinoiot.user_ui.bean.** {*;}


-keep class com.smart.rinoiot.user_ui.manager.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.user_ui.tab.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.user_ui.update.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.user_ui.view.** {
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public  <fields>;#保持该类下所有的共有内容不被混淆
      protected  <fields>;#保持该类下所有的共有内容不被混淆
}

-keep class com.smart.rinoiot.user_ui.UserUiConstant {*;}

#xpopup

-keep class com.lxj.xpopup.**{
      public <methods>;#保持该类下所有的共有方法不被混淆
      protected <methods>;#保持该类下所有的共有方法不被混淆
      public <fields>;#保持该类下所有的共有内容不被混淆
      protected <fields>;#保持该类下所有的共有内容不被混淆
}

#内部类补混淆
-keep class com.lxj.xpopup.**$*{
       public <methods>;#保持该类下所有的共有方法不被混淆
       protected <methods>;#保持该类下所有的共有方法不被混淆
       public <fields>;#保持该类下所有的共有内容不被混淆
       protected <fields>;#保持该类下所有的共有内容不被混淆
}
