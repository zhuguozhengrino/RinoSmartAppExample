package com.smart.rinoiot.model;

import android.app.Application;
import android.content.Context;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.lifecycle.MutableLiveData;

import com.smart.rinoiot.common_sdk.base.BaseViewModel;
import com.smart.rinoiot.common_sdk.bean.UserInfoBean;
import com.smart.rinoiot.common_sdk.listener.CallbackListener;
import com.smart.rinoiot.common_sdk.manager.UserInfoDataManager;
import com.smart.rinoiot.common_sdk.utils.ToastUtil;
import com.smart.rinoiot.device_sdk.bean.AssetBean;
import com.smart.rinoiot.device_sdk.bean.device.DeviceInfoBean;
import com.smart.rinoiot.device_sdk.cache.CacheDeviceDataManager;
import com.smart.rinoiot.family_kit.FamilyNetworkManager;
import com.smart.rinoiot.family_ui.manager.MqttReceiveManager;
import com.smart.rinoiot.mqtt_sdk.Manager.MqttManager;
import com.smart.rinoiot.mqtt_sdk.Manager.TopicManager;
import com.smart.rinoiot.mqtt_sdk.listener.MqttMessageCallBack;
import com.smart.rinoiot.scene_sdk.bean.custom.RuleUserInstanceBean;
import com.smart.rinoiot.scene_sdk.manager.SceneNetworkManager;

import org.eclipse.paho.client.mqttv3.MqttMessage;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 */

public class MainModel extends BaseViewModel implements MqttMessageCallBack {

    public MainModel(@NonNull Application application) {
        super(application);
    }

    /**
     * 家庭列表数据回调
     */
    private final MutableLiveData<List<AssetBean>> assetListLiveData = new MutableLiveData<>();

    public MutableLiveData<List<AssetBean>> getAssetListLiveData() {
        return assetListLiveData;
    }

    /**
     * 家庭列表
     */
    public void getFamilyList(boolean isFirst) {
        showLoading();
        FamilyNetworkManager.getInstance().getFamilyList(new CallbackListener<List<AssetBean>>() {
            @Override
            public void onSuccess(List<AssetBean> assetBeans) {
                hideLoading();
                AssetBean assetBean = null;
                if (isFirst) {
                    String currentHomeId = CacheDeviceDataManager.getInstance().getCurrentHomeId();
                    if (!TextUtils.isEmpty(currentHomeId)) {
                        if (assetBeans != null && !assetBeans.isEmpty()) {
                            boolean isExit = false;
                            for (AssetBean item : assetBeans) {
                                if (TextUtils.equals(item.getId(), currentHomeId)) {
                                    isExit = true;
                                    assetBean = item;
                                    break;
                                }
                            }
                            if (isExit) {
                                changeFamily(assetBean);
                                return;
                            }
                        }
                    }
                    if (assetBeans != null && !assetBeans.isEmpty()) {
                        changeFamily(assetBeans.get(0));
                    }
                    return;
                }

                assetListLiveData.setValue(assetBeans);
            }

            @Override
            public void onError(String s, String s1) {
                hideLoading();
                ToastUtil.showMsg(s1);
            }
        });
    }

    private void changeFamily(AssetBean assetBean) {
        mqttFamilySubTopic(assetBean);
    }

    /**
     * 家庭列表
     *
     * @param isChange 是否是切换家庭
     */
    public void getFamilyDetail(boolean isChange, String homeId) {
        showLoading();
        String currentHomeId = CacheDeviceDataManager.getInstance().getCurrentHomeId();
        if (!TextUtils.isEmpty(homeId)) {
            currentHomeId = homeId;
        }
        FamilyNetworkManager.getInstance().getFamilyDetail(currentHomeId, new CallbackListener<AssetBean>() {
            @Override
            public void onSuccess(AssetBean assetBean) {
                if (isChange) {
                    hideLoading();
                    changeFamily(assetBean);
                } else {
                    getDeviceList(assetBean);

                }
            }

            @Override
            public void onError(String s, String s1) {
                ToastUtil.showMsg(s1);
                hideLoading();
            }
        });
    }

