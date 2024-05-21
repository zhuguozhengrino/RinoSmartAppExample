package com.smart.rinoiot.model;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.MutableLiveData;

import com.smart.rinoiot.common_sdk.base.BaseViewModel;
import com.smart.rinoiot.common_sdk.listener.BaseRequestListener;
import com.smart.rinoiot.common_sdk.utils.LgUtils;
import com.smart.rinoiot.common_sdk.utils.ToastUtil;
import com.smart.rinoiot.device_sdk.bean.device.AgoraUserTokenVO;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.RinoIPCSDK;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.api.RinoIPCBusiness;

import org.jetbrains.annotations.NotNull;

/**
 * @author tw
 * * @time 2022/12/5 15:25
 * * @description 门铃呼叫model
 */
public class IpcDemoViewModel extends BaseViewModel {
    private static final String TAG = IpcDemoViewModel.class.getSimpleName();

    public IpcDemoViewModel(@NonNull @NotNull Application application) {
        super(application);
    }


    /**
     * 获取ipc  token
     *
     * @param devId      设备id
     * @param agoraModel live:直播； playback  回看
     */
    private final MutableLiveData<AgoraUserTokenVO> userTokenVOMutableLiveData = new MutableLiveData<>();

    public MutableLiveData<AgoraUserTokenVO> getUserTokenVOMutableLiveData() {
        return userTokenVOMutableLiveData;
    }

    public void getIpcToken(String devId, String agoraModel) {
        RinoIPCBusiness.testGetToken(devId, agoraModel, new BaseRequestListener<AgoraUserTokenVO>() {
            @Override
            public void onResult(AgoraUserTokenVO result) {
                super.onResult(result);
                userTokenVOMutableLiveData.postValue(result);
            }

            @Override
            public void onError(String error, String msg) {
                super.onError(error, msg);
                LgUtils.w(TAG + "   error=" + error + "    msg=" + msg);
                ToastUtil.showMsg(msg);
            }
        });
    }

    /**
     * 获取ipc  token
     *
     * @param connectModel 连接模式(1-预连接,2-直播推流,默认直播推流)
     * @param agoraUserTokenVO token 数据
     * @param devId 设备id
     */
    private final MutableLiveData<Object> joinLiveLiveData = new MutableLiveData<>();

    public MutableLiveData<Object> getJoinLiveLiveData() {
        return joinLiveLiveData;
    }

    public void testNotifyDeviceJoinLiveChannel(String devId, int connectModel, AgoraUserTokenVO agoraUserTokenVO) {
        RinoIPCBusiness.testNotifyDeviceJoinLiveChannel(devId, connectModel, agoraUserTokenVO, new BaseRequestListener<Object>() {
            @Override
            public void onResult(Object result) {
                super.onResult(result);
                joinLiveLiveData.postValue(result);
            }

            @Override
            public void onError(String error, String msg) {
                super.onError(error, msg);
                LgUtils.w(TAG + " testNotifyDeviceJoinLiveChannel     error=" + error + "    msg=" + msg);
                ToastUtil.showMsg(msg);
            }
        });
    }


    /*==================================音频通话业务======================================*/

    /**
     * 开启或关闭音频对讲能力
     *
     * @param isEnable true:开启  ；false： 关闭
     * @return 0: 方法调用成功;   < 0: 方法调用失败
     */
    public int enableLocalAudio(boolean isEnable) {
        return RinoIPCSDK.enableLocalAudio(isEnable);
    }

    /**
     * 开启音频对讲
     *
     * @param isMultiChannel true:是多频道；false：不是多频道
     * @param chanelId       token 中channelName  如果是多频道，非空
     * @param uid            token 中uid    如果是多频道，非空
     * @return 0: 方法调用成功;   < 0: 方法调用失败
     */
    public int startLocalAudio(boolean isMultiChannel, String chanelId, int uid) throws Exception {
        return RinoIPCSDK.stopLocalVideo(isMultiChannel, chanelId, uid);
    }

    /**
     * 关闭音频对讲
     *
     * @param isMultiChannel true:是多频道；false：不是多频道
     * @param chanelId       token 中channelName  如果是多频道，非空
     * @param uid            token 中uid    如果是多频道，非空
     * @return 0: 方法调用成功;   < 0: 方法调用失败
     */
    public int stopLocalAudio(boolean isMultiChannel, String chanelId, int uid) {
        return RinoIPCSDK.stopLocalAudio(isMultiChannel, chanelId, uid);
    }

    /*==================================视频通话业务======================================*/

    /**
     * 开启或关闭视频对讲能力
     *
     * @param isEnable true:开启  ；false： 关闭
     * @return 0: 方法调用成功;   < 0: 方法调用失败
     */
    public int enableLocalVideo(boolean isEnable) {
        return RinoIPCSDK.enableLocalVideo(isEnable);
    }

    /**
     * 开启视频对讲
     *
     * @param isMultiChannel true:是多频道(暂不支持)；false：不是多频道
     * @param chanelId       token 中channelName  如果是多频道，非空
     * @param uid            token 中uid    如果是多频道，非空
     * @return 0: 方法调用成功;   < 0: 方法调用失败
     */
    public int startLocalVideo(boolean isMultiChannel, String chanelId, int uid) throws Exception {
        return RinoIPCSDK.startLocalVideo(isMultiChannel, chanelId, uid);
    }

    /**
     * 关闭视频对讲
     *
     * @param isMultiChannel true:是多频道；false：不是多频道
     * @param chanelId       token 中channelName  如果是多频道，非空
     * @param uid            token 中uid    如果是多频道，非空
     * @return 0: 方法调用成功;   < 0: 方法调用失败
     */
    public int stopLocalVideo(boolean isMultiChannel, String chanelId, int uid) throws Exception {
        return RinoIPCSDK.stopLocalVideo(isMultiChannel, chanelId, uid);
    }

    /**
     * 切换前置/后置摄像头
     * 该方法必须在摄像头成功开启后调用，即 SDK 触发 onLocalVideoStateChanged 回调，返回本地视频状态为 LOCAL_VIDEO_STREAM_STATE_CAPTURING (1) 后。
     *
     * @return 0: 方法调用成功;   < 0: 方法调用失败
     */
    public int switchCamera() {
        return RinoIPCSDK.switchCamera();
    }


    /**
     * 开启或关闭扬声器播放
     * 该方法需要在加入频道后调用。
     * 如果用户使用了蓝牙耳机、有线耳机等外接音频播放设备，则该方法的设置无效，音频只会通过外接设备播放。当有多个外接设备时，音频会通过最后一个接入的设备播放。
     *
     * @param isOpen true:打开；false：关闭
     * @return 0: 方法调用成功;   < 0: 方法调用失败
     */
    public int setEnableSpeakerphone(boolean isOpen) {
        return RinoIPCSDK.setEnableSpeakerphone(isOpen);
    }

}
