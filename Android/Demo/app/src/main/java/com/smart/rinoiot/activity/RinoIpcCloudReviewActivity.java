package com.smart.rinoiot.activity;

import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.smart.rinoiot.common_sdk.base.BaseActivity;
import com.smart.rinoiot.common_sdk.utils.LgUtils;
import com.smart.rinoiot.common_sdk.utils.ToastUtil;
import com.smart.rinoiot.model.IpcCloudReviewModel;
import com.smart.rinoiot.panel_sdk.R;
import com.smart.rinoiot.panel_sdk.ijkplayer.widget.IjkVideoView;
import com.smart.rinoiot.panel_sdk.rinoIPCSDK.RinoIPCSDK;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author tw
 * @time 2024/5/10 9:59
 * @description ipc 云回放
 */
public class RinoIpcCloudReviewActivity extends BaseActivity<com.smart.rinoiot.databinding.ActivityRinoIpcDemoBinding, IpcCloudReviewModel> {

    @Override
    public String getToolBarTitle() {
        return null;
    }

    @Override
    public void init() {
        requestData();
        batchCloudReview();

    }

    @Override
    public com.smart.rinoiot.databinding.ActivityRinoIpcDemoBinding getBinding(LayoutInflater inflater) {
        return com.smart.rinoiot.databinding.ActivityRinoIpcDemoBinding.inflate(inflater);
    }


    private void requestData() {
//        String date = new SimpleDateFormat("HHmmss").format(new Date());
//        mViewModel.getM3u8SignUrl(1, "设备id", date);
    }


    /*===================云回放===================*/
    private List<IjkVideoView> ijkVideoViewList = new ArrayList<>();

    /**
     * 多个播放
     */
    private void batchCloudReview() {
        String url1 = "https://ipc-cloud-prod-1313015441.cos.ap-guangzhou.myqcloud.com/record/cn1623134925884715008/rn01FB925df1f0BF/20240514/1/part-play-00039.m3u8?sign=q-sign-algorithm%3Dsha1%26q-ak%3DAKIDEH3ZomTu4xZv0oLbaIirkMhlZ6sPeeMn%26q-sign-time%3D1715669400%3B1715712600%26q-key-time%3D1715669400%3B1715712600%26q-header-list%3Dhost%26q-url-param-list%3D%26q-signature%3D96b20ba953d477d3149a69dde689488251eef5e8&ci-process=pm3u8&expires=43200";
        String url = "https://ipc-cloud-prod-1313015441.cos.ap-guangzhou.myqcloud.com/record/cn1623134925884715008/rn01FB925df1f0BF/20240514/1/part-play-00001.m3u8?sign=q-sign-algorithm%3Dsha1%26q-ak%3DAKIDEH3ZomTu4xZv0oLbaIirkMhlZ6sPeeMn%26q-sign-time%3D1715669400%3B1715712600%26q-key-time%3D1715669400%3B1715712600%26q-header-list%3Dhost%26q-url-param-list%3D%26q-signature%3D7d26469c806e44fc9d246a521c752c11c96ff157&ci-process=pm3u8&expires=43200";
        initCloudReview(url);
        initCloudReview(url1);
    }

    /**
     * 单个播放
     */
    private void initCloudReview(String url) {
        IjkVideoView ijkVideoView = new IjkVideoView(this, new IjkVideoView.OnEventListener() {
            @Override
            public void onVideoLoadStart(IjkVideoView videoView, String uri, Map<String, String> requestHeaders) {
                LgUtils.w(TAG + "    onVideoLoadStart   uri=" + uri + "   requestHeaders=" + requestHeaders);
            }

            @Override
            public void onVideoLoad(IjkVideoView videoView, Map<String, Object> videoInfo) {
                LgUtils.w(TAG + "    onVideoLoad      videoInfo=" + videoInfo);
            }

            @Override
            public void onVideoProgress(IjkVideoView videoView, Map<String, Object> videoProgressInfo) {
                LgUtils.w(TAG + "onVideoProgress      videoProgressInfo=" + videoProgressInfo);
            }

            @Override
            public void onError(IjkVideoView videoView, int what, int extra) {
                LgUtils.w(TAG + "    onError   what=" + what + "   extra=" + extra);

            }

            @Override
            public void onEnd(IjkVideoView videoView) {
                LgUtils.w(TAG + "    onEnd  ");
            }
        });
        ijkVideoViewList.add(ijkVideoView);
        LinearLayout item = new LinearLayout(this);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 0);
        layoutParams.weight = 1;
        item.setLayoutParams(layoutParams);
        item.addView(ijkVideoView);
        binding.llContainer.addView(item);

        addTextView("开启播放", v -> {
            ToastUtil.showMsg("开启播放");
            RinoIPCSDK.setPlay(ijkVideoView);
        });

        addTextView("暂停播放", v -> {
            ToastUtil.showMsg("暂停播放");
            RinoIPCSDK.setPaused(ijkVideoView);
        });


        RinoIPCSDK.setPlaySource(ijkVideoView, url, null);
        RinoIPCSDK.setPlay(ijkVideoView);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        for (IjkVideoView ijkVideoView : ijkVideoViewList) {
            RinoIPCSDK.cloudReviewRelease(ijkVideoView);
        }
    }

    private void addTextView(String text, View.OnClickListener listener) {
        TextView textView = new TextView(this);
        textView.setText("开启播放");
        textView.setTextSize(20);
        textView.setTextColor(getResources().getColor(R.color.c_FF8D49));
        binding.llContainer.addView(textView);
        textView.setOnClickListener(listener);
    }
}
