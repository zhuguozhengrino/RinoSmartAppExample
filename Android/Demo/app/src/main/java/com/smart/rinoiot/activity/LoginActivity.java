package com.smart.rinoiot.activity;

import android.content.Intent;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.smart.rinoiot.common_sdk.base.BaseActivity;
import com.smart.rinoiot.common_sdk.bean.AppCommonConfigBean;
import com.smart.rinoiot.common_sdk.bean.UserInfoBean;
import com.smart.rinoiot.common_sdk.config.ServiceConfigConstant;
import com.smart.rinoiot.common_sdk.listener.CallbackListener;
import com.smart.rinoiot.common_sdk.manager.UserInfoDataManager;
import com.smart.rinoiot.common_sdk.utils.LgUtils;
import com.smart.rinoiot.databinding.ActivityLoginBinding;
import com.smart.rinoiot.device_sdk.cache.CacheDeviceDataManager;
import com.smart.rinoiot.model.LoginModel;
import com.smart.rinoiot.mqtt_sdk.Manager.MqttManager;
import com.smart.rinoiot.user_sdk.bean.CountryBean;
import com.smart.rinoiot.user_sdk.manager.CacheAppDataCenterManager;
import com.smart.rinoiot.user_sdk.manager.CacheCountryManager;
import com.smart.rinoiot.user_sdk.manager.CountryAndDomainManager;
import com.smart.rinoiot.user_sdk.manager.UserNetworkManager;
import com.smart.rinoiot.user_ui.activity.CountryActivity;
import com.smart.rinoiot.user_ui.manager.UserManager;

/**
 * @author tw
 * @time 2024/3/26 15:26
 * @description
 */
public class LoginActivity extends BaseActivity<ActivityLoginBinding, LoginModel> {

    @Override
    public String getToolBarTitle() {
        return null;
    }

    @Override
    public void init() {
        UserInfoBean userInfo = UserInfoDataManager.getInstance().getUserInfo(this);
        if (userInfo == null) {//用户以登录，不重新请求数据
            CacheAppDataCenterManager.getInstance().saveDataAppRegisterType(null);
//            if (!UserInfoDataManager.getInstance().isLogin(this)) {//未登录时，才授权一键登录
//                uMVerifyInitData();
//            }
            CacheDeviceDataManager.getInstance().clear();
            CountryAndDomainManager.getInstance().initDomainAndMqttUpdate(this);//获取服务地址、端口、mqtt地址
            ServiceConfigConstant.SHAKE_FLAG = UserManager.getInstance().isShakeDebugOpen();//支持摇一摇
            ServiceConfigConstant.PANEL_DEBUG = UserManager.getInstance().isPanelDebugOpen();//支持面板debug
            //获取数据中心接口，单独请求，拿到响应数据
            initFlashData();
            mViewModel.getNetCountryList();
        } else {
            CacheAppDataCenterManager.getInstance().setDataCenter();
            UserNetworkManager.getInstance().getAppCommonConfig(callbackListener);//通用接口配置
        }
        initListener();
        observe();
    }

    @Override
    public ActivityLoginBinding getBinding(LayoutInflater layoutInflater) {
        return ActivityLoginBinding.inflate(layoutInflater);
    }

    CallbackListener<AppCommonConfigBean> callbackListener = new CallbackListener<AppCommonConfigBean>() {
        @Override
        public void onSuccess(AppCommonConfigBean data) {
            LgUtils.w(TAG + "  init    onSuccess  data=" + new Gson().toJson(data));
            ServiceConfigConstant.SHAKE_FLAG = UserManager.getInstance().isShakeDebugOpen();//支持摇一摇
            ServiceConfigConstant.PANEL_DEBUG = UserManager.getInstance().isPanelDebugOpen();//支持面板debug
            //获取数据中心接口，单独请求，拿到响应数据
            initFlashData();
            mViewModel.getNetCountryList();
        }

        @Override
        public void onError(String code, String error) {
            LgUtils.w(TAG + "    init  onError  code=" + code + "   error=" + error);

        }
    };

    private void initFlashData() {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                countryBean = CacheCountryManager.getInstance().getCurrentCountry();
                if (countryBean != null) {
                    binding.tvCountryName.setText(countryBean.getCountryName());
                }
            }
        }, 2000);
        if (UserInfoDataManager.getInstance().isLogin(this)) {
            UserInfoBean userInfo = UserInfoDataManager.getInstance().getUserInfo(this);
            if (userInfo != null) {
                MqttManager.getInstance().mqttConnectInit(userInfo, this);
            }
            startActivity(new Intent(this, MainActivity.class));
            finishThis();
        }
    }

    private void initListener() {
        binding.viewCountry.setOnClickListener(v -> startActivityForResult(new Intent(this, CountryActivity.class), 1000));

        binding.tvLogin.setOnClickListener(v -> {
            if (countryBean != null) {
                countryCode = countryBean.getCountryCode();
            }
            mViewModel.loginWithAccount(binding.etAccount.getText(),
                    binding.etPassword.getText(), countryCode);
        });
        binding.tvRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(LoginActivity.this, RegisterActivity.class));
            }
        });
    }

    private CountryBean countryBean;
    String countryCode = "86";

    @Override
    protected void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode != RESULT_OK) return;

        if (requestCode == 1000) {
            countryBean = CacheCountryManager.getInstance().getCurrentCountry();
            if (countryBean != null) {
                countryCode = countryBean.getCountryCode();
                binding.tvCountryName.setText(countryBean.getCountryName());
            }
            if (countryBean != null) {
                CountryAndDomainManager.getInstance().getDataCenterList();
            }
        }
    }

    private void observe() {
        mViewModel.getUserLiveData().observe(this, userInfo -> {
            mViewModel.hideLoading();
            if (userInfo != null) {
                UserInfoDataManager.getInstance().saveUserInfo(userInfo);
                startActivity(new Intent(this, MainActivity.class));
                finishThis();
            }
        });
    }
}
