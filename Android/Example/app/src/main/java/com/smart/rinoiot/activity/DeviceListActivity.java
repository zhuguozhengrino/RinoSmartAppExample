package com.smart.rinoiot.activity;

import android.view.LayoutInflater;

import androidx.lifecycle.Observer;

import com.smart.rinoiot.adapter.DeviceAdapter;
import com.smart.rinoiot.common_sdk.base.BaseActivity;
import com.smart.rinoiot.common_sdk.utils.AntiShakeUtils;
import com.smart.rinoiot.common_sdk.utils.LgUtils;
import com.smart.rinoiot.databinding.ActivityListBinding;
import com.smart.rinoiot.device_sdk.bean.device.DeviceInfoBean;
import com.smart.rinoiot.device_sdk.cache.CacheDeviceDataManager;
import com.smart.rinoiot.device_sdk.matter.MatterDeviceDataUtils;
import com.smart.rinoiot.device_sdk.matter.manager.MtrDeviceStatesManager;
import com.smart.rinoiot.model.MainModel;
import com.smart.rinoiot.panel_sdk.RnConstant;
import com.smart.rinoiot.panel_sdk.manager.PanelControlManager;

import java.util.List;

/**
 * @author tw
 * @time 2024/3/26 15:26
 * @description 设备列表
 */
public class DeviceListActivity extends BaseActivity<ActivityListBinding, MainModel> {
    private DeviceAdapter deviceAdapter;

    @Override
    public String getToolBarTitle() {
        return null;
    }

    @Override
    public void init() {
        deviceAdapter = new DeviceAdapter();
        binding.recyclerView.setAdapter(deviceAdapter);
        mViewModel.getFamilyDetail(false, "");
        mViewModel.getDeviceListLiveData().observe(this, new Observer<List<DeviceInfoBean>>() {
            @Override
            public void onChanged(List<DeviceInfoBean> deviceInfoBeans) {
                deviceAdapter.setList(deviceInfoBeans);
            }
        });
        deviceAdapter.setOnItemClickListener((adapter, view, position) -> {
            DeviceInfoBean deviceInfoBean = (DeviceInfoBean) adapter.getItem(position);
            if (AntiShakeUtils.canResponseClick() && !RnConstant.ADD_PANEL_ENTRANCE) {
                RnConstant.ADD_PANEL_ENTRANCE = true;
                AntiShakeUtils.updateLastClickTime();
                LgUtils.w("bluetooth --> notify   uiid==" + deviceInfoBean.getUuid());
                if (deviceInfoBean.isHeader()) return;
                if (deviceInfoBean.isCustomGroup()) {//群组设备
                    if (deviceInfoBean.isGroupOffLineFlag()) {//群组下没有设备
                        RnConstant.ADD_PANEL_ENTRANCE = false;
                    } else {
                        PanelControlManager.getInstance().enterPanel(2, this, deviceInfoBean,
                                CacheDeviceDataManager.getInstance().getGroupDeviceInfo(deviceInfoBean.getGroupId()), false);
                    }

                } else if (MatterDeviceDataUtils.isMatterDevice(deviceInfoBean)) {//matter 配网设备
                    MtrDeviceStatesManager.getInstance(this).queryDeviceStatesAsync(deviceInfoBean);
                    PanelControlManager.getInstance().enterPanel(3, this, deviceInfoBean, null, false);

                } else {
                    PanelControlManager.getInstance().enterPanel(1, this, deviceInfoBean, null, false);
                }
            }
        });
    }

    @Override
    public ActivityListBinding getBinding(LayoutInflater layoutInflater) {
        return ActivityListBinding.inflate(layoutInflater);
    }
}
