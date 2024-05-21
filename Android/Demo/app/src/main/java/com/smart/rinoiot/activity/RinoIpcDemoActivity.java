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
    public com.smart.rinoiot.databinding.ActivityRinoIpcDemoBinding getBinding(LayoutInflater inflater) {
        return com.smart.rinoiot.databinding.ActivityRinoIpcDemoBinding.inflate(inflater);
    }

    /**
     * 获取token
     */
    private String devId = "1784791914174894080";
    private String devId2 = "1784791375089950720";

    private void requestData() {
//        mViewModel.getIpcToken(devId, "live");
        mViewModel.getIpcToken(devId2, "live");
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
                // token即将过期
                break;
            case onRequestToken:
                // token已过期
                break;
        }
    }

    /**
     * 添加播放器
     */
    private void addRemotePLayer(int remoteUid, AgoraUserTokenVO agoraUserTokenVO) {
        RinoRemotePlayer rinoRemotePlayer = new RinoRemotePlayer(this, remoteUid, false, false);
        LinearLayout item = new LinearLayout(this);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0);
        layoutParams.weight = 1;
        item.setLayoutParams(layoutParams);
        item.addView(rinoRemotePlayer);
        binding.llContainer.addView(item);
        rinoRemotePlayer.setToken(agoraUserTokenVO);

        addTextView("音频开启", v -> {
            ToastUtil.showMsg("音频开启");
            startLocalAudio(agoraUserTokenVO);
        });
        addTextView("音频关闭", v -> {
            ToastUtil.showMsg("音频关闭");
            stopLocalAudio(agoraUserTokenVO);
        });

        addTextView("开启视频对讲", v -> {
            ToastUtil.showMsg("开启视频对讲");
            RinoIPCSDK.enableLocalVideo(true);
            try {
                RinoIPCSDK.startLocalVideo(false, agoraUserTokenVO.getRtcToken().getChannelName(), Integer.parseInt(agoraUserTokenVO.getRtcToken().getUid()));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
        addTextView("关闭视频对讲", v -> {
            ToastUtil.showMsg("关闭视频对讲");
            RinoIPCSDK.enableLocalVideo(true);
            try {
                RinoIPCSDK.stopLocalVideo(false, agoraUserTokenVO.getRtcToken().getChannelName(), Integer.parseInt(agoraUserTokenVO.getRtcToken().getUid()));
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        });
    }


    /**
     * 开启音频对讲 方法调用成功;   < 0: 方法调用失败
     * 开启音频对象需要开启音频权限
     */
    public void startLocalAudio(AgoraUserTokenVO agoraUserTokenVO) {
        //TODO 开启或关闭音频对讲能力
        int enabled = RinoIPCSDK.enableLocalAudio(true);
        if (enabled == 0) {
            /*TODO true:是多频道；false：不是多频道
             * 如果是多频道，必须设置channelId和uid 的值，单频道可以直接传空
             * */
            String channelId = "";//渠道名
            int uid = -1;//uid
            if (agoraUserTokenVO != null && agoraUserTokenVO.getRtcToken() != null) {
                channelId = agoraUserTokenVO.getRtcToken().getChannelName();
                uid = Integer.parseInt(agoraUserTokenVO.getRtcToken().getUid());
            }
            RinoIPCSDK.startLocalAudio(false, channelId, uid);
        }
    }

    /**
     * 关闭音频对讲 方法调用成功;   < 0: 方法调用失败
     */
    public void stopLocalAudio(AgoraUserTokenVO agoraUserTokenVO) {
        //TODO 开启或关闭音频对讲能力，如果是多频道，单个用户退出频道，不需要设置 enableLocalAudio(false)；全部退出时，需要设置
        int enabled = RinoIPCSDK.enableLocalAudio(false);
        if (enabled == 0) {
            /*TODO true:是多频道；false：不是多频道
             * 如果是多频道，必须设置channelId和uid 的值，单频道可以直接传空
             * */
            String channelId = "";//渠道名
            int uid = -1;//uid
            if (agoraUserTokenVO != null && agoraUserTokenVO.getRtcToken() != null) {
                channelId = agoraUserTokenVO.getRtcToken().getChannelName();
                uid = Integer.parseInt(agoraUserTokenVO.getRtcToken().getUid());
            }
            RinoIPCSDK.stopLocalAudio(false, channelId, uid);
        }
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
