package com.smart.rinoiot.adapter;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.viewholder.BaseViewHolder;
import com.smart.rinoiot.R;
import com.smart.rinoiot.scene_sdk.bean.custom.RuleUserInstanceBean;

import org.jetbrains.annotations.NotNull;

/**
 * @description 场景列表
 */
public class SceneAdapter extends BaseQuickAdapter<RuleUserInstanceBean, BaseViewHolder> {

    public SceneAdapter() {
        super(R.layout.adapter_item);
    }

    @Override
    protected void convert(@NotNull BaseViewHolder baseViewHolder, RuleUserInstanceBean infoBean) {
        baseViewHolder.setText(R.id.tvName, infoBean.getInstanceName());

    }

}
