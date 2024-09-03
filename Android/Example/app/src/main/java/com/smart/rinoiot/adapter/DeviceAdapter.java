package com.smart.rinoiot.adapter;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.viewholder.BaseViewHolder;
import com.smart.rinoiot.R;
import com.smart.rinoiot.device_sdk.bean.device.DeviceInfoBean;

import org.jetbrains.annotations.NotNull;

/**
 * @description 设备列表
 */
public class DeviceAdapter extends BaseQuickAdapter<DeviceInfoBean, BaseViewHolder> {

    public DeviceAdapter() {
        super(R.layout.adapter_item);
    }

    @Override
    protected void convert(@NotNull BaseViewHolder baseViewHolder, DeviceInfoBean infoBean) {
        baseViewHolder.setText(R.id.tvName, infoBean.getName());

    }

}
