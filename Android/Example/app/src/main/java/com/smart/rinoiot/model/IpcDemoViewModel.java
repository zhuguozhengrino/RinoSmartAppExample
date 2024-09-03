package com.smart.rinoiot.model;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.MutableLiveData;

import com.smart.rinoiot.common_sdk.base.BaseViewModel;
import com.smart.rinoiot.common_sdk.listener.BaseRequestListener;
import com.smart.rinoiot.common_sdk.utils.LgUtils;
import com.smart.rinoiot.common_sdk.utils.ToastUtil;
import com.smart.rinoiot.device_sdk.bean.device.AgoraUserTokenVO;
import com.smart.rinoiot.panel_sdk.ipc.agora.RinoIPCEventEmitter;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.RinoIPCSDK;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.api.RinoIPCBusiness;

import org.jetbrains.annotations.NotNull;

import io.agora.rtc2.ChannelMediaOptions;
import io.agora.rtc2.video.VideoEncoderConfiguration;

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


    /**
     * 加入频道
     *
     * @param token       加入频道所用的鉴权token
     * @param channelName 加入的频道名
     * @param localUid    本地用户uid
     * @param options     选项 <a href="https://doc.shengwang.cn/api-ref/rtc/android/API/class_channelmediaoptions">详细文档</a>
     * @return
     */
    public int joinChannel(String token,
                           String channelName,
                           int localUid,
                           ChannelMediaOptions options) {
        return RinoIPCSDK.joinChannel(token, channelName, localUid, options);
    }

    /**
     * 离开频道
     *
     * @param channelName 加入的频道名
     * @param localUid    本地用户uid
     * @return 0：方法调用成功。< 0：方法调用失败。
     */
    public int leaveChannel(String channelName, int localUid) {
        return RinoIPCSDK.leaveChannel(channelName, localUid);
    }

    /**
     * 刷新token, 需要确保uid不变
     *
     * @param channelName 频道名
     * @param localUid    本地uid
     * @param token       新token
     * @return 0：方法调用成功。< 0：方法调用失败。
     */
    public int updateToken(String channelName, int localUid, String token) {
        return RinoIPCSDK.updateToken(channelName, localUid, token);
    }

    /*==================================音频通话业务======================================*/

    /**
     * 开始向某个频道推送音频流, 使用前请申请好麦克风权限并且已加入频道
     *
     * @param chanelId   需要推送的频道名,token 中的channelName
     * @param audioCodec 音频格式, 0: g711u 8k, 8: g711a 8k, 69: AAC 16k, 9:G722, 120 opus
     * @param localUid   本地uuid RtcToken 中的uid
     * @return 0: 方法调用成功;   < 0: 方法调用失败, -1 sdk未初始化
     */
    public int startPushAudioToChannel(String chanelId, int localUid, int audioCodec) throws Exception {
        return RinoIPCSDK.startPushAudioToChannel(chanelId, localUid, audioCodec);
    }

    /**
     * 停止向某个频道推送音频流
     *
     * @param chanelId 需要推送的频道名,token 中的channelName
     * @param localUid 本地uuid RtcToken 中的uid
     * @return 0: 方法调用成功;   < 0: 方法调用失败, -1 sdk未初始化
     */
    public int stopPushAudioToChannel(String chanelId, int localUid) throws Exception {
        return RinoIPCSDK.stopPushAudioToChannel(chanelId, localUid);
    }


    /*==================================视频通话业务======================================*/


    /**
     * 开始向某个频道推送视频流, 使用前请申请好麦克风权限并且已加入频道
     *
     * @param chanelId   需要推送的频道名,token 中的channelName
     * @param dimensions 推送的视频尺寸
     * @param localUid   本地uuid RtcToken 中的uid
     * @return 0: 方法调用成功;   < 0: 方法调用失败, -1 sdk未初始化
     */
    public int startPushVideoToChannel(String chanelId, int localUid, VideoEncoderConfiguration.VideoDimensions dimensions) throws Exception {
        return RinoIPCSDK.startPushVideoToChannel(chanelId, localUid, dimensions);
    }

    /**
     * 停止向某个频道推送视频流
     *
     * @param chanelId 需要推送的频道名,token 中的channelName
     * @param localUid 本地uuid RtcToken 中的uid
     * @return 0: 方法调用成功;   < 0: 方法调用失败, -1 sdk未初始化
     */
    public int stopPushVideoToChannel(String chanelId, int localUid) throws Exception {
        return RinoIPCSDK.stopPushVideoToChannel(chanelId, localUid);
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

    /**
     * 截取远端视频
     * 存储位置是否需要申请对应的权限
     *
     * @param chanelId      频道名
     * @param localUid      本地uuid RtcToken 中的uid
     * @param remoteUid     需要截取的远端推送视频流uid
     * @param filePath      文件路径  需精确到文件名及格式
     * @param saveToGallery 是否保存到相册, 需要提前申请好文件权限
     * @return 0: 方法调用成功;   < 0: 方法调用失败, -1 sdk未初始化
     * @description 调用后需要监听通知 {@link RinoIPCEventEmitter.RinoIPCEventTypeEnum.onSnapshotTaken} 获取拍照结果
     */
    public int takeSnapshot(String chanelId, int localUid, int remoteUid, String filePath, boolean saveToGallery) throws Exception {
        return RinoIPCSDK.takeSnapshot(chanelId, localUid, remoteUid, filePath, saveToGallery);
    }
}
