package com.mycompany.plugins.example;

import android.util.Base64;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.FrameLayout;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.app.Activity;

import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.JSObject;

import java.io.ByteArrayInputStream;
import java.io.InputStream;

import pl.droidsonroids.gif.GifDrawable;

@CapacitorPlugin(name = "SplashAnimatedPlugin")
public class SplashAnimatedPluginPlugin extends Plugin {

    private FrameLayout splashLayout;
    private ImageView splashImageView;

    @PluginMethod
    public void showSplash(PluginCall call) {
        String base64 = call.getString("base64");
        if (base64 == null || base64.isEmpty()) {
            call.reject("Base64 image is required");
            return;
        }

        Activity activity = getActivity();
        activity.runOnUiThread(() -> {
            try {
                String cleanBase64 = base64.split(",")[1];
                byte[] decodedBytes = Base64.decode(cleanBase64, Base64.DEFAULT);
                InputStream stream = new ByteArrayInputStream(decodedBytes);

                splashImageView = new ImageView(activity);
                splashImageView.setScaleType(ImageView.ScaleType.FIT_XY);
                splashImageView.setLayoutParams(new FrameLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT
                ));

                try {
                    GifDrawable gif = new GifDrawable(decodedBytes);
                    splashImageView.setImageDrawable(gif);
                } catch (Exception e) {
                    Bitmap bitmap = BitmapFactory.decodeStream(stream);
                    splashImageView.setImageBitmap(bitmap);
                }

                splashLayout = new FrameLayout(activity);
                splashLayout.setLayoutParams(new FrameLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT
                ));
                splashLayout.addView(splashImageView);

                ViewGroup rootView = (ViewGroup) activity.getWindow().getDecorView().getRootView();
                rootView.addView(splashLayout);

                call.resolve();
            } catch (Exception ex) {
                call.reject("Failed to display splash: " + ex.getMessage());
            }
        });
    }

    @PluginMethod
    public void hideSplash(PluginCall call) {
        Activity activity = getActivity();
        activity.runOnUiThread(() -> {
            if (splashLayout != null) {
                ViewGroup rootView = (ViewGroup) activity.getWindow().getDecorView().getRootView();
                rootView.removeView(splashLayout);
                splashLayout = null;
                splashImageView = null;
            }
            call.resolve();
        });
    }
}