    /**
     * 设备列表数据回调
     */
    private final MutableLiveData<List<DeviceInfoBean>> deviceListLiveData = new MutableLiveData<>();

    public MutableLiveData<List<DeviceInfoBean>> getDeviceListLiveData() {
        return deviceListLiveData;
    }

    /**
     * 设备列表
     */
    public void getDeviceList(AssetBean familyDetail) {
        List<String> assetIdArray = CacheDeviceDataManager.getInstance().getAssetIdArray(familyDetail);
        FamilyNetworkManager.getInstance().getHomeDeviceList(assetIdArray, new CallbackListener<List<DeviceInfoBean>>() {
            @Override
            public void onSuccess(List<DeviceInfoBean> data) {
                hideLoading();
                deviceListLiveData.setValue(data);
                // TODO TEST 缓存设备dp点数据
            }

            @Override
            public void onError(String code, String error) {
                hideLoading();
                ToastUtil.showMsg(error);
            }
        });
    }

    /**
     * 场景列表数据回调
     */
    private final MutableLiveData<List<RuleUserInstanceBean>> sceneListLiveData = new MutableLiveData<>();

    public MutableLiveData<List<RuleUserInstanceBean>> getSceneListLiveData() {
        return sceneListLiveData;
    }

    /**
     * 获取当前用户场景实例列表
     * assetId	资产id
     * instanceType	实例类型(stream-规则引擎,onekey-一键执行,job-定时任务,redis-redis任务)
     * instanceTypes	List<String>
     * isHome	是否在首页显示
     */
    public void getInstanceList() {
        showLoading();
        String currentHomeId = CacheDeviceDataManager.getInstance().getCurrentHomeId();
        Map<String, Object> params = new HashMap<>();
        params.put("assetId", currentHomeId);
        SceneNetworkManager.getInstance().getInstanceList(currentHomeId, params, new CallbackListener<List<RuleUserInstanceBean>>() {
            @Override
            public void onSuccess(List<RuleUserInstanceBean> ruleUserInstanceBeans) {
                hideLoading();
                sceneListLiveData.setValue(ruleUserInstanceBeans);
            }

            @Override
            public void onError(String s, String s1) {
                hideLoading();
                ToastUtil.showMsg(s1);
            }
        });
    }

    /**
     * 分享设备需要订阅新的topic通知，实现控制
     */
    public void subscribeUserIdNotify(Context context) {
        UserInfoBean userInfo = UserInfoDataManager.getInstance().getUserInfo(context);
        if (userInfo != null && !TextUtils.isEmpty(userInfo.id)) {
            MqttManager.getInstance().subscribe(TopicManager.subscribeUserIdNotify(userInfo.id));
        }
    }

    /**
     * 家庭订阅topic
     */
    private void mqttFamilySubTopic(AssetBean data) {
        AssetBean currentFamily = CacheDeviceDataManager.getInstance().getCurrentFamily();
        CacheDeviceDataManager.getInstance().setCurrentHomeId(data.getId());
        CacheDeviceDataManager.getInstance().saveCurrentFamily(data);
        if (data != null) {
            if (currentFamily == null) {
                MqttManager.getInstance().subscribe(TopicManager.subscribeAssetIdNotify(data.getId()));
            } else {
                if (!currentFamily.getId().equals(data.getId())) {
                    MqttManager.getInstance().unSubscribe(TopicManager.subscribeAssetIdNotify(currentFamily.getId()));
                    MqttManager.getInstance().subscribe(TopicManager.subscribeAssetIdNotify(data.getId()));
                }
            }
        } else {
            if (currentFamily != null) {
                MqttManager.getInstance().subscribe(TopicManager.subscribeAssetIdNotify(currentFamily.getId()));
            }
        }
    }

    /**
     * 接收mqtt消息
     */
    @Override
    public void msgCallBack(String topic, MqttMessage mqttMessage) {
        String payload = new String(mqttMessage.getPayload());
        MqttReceiveManager.getInstance().mqttMsgDealData(payload);
    }
}
