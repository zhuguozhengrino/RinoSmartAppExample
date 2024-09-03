package com.smart.rinoiot.activity;

import android.content.Intent;
import android.view.LayoutInflater;

import com.smart.rinoiot.adapter.SceneAdapter;
import com.smart.rinoiot.common_sdk.base.BaseActivity;
import com.smart.rinoiot.databinding.ActivityListBinding;
import com.smart.rinoiot.model.MainModel;
import com.smart.rinoiot.scene_biz.SceneBizConstant;
import com.smart.rinoiot.scene_sdk.SceneConstant;
import com.smart.rinoiot.scene_sdk.bean.custom.RuleUserInstanceBean;
import com.smart.rinoiot.scene_ui.activity.SceneConfigActivity;

/**
 * @author tw
 * @time 2024/3/26 15:26
 * @description 场景列表
 */
public class SceneListActivity extends BaseActivity<ActivityListBinding, MainModel> {
    private SceneAdapter sceneAdapter;

    @Override
    public String getToolBarTitle() {
        return null;
    }

    @Override
    public void init() {
        sceneAdapter = new SceneAdapter();
        binding.recyclerView.setAdapter(sceneAdapter);
        mViewModel.getInstanceList();
        mViewModel.getSceneListLiveData().observe(this, ruleUserInstanceBeans -> sceneAdapter.setList(ruleUserInstanceBeans));
        sceneAdapter.setOnItemClickListener((adapter, view, position) -> {
            RuleUserInstanceBean item = (RuleUserInstanceBean) adapter.getItem(position);
            if (item == null) return;
            startActivity(new Intent(this, SceneConfigActivity.class)
                    .putExtra(SceneBizConstant.SCENE_DETAIL, item)
                    .putExtra(SceneConstant.SCENE_TYPE, 3));
        });
    }

    @Override
    public ActivityListBinding getBinding(LayoutInflater layoutInflater) {
        return ActivityListBinding.inflate(layoutInflater);
    }
}
