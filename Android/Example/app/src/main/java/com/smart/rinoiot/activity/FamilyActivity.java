package com.smart.rinoiot.activity;

import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;

import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.listener.OnItemClickListener;
import com.smart.rinoiot.adapter.FamilyAdapter;
import com.smart.rinoiot.common_sdk.base.BaseActivity;
import com.smart.rinoiot.databinding.ActivityListBinding;
import com.smart.rinoiot.device_sdk.bean.AssetBean;
import com.smart.rinoiot.model.MainModel;

/**
 * @author tw
 * @time 2024/3/26 15:26
 * @description 家庭列表
 */
public class FamilyActivity extends BaseActivity<ActivityListBinding, MainModel> {
    private FamilyAdapter familyAdapter;

    @Override
    public String getToolBarTitle() {
        return null;
    }

    @Override
    public void init() {
        familyAdapter = new FamilyAdapter();
        binding.recyclerView.setAdapter(familyAdapter);
        mViewModel.getFamilyList(false);
        mViewModel.getAssetListLiveData().observe(this, assetBeans -> familyAdapter.setList(assetBeans));
        familyAdapter.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(@NonNull BaseQuickAdapter<?, ?> adapter, @NonNull View view, int position) {
                AssetBean item = (AssetBean) adapter.getItem(position);
                mViewModel.getFamilyDetail(true,item.getId());
            }
        });
    }

    @Override
    public ActivityListBinding getBinding(LayoutInflater layoutInflater) {
        return ActivityListBinding.inflate(layoutInflater);
    }
}
