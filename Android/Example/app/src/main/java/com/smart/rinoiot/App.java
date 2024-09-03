package com.smart.rinoiot;

import com.smart.rinoiot.common_sdk.base.BaseApplication;
import com.smart.rinoiot.user_biz.manager.UserExternalManager;

import dagger.hilt.android.HiltAndroidApp;

@HiltAndroidApp
public class App extends BaseApplication {
    @Override
    public void onCreate() {
        super.onCreate();
        UserExternalManager.preInit(this);
        UserExternalManager.init(this);
    }

    @Override
    public void init() {
        UserExternalManager.init(this);
    }

}
