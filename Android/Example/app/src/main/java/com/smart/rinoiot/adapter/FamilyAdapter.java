package com.smart.rinoiot.adapter;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.viewholder.BaseViewHolder;
import com.smart.rinoiot.R;
import com.smart.rinoiot.device_sdk.bean.AssetBean;

import org.jetbrains.annotations.NotNull;

/**
 * @description
 */
public class FamilyAdapter extends BaseQuickAdapter<AssetBean, BaseViewHolder> {

    public FamilyAdapter() {
        super(R.layout.adapter_item);
    }

    @Override
    protected void convert(@NotNull BaseViewHolder baseViewHolder, AssetBean assetBean) {
        baseViewHolder.setText(R.id.tvName, assetBean.getName());

    }

}
