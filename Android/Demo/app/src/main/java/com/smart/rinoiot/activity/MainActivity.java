package com.smart.rinoiot.activity;

import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;

import com.smart.rinoiot.common_sdk.PageActivityPathUtils;
import com.smart.rinoiot.common_sdk.base.BaseActivity;
import com.smart.rinoiot.connect_ui.activity.AutoScanActivity;
import com.smart.rinoiot.databinding.ActivityMainBinding;
import com.smart.rinoiot.family_ui.activity.FamilyManagerActivity;
import com.smart.rinoiot.model.MainModel;
import com.smart.rinoiot.mqtt_sdk.Manager.MqttListenerManager;
import com.smart.rinoiot.msg_ui.activity.rino.MsgListActivity;
import com.smart.rinoiot.scene_sdk.SceneConstant;
import com.smart.rinoiot.user_ui.activity.setting.SettingActivity;

/**
 * @author tw
 * @time 2024/3/26 15:26
 * @description
 */
public class MainActivity extends BaseActivity<ActivityMainBinding, MainModel> {

    @Override
    public String getToolBarTitle() {
        return null;
    }

    @Override
    public void init() {
        MqttListenerManager.getInstance().setMqttMessageCallBack(mViewModel);
        mViewModel.getFamilyList(true);
        mViewModel.subscribeUserIdNotify(this);
        binding.tvFamily.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, FamilyActivity.class));
            }
        });
        binding.tvFamilyManager.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, FamilyManagerActivity.class));
            }
        });
        binding.tvDeviceList.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, DeviceListActivity.class));
            }
        });
        binding.tvSceneList.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, SceneListActivity.class));
            }
        });
        binding.tvMsg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, MsgListActivity.class));
            }
        });
        binding.tvAddDevice.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, AutoScanActivity.class));
            }
        });

        binding.tvAddOneKeyScene.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClassName(MainActivity.this, PageActivityPathUtils.CREATE_SCENE_ACTIVITY);
                intent.putExtra(SceneConstant.SCENE_TYPE, 0);
                startActivity(intent);
            }
        });


        binding.tvAddAutoScene.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent();
                intent.setClassName(MainActivity.this, PageActivityPathUtils.CREATE_SCENE_ACTIVITY);
                intent.putExtra(SceneConstant.SCENE_TYPE, 1);
                startActivity(intent);
            }
        });
        binding.tvSetting.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, SettingActivity.class));
            }
        });
    }

    @Override
    public ActivityMainBinding getBinding(LayoutInflater layoutInflater) {
        return ActivityMainBinding.inflate(layoutInflater);
    }
}
