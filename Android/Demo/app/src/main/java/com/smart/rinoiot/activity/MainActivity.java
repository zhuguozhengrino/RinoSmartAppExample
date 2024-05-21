package com.smart.rinoiot.activity;

import android.content.Intent;
import android.view.LayoutInflater;

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
        binding.tvFamily.setOnClickListener(v -> startActivity(new Intent(this, FamilyActivity.class)));

        binding.tvFamilyManager.setOnClickListener(v -> startActivity(new Intent(this, FamilyManagerActivity.class)));

        binding.tvDeviceList.setOnClickListener(v -> startActivity(new Intent(this, DeviceListActivity.class)));

        binding.tvSceneList.setOnClickListener(v -> startActivity(new Intent(this, SceneListActivity.class)));

        binding.tvMsg.setOnClickListener(v -> startActivity(new Intent(this, MsgListActivity.class)));

        binding.tvAddDevice.setOnClickListener(v -> startActivity(new Intent(this, AutoScanActivity.class)));

        binding.tvAddOneKeyScene.setOnClickListener(v -> {
            Intent intent = new Intent();
            intent.setClassName(this, PageActivityPathUtils.CREATE_SCENE_ACTIVITY);
            intent.putExtra(SceneConstant.SCENE_TYPE, 0);
            startActivity(intent);
        });


        binding.tvAddAutoScene.setOnClickListener(v -> {
            Intent intent = new Intent();
            intent.setClassName(this, PageActivityPathUtils.CREATE_SCENE_ACTIVITY);
            intent.putExtra(SceneConstant.SCENE_TYPE, 1);
            startActivity(intent);
        });
        binding.tvSetting.setOnClickListener(v -> startActivity(new Intent(this, SettingActivity.class)));

        binding.tvIpcDemo.setOnClickListener(v -> startActivity(new Intent(this, RinoIpcDemoActivity.class)));

        binding.tvIpcCloudDemo.setOnClickListener(v -> startActivity(new Intent(this, RinoIpcCloudReviewActivity.class)));
    }

    @Override
    public ActivityMainBinding getBinding(LayoutInflater layoutInflater) {
        return ActivityMainBinding.inflate(layoutInflater);
    }
}
