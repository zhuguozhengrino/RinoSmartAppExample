package com.smart.rinoiot.model;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.MutableLiveData;

import com.smart.rinoiot.common_sdk.base.BaseViewModel;
import com.smart.rinoiot.common_sdk.bean.UserInfoBean;
import com.smart.rinoiot.common_sdk.listener.CallbackListener;
import com.smart.rinoiot.common_sdk.manager.UserInfoDataManager;
import com.smart.rinoiot.common_sdk.utils.ToastUtil;
import com.smart.rinoiot.mqtt_sdk.Manager.MqttManager;
import com.smart.rinoiot.user_sdk.bean.CountryBean;
import com.smart.rinoiot.user_sdk.bean.user.VerifyCodeBean;
import com.smart.rinoiot.user_sdk.manager.CacheCountryManager;
import com.smart.rinoiot.user_sdk.manager.UserNetworkManager;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 登录页逻辑处理
 */

public class LoginModel extends BaseViewModel {

    public LoginModel(@NonNull Application application) {
        super(application);
    }

    /**
     * 登录成功后用户数据监听
     */
    private final MutableLiveData<UserInfoBean> userLiveData = new MutableLiveData<>();
    /**
     * 校验成功回调
     */
    private final MutableLiveData<Boolean> checkCodeLiveData = new MutableLiveData<>();

    public MutableLiveData<UserInfoBean> getUserLiveData() {
        return userLiveData;
    }

    public MutableLiveData<Boolean> getCheckCodeLiveData() {
        return checkCodeLiveData;
    }

    /**
     * 获取国家地区列表
     */
    public void getNetCountryList() {
        List<CountryBean> countryList = CacheCountryManager.getInstance().getCountryList();
        if (countryList == null || countryList.isEmpty()) {

            UserNetworkManager.getInstance().getCountryList(new CallbackListener<List<CountryBean>>() {
                @Override
                public void onSuccess(List<CountryBean> data) {
                    hideLoading();
                    if (data != null && !data.isEmpty()) {
                        CacheCountryManager.getInstance().saveCountryList(data);

                    }
                }

                @Override
                public void onError(String code, String error) {
                    hideLoading();
                    ToastUtil.showMsg(error);
                }
            });
        }

    }


    /**
     * 校验验证码
     *
     * @param account    账号，邮箱或者手机号
     * @param verifyCode 验证码
     */
    public void checkCode(String account, String verifyCode) {
        UserNetworkManager.getInstance().checkVerifyCode(account, verifyCode, new CallbackListener<String>() {
            @Override
            public void onSuccess(String data) {
                checkCodeLiveData.postValue(true);
            }

            @Override
            public void onError(String code, String error) {
                ToastUtil.showMsg(error);
                checkCodeLiveData.postValue(false);
            }
        });
    }

    /**
     * 注册
     *
     * @param account    邮箱或手机号
     * @param areaCode   区域码
     * @param password   密码
     * @param verifyCode 验证码
     */
    public void register(String account, String areaCode, String password, String verifyCode) {
        UserNetworkManager.getInstance().registry(account, areaCode, password, verifyCode, new CallbackListener<UserInfoBean>() {
            @Override
            public void onSuccess(UserInfoBean data) {
                loginWithAccount(account.trim(), password.trim(), areaCode);
            }

            @Override
            public void onError(String code, String error) {
                ToastUtil.showMsg(error);
                userLiveData.postValue(null);
            }
        });
    }

    /**
     * 账号密码登录
     *
     * @param account  账号，邮箱或手机号
     * @param password 密码
     * @param areaCode 区域码
     */
    public void loginWithAccount(String account, String password, String areaCode) {
        UserNetworkManager.getInstance().loginWithAccount(account.trim(), password.trim(), areaCode, new CallbackListener<UserInfoBean>() {
            @Override
            public void onSuccess(UserInfoBean data) {
                getUserInfo(data);
            }

            @Override
            public void onError(String code, String error) {
                userLiveData.postValue(null);
                ToastUtil.showMsg(error);
            }
        });
    }

    private void getUserInfo(UserInfoBean userInfoBean) {
        UserInfoDataManager.getInstance().saveUserInfo(userInfoBean);
        UserNetworkManager.getInstance().getUserInfo(new CallbackListener<UserInfoBean>() {
            @Override
            public void onSuccess(UserInfoBean data) {
                UserInfoBean userInfo = UserInfoDataManager.getInstance().getUserInfo(getApplication());
                if (userInfo == null) userInfo = new UserInfoBean();
                if (data != null) {
                    userInfo.userName = data.userName;
                    userInfo.nickname = data.nickname;
                    userInfo.tz = data.tz;
                    userInfo.countryCode = data.countryCode;
                    userInfo.avatarUrl = data.avatarUrl;
                    userInfo.email = data.email;
                    userInfo.phoneNumber = data.phoneNumber;
                    userInfo.latestLoginTime = data.latestLoginTime;
                    userInfo.userType = data.userType;
                    userInfo.registryType = data.registryType;
                }
                userLiveData.postValue(userInfo);
                MqttManager.getInstance().mqttConnectInit(userInfo, getApplication());
            }

            @Override
            public void onError(String code, String error) {
                ToastUtil.showMsg(error);
                userLiveData.postValue(null);
            }
        });
    }


    public void sendRegisterCodeV2(String account, String countryCode) {
        Map<String, Object> params = new HashMap<>();
        params.put("countryCode", countryCode);
        params.put("input", account);
        showLoading();
        UserNetworkManager.getInstance().sendRegisterCodeV2(params, new CallbackListener<VerifyCodeBean>() {
            @Override
            public void onSuccess(VerifyCodeBean data) {
                hideLoading();
            }

            @Override
            public void onError(String code, String error) {
                hideLoading();
                ToastUtil.showMsg(error);
            }
        });
    }

}
