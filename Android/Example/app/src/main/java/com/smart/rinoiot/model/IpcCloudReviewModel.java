package com.smart.rinoiot.model;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.MutableLiveData;

import com.smart.rinoiot.common_sdk.base.BaseViewModel;
import com.smart.rinoiot.common_sdk.listener.BaseRequestListener;
import com.smart.rinoiot.common_sdk.utils.LgUtils;
import com.smart.rinoiot.common_sdk.utils.ToastUtil;
import com.smart.rinoiot.panel_sdk.ijkplayer.widget.IjkVideoView;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.RinoCloudPlaybackSDK;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.api.RinoIPCBusiness;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.bean.IpcCloudM3u8SignBean;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.Map;

/**
 * @author tw
 * * @time 2022/12/5 15:25
 * * @description 门铃呼叫model
 */
public class IpcCloudReviewModel extends BaseViewModel {
    private static final String TAG = IpcCloudReviewModel.class.getSimpleName();

    public IpcCloudReviewModel(@NonNull @NotNull Application application) {
        super(application);
    }


    private final MutableLiveData<IpcCloudM3u8SignBean> m3u8SignBeanMutableLiveData = new MutableLiveData<>();

    public MutableLiveData<IpcCloudM3u8SignBean> getM3u8SignBeanMutableLiveData() {
        return m3u8SignBeanMutableLiveData;
    }

    /**
     * 获取设备云存储M3U8访问url
     * {@link IpcCloudM3u8SignBean#setM3u8Url m3u8文件下载地址}
     * 数据格式：#EXTM3U
     * #EXT-X-VERSION:3
     * #EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1500000
     * //TODO 开始时间和结束时间  hhmmss
     * #RINO_PART_TIME=075956-090637
     * //TODO 当前小m3u8文件时间（单位：ms）
     * #RINO_DURATION=4001194
     * https://ipc-cloud-prod-1313015441.cos.ap-guangzhou.myqcloud.com/record/cn1623134925884715008/rn01FB925df1f0BF/20240514/1/part-play-00001.m3u8?sign=q-sign-algorithm%3Dsha1%26q-ak%3DAKIDEH3ZomTu4xZv0oLbaIirkMhlZ6sPeeMn%26q-sign-time%3D1715669400%3B1715712600%26q-key-time%3D1715669400%3B1715712600%26q-header-list%3Dhost%26q-url-param-list%3D%26q-signature%3D7d26469c806e44fc9d246a521c752c11c96ff157&ci-process=pm3u8&expires=43200
     *
     * @param cameraNum: 摄像头数,比如双目:1|2。默认是1,示例值(1)
     * @param date       date:日期:yyyyMMdd
     * @param devId      设备ID:设备id
     */
    public void getM3u8SignUrl(int cameraNum, String devId, String date) {
        Map<String, Object> params = new HashMap<>();
        params.put("cameraNum", cameraNum);
        params.put("date", date);
        params.put("devId", devId);
        RinoIPCBusiness.getM3u8SignUrl(params, new BaseRequestListener<IpcCloudM3u8SignBean>() {
            @Override
            public void onResult(IpcCloudM3u8SignBean result) {
                super.onResult(result);
                m3u8SignBeanMutableLiveData.postValue(result);
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
     * 设置云回放播放地址
     *
     * @param videoView 播放器
     * @param headers   非必传(默认传空)
     * @param uri       必传 uri
     */
    public void setPlaySource(IjkVideoView videoView, String uri, Map<String, String> headers) {
        RinoCloudPlaybackSDK.setPlaySource(videoView, uri, null);
    }

    /**
     * 云回放播放
     *
     * @param videoView 播放器
     */
    public void setPlay(IjkVideoView videoView) {
        RinoCloudPlaybackSDK.setPlay(videoView);
    }

    /**
     * 云回放暂停
     *
     * @param videoView 播放器
     */
    public void setPaused(IjkVideoView videoView) {
        RinoCloudPlaybackSDK.setPaused(videoView);
    }

    /**
     * 云回放拽托
     *
     * @param videoView 播放器
     * @param seek      拽托播放时间
     */
    public void setSeek(IjkVideoView videoView, float seek) {
        RinoCloudPlaybackSDK.setSeek(videoView, seek);
    }

    /**
     * 云回看播放延迟间隔
     *
     * @param videoView              播放器
     * @param progressUpdateInterval 时间间隔
     */
    public void setProgressUpdateInterval(IjkVideoView videoView, float progressUpdateInterval) {
        if (videoView == null) return;
        RinoCloudPlaybackSDK.setProgressUpdateInterval(videoView, progressUpdateInterval);
    }

    /**
     * 云回放销毁
     *
     * @param videoView 播放器
     */
    public void cloudReviewRelease(IjkVideoView videoView) {
        RinoCloudPlaybackSDK.cloudReviewRelease(videoView);
    }
}
