package com.smart.rinoiot;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;

import com.facebook.react.ReactApplication;
import com.facebook.react.ReactNativeHost;
import com.facebook.soloader.SoLoader;
import com.smart.rinoiot.chat.manager.DaoManager;
import com.smart.rinoiot.chat.network.RetrofitChatUtils;
import com.smart.rinoiot.common_sdk.CommonConstant;
import com.smart.rinoiot.common_sdk.base.BaseApplication;
import com.smart.rinoiot.common_sdk.cache.SharedPreferenceUtil;
import com.smart.rinoiot.common_sdk.manager.FunInitManager;
import com.smart.rinoiot.common_sdk.network.RetrofitUtils;
import com.smart.rinoiot.common_sdk.utils.LgUtils;
import com.smart.rinoiot.connect_sdk.ble.manager.BleManager;
import com.smart.rinoiot.device_sdk.matter.MtrDeviceShareManager;
import com.smart.rinoiot.crash.CrashHandler;
import com.smart.rinoiot.feedback_kit.FeedBackRequestUtils;
import com.smart.rinoiot.nfc_sdk.NfcConstant;
import com.smart.rinoiot.panel_sdk.RinoReactNativeHost;
import com.smart.rinoiot.panel_sdk.RnConstant;
import com.smart.rinoiot.panel_sdk.manager.V8ExecutorFactoryManager;
import com.smart.rinoiot.resource.BuildConfig;
import com.smart.rinoiot.upush.PushManager;
import com.smart.rinoiot.user_sdk.UserConstant;
import com.smart.rinoiot.user_ui.UserUiConstant;
import com.smart.rinoiot.user_ui.manager.UserManager;

import dagger.hilt.android.HiltAndroidApp;

@HiltAndroidApp
public class App extends BaseApplication implements ReactApplication {

    private RinoReactNativeHost mReactNativeHost;


    @Override
    public void onCreate() {
        super.onCreate();
        V8ExecutorFactoryManager.getInstance(this).init();
        SharedPreferenceUtil.getInstance().init(this);
        if (SharedPreferenceUtil.getInstance().get(UserUiConstant.ConsentPrivacy, false)) {
            init();
        }
        //强制杀掉进程时，activity生命周期不会走onDestroy方法，所以app里面必须设置一下对应的值
        SharedPreferenceUtil.getInstance().put(NfcConstant.APP_START_HOME_PAGE, false);
        SharedPreferenceUtil.getInstance().put(RnConstant.CURRENT_PANEL_DEV_UUID, "");
    }

    @Override
    public void init() {
        mReactNativeHost = new RinoReactNativeHost(this);
        setLogDebug(BuildConfig.DEBUG);//网络请求及日志是否打印出来
        UserManager.getInstance().setPanelDebug(BuildConfig.DEBUG);//是否开启面板摇一摇功能
        UserManager.getInstance().setShakeDebug(BuildConfig.DEBUG);//是否开启环境切换功能
        DaoManager.getInstance().init(this);
        RetrofitChatUtils.init(this);
        FeedBackRequestUtils.getInstance().init(this);
        FunInitManager.getInstance().init(this);
        BleManager.init(this);
        // Soloader 加载JSC引擎
        SoLoader.init(this, false);
        CrashHandler.getInstance().init(this);
        MtrDeviceShareManager.getInstance().init(this);
        getMetaData();
    }


    @Override
    public ReactNativeHost getReactNativeHost() {
        return mReactNativeHost;
    }


    /**
     * build配置获取
     */
    public void getMetaData() {
        ApplicationInfo appInfo;
        try {
            appInfo = getApplication().getPackageManager().getApplicationInfo(getApplication().getPackageName(), PackageManager.GET_META_DATA);
            UserConstant.CURRENT_CHANNEL = appInfo.metaData.getString("CURRENT_CHANNEL");
            CommonConstant.RN_CORE_VERSION = appInfo.metaData.getString("RN_CORE_VERSION");
            LgUtils.e("Constant.CURRENT_CHANNEL=" + UserConstant.CURRENT_CHANNEL
                    + "  CommonConstant.RN_CORE_VERSION=" + CommonConstant.RN_CORE_VERSION);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * 网络请求及日志是否打印出来
     */
    public void setLogDebug(boolean isDebug) {
        LgUtils.setOpenLog(isDebug);
        DaoManager.getInstance().setOpenDebug(isDebug);
        RetrofitUtils.setOpenLog(isDebug);
        RetrofitChatUtils.setOpenLog(isDebug);
        FeedBackRequestUtils.getInstance().setOpenLog(isDebug);
        //友盟初始化
        if (!isDebug) {
            PushManager.getInstance().initUPush(this);
        }
    }
}
