package com.smart.rinoiot.activity;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.Nullable;

import com.google.gson.Gson;
import com.smart.rinoiot.common_sdk.base.BaseActivity;
import com.smart.rinoiot.common_sdk.network.RequestHeaderUtils;
import com.smart.rinoiot.common_sdk.utils.ToastUtil;
import com.smart.rinoiot.databinding.ActivityRinoIpcDemoBinding;
import com.smart.rinoiot.device_sdk.bean.device.AgoraUserTokenVO;
import com.smart.rinoiot.model.IpcDemoViewModel;
import com.smart.rinoiot.panel_sdk.R;
import com.smart.rinoiot.panel_sdk.ipc.agora.RinoEventListener;
import com.smart.rinoiot.panel_sdk.ipc.agora.RinoIPCEventEmitter;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.RinoIPCSDK;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.RinoRemotePlayer;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.api.RinoIPCBusiness;

import java.util.HashMap;
import java.util.Map;

import io.agora.rtc2.IRtcEngineEventHandler;
import io.agora.rtc2.video.VideoEncoderConfiguration;

/**
 * @author tw
 * @time 2024/5/10 9:59
 * @description ipc 直播demo
 */
public class RinoIpcDemoActivity extends BaseActivity<com.smart.rinoiot.databinding.ActivityRinoIpcDemoBinding, IpcDemoViewModel>
        implements RinoEventListener {
    private RinoIPCEventEmitter rinoIPCEventEmitter;

    @Override
    public String getToolBarTitle() {
        return null;
    }

    @Override
    public void init() {
        rinoIPCEventEmitter = new RinoIPCEventEmitter();
        rinoIPCEventEmitter.addListener(this);
        requestData();
        initObserve();
    }

    @Override
    public ActivityRinoIpcDemoBinding getBinding(LayoutInflater inflater) {
        return ActivityRinoIpcDemoBinding.inflate(inflater);
    }

    /**
     * 获取token
     */
    private String devId = "1798597875546529792";
    private String devId2 = "1798597875546529792";

    private void requestData() {
        mViewModel.getIpcToken(devId, "live");
//        mViewModel.getIpcToken(devId2, "live");
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    private void initObserve() {
        mViewModel.getUserTokenVOMutableLiveData().observe(this, agoraUserTokenVO -> {
            if (!RinoIPCSDK.hasInit && agoraUserTokenVO != null) {//以初始化
                RinoIPCSDK.init(agoraUserTokenVO.getAgoraAppId(), rinoIPCEventEmitter, this);
            }
            if (RinoIPCSDK.hasInit) {
                addRemotePLayer(1, agoraUserTokenVO);
//                addRemotePLayer(2, agoraUserTokenVO);
            }
            //TODO 直播 channelName ==  DeviceId
            if (agoraUserTokenVO != null && agoraUserTokenVO.getRtcToken() != null) {
                mViewModel.testNotifyDeviceJoinLiveChannel(agoraUserTokenVO.getRtcToken().getChannelName(), 2, agoraUserTokenVO);
            }
            //TODO 回看加入频道需要传  DeviceId
//            mViewModel.testNotifyDeviceJoinLiveChannel(devId, 2, agoraUserTokenVO);
        });
    }

    /**
     * 事件回调监听
     */
    public void onEvent(RinoIPCEventEmitter.RinoIPCEvent event, Context context) {
        switch (event.eventType) {
            case onJoinChannelSuccess:
            case onRejoinChannelSuccess:
            case onLeaveChannel:
                // 加入/离开频道后, 都做一下对应业务处理
                break;
            case onRemoteVideoStats:
                // 码流信息
                // https://doc.shengwang.cn/api-ref/rtc/android/API/class_remoteaudiostats#receivedBitrate
                IRtcEngineEventHandler.RemoteVideoStats stats = new Gson().fromJson(event.data.getString("stats"), IRtcEngineEventHandler.RemoteVideoStats.class);
                // 接收到的远端音频流在统计周期内的平均码率(Kbps)
                // stats.receivedBitrate
                break;
            case onRemoteVideoStateChanged:
                // 远端用户视频流状态改变
                break;
            case onAudioVolumeIndication:
                // 远端用户推送音频改变
                break;
            case onTokenPrivilegeWillExpire:
                // token即将过期的时候更新token
//                RinoIPCSDK.updateToken("channelName",123,"");
                // token即将过期
                break;
            case onRequestToken:
                // token已过期
                break;
        }
    }

    // 是否开启扬声器
    boolean enableSpeakerphone = false;
    // 静音播放器
    boolean muteRemoteAudio = false;

    /**
     * 添加播放器
     */
    private void addRemotePLayer(int remoteUid, AgoraUserTokenVO agoraUserTokenVO) {
        RinoRemotePlayer rinoRemotePlayer = new RinoRemotePlayer(this, remoteUid, false);
        LinearLayout item = new LinearLayout(this);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0);
        layoutParams.weight = 1;
        item.setLayoutParams(layoutParams);
        item.addView(rinoRemotePlayer);
        binding.llContainer.addView(item);
        rinoRemotePlayer.setToken(agoraUserTokenVO);
        rinoRemotePlayer.setMuteAudio(muteRemoteAudio);

        addTextView("音频开启", v -> {
            ToastUtil.showMsg("音频开启");
            try {
                RinoIPCSDK.startPushAudioToChannel(agoraUserTokenVO.getRtcToken().getChannelName(), Integer.parseInt(agoraUserTokenVO.getRtcToken().getUid()), 120);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
        addTextView("音频关闭", v -> {
            ToastUtil.showMsg("音频关闭");
            try {
                RinoIPCSDK.stopPushAudioToChannel(agoraUserTokenVO.getRtcToken().getChannelName(), Integer.parseInt(agoraUserTokenVO.getRtcToken().getUid()));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });

        addTextView("开启视频对讲", v -> {
            ToastUtil.showMsg("开启视频对讲");
            try {
                RinoIPCSDK.startPushVideoToChannel(agoraUserTokenVO.getRtcToken().getChannelName(), Integer.parseInt(agoraUserTokenVO.getRtcToken().getUid()), new VideoEncoderConfiguration.VideoDimensions());
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
        addTextView("关闭视频对讲", v -> {
            ToastUtil.showMsg("关闭视频对讲");
            try {
                RinoIPCSDK.stopPushVideoToChannel(agoraUserTokenVO.getRtcToken().getChannelName(), Integer.parseInt(agoraUserTokenVO.getRtcToken().getUid()));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
        addTextView("切换静音RemotePlayer", v -> {
            ToastUtil.showMsg("切换静音RemotePlayer");
            try {
                rinoRemotePlayer.setMuteAudio(!muteRemoteAudio);
                muteRemoteAudio = !muteRemoteAudio;
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
        addTextView("切换前后置摄像头", v -> {
            ToastUtil.showMsg("切换前后置摄像头");
            try {
                RinoIPCSDK.switchCamera();
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
        addTextView("切换扬声器播放", v -> {
            ToastUtil.showMsg("切换扬声器播放");
            try {
                RinoIPCSDK.setEnableSpeakerphone(!enableSpeakerphone);
                enableSpeakerphone = !enableSpeakerphone;
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
    }

    /**
     * 自定义头部信息
     * 具体参数{@link RequestHeaderUtils} 静态参量
     */
    public void customHeader(boolean isCustom) {
        Map<String, Object> params = new HashMap<>();
        RinoIPCBusiness.customRequestHeader(isCustom, params);
    }

    private void addTextView(String text, View.OnClickListener listener) {
        TextView textView = new TextView(this);
        textView.setText(text);
        textView.setTextSize(20);
        textView.setTextColor(getResources().getColor(R.color.c_FF8D49));
        binding.llContainer.addView(textView);
        textView.setOnClickListener(listener);
    }
}
