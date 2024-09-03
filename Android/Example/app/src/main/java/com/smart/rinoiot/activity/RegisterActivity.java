package com.smart.rinoiot.activity;

import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;

import com.smart.rinoiot.common_sdk.base.BaseActivity;
import com.smart.rinoiot.common_sdk.manager.AppManager;
import com.smart.rinoiot.common_sdk.manager.UserInfoDataManager;
import com.smart.rinoiot.databinding.ActivityRegisterBinding;
import com.smart.rinoiot.model.LoginModel;
import com.smart.rinoiot.user_sdk.bean.CountryBean;
import com.smart.rinoiot.user_sdk.manager.CacheCountryManager;
import com.smart.rinoiot.user_ui.activity.HomeActivity;

/**
 * @author tw
 * @time 2024/3/26 15:26
 * @description
 */
public class RegisterActivity extends BaseActivity<ActivityRegisterBinding, LoginModel> {

    @Override
    public String getToolBarTitle() {
        return null;
    }

    @Override
    public void init() {
        initListener();
        observe();
    }

    @Override
    public ActivityRegisterBinding getBinding(LayoutInflater layoutInflater) {
        return ActivityRegisterBinding.inflate(layoutInflater);
    }


    private void initListener() {
        binding.tvSend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mViewModel.sendRegisterCodeV2(binding.etAccount.getText(), countryCode);
            }
        });

        binding.tvRegister.setOnClickListener(v -> {
            mViewModel.checkCode(binding.etAccount.getText(), binding.etCode.getText().toString());
        });
    }

    String countryCode = "86";


    private void observe() {
        mViewModel.getUserLiveData().observe(this, userInfo -> {
            mViewModel.hideLoading();
            if (userInfo != null) {
                UserInfoDataManager.getInstance().saveUserInfo(userInfo);
                startActivity(new Intent(this, MainActivity.class));
                finishThis();
                AppManager.getInstance().finishActivity(LoginActivity.class);
            }
        });

        mViewModel.getCheckCodeLiveData().observe(this, isSuccess -> {
            mViewModel.hideLoading();
            if (isSuccess) {
                CountryBean countryBean = CacheCountryManager.getInstance().getCurrentCountry();
                if (countryBean != null) {
                    countryCode = countryBean.getCountryCode();
                }
                mViewModel.register(
                        binding.etAccount.getText(),
                        CacheCountryManager.getInstance().getCurrentCountryCode(),
                        binding.etPassword.getText(), binding.etCode.getText().toString()
                );
            }
        });
    }
}
