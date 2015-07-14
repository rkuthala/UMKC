/**
 * Copyright 2014 Google Inc. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.android.gms.location.sample.activityrecognition;

import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.ActionBarActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.GoogleApiClient.ConnectionCallbacks;
import com.google.android.gms.common.api.GoogleApiClient.OnConnectionFailedListener;
import com.google.android.gms.common.api.ResultCallback;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.ActivityRecognition;
import com.google.android.gms.location.DetectedActivity;

import java.util.ArrayList;

/**
 * This sample demonstrates use of the
 * {@link com.google.android.gms.location.ActivityRecognitionApi} to recognize a user's current
 * activity, such as walking, driving, or standing still. It uses an
 * {@link android.app.IntentService} to broadcast detected activities through a
 * {@link BroadcastReceiver}. See the {@link DetectedActivity} class for a list of DetectedActivity
 * types.
 * <p/>
 * Note that this activity implements
 * {@link ResultCallback<R extends com.google.android.gms.common.api.Result>}.
 * Requesting activity detection updates using
 * {@link com.google.android.gms.location.ActivityRecognitionApi#requestActivityUpdates}
 * and stopping updates using
 * {@link com.google.android.gms.location.ActivityRecognitionApi#removeActivityUpdates}
 * returns a {@link com.google.android.gms.common.api.PendingResult}, whose result
 * object is processed by the {@code onResult} callback.
 */
public class MainActivity extends ActionBarActivity implements
        ConnectionCallbacks, OnConnectionFailedListener, ResultCallback<Status> {

    protected static final String TAG = MainActivity.class.getName();

    protected ActivityDetectionBroadcastReceiver receiver;

    protected GoogleApiClient googleClient;

    PendingIntent mActivityDetectionPendingIntent;

    // UI elements.
    Button startUpdating;
    Button stopUpdating;
    ListView listView;

    CustomAdapter myAdapter;

    ArrayList<DetectedActivity> activitiesDetected;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);

        // Get the UI widgets.
        startUpdating = (Button) findViewById(R.id.request_activity_updates_button);
        stopUpdating = (Button) findViewById(R.id.remove_activity_updates_button);
        listView = (ListView) findViewById(R.id.detected_activities_listview);

        receiver = new ActivityDetectionBroadcastReceiver();

        setButtonsEnabledState();

        if (savedInstanceState != null && savedInstanceState.containsKey(
                Utils.DETECTED_ACTIVITIES)) {
            activitiesDetected = (ArrayList<DetectedActivity>) savedInstanceState.getSerializable(
                    Utils.DETECTED_ACTIVITIES);
        } else {
            activitiesDetected = new ArrayList<DetectedActivity>();

            for (int i = 0; i < Utils.MONITORED_ACTIVITIES.length; i++) {
                activitiesDetected.add(new DetectedActivity(Utils.MONITORED_ACTIVITIES[i], 0));
            }
        }

        myAdapter = new CustomAdapter(this, activitiesDetected);
        listView.setAdapter(myAdapter);

        buildGoogleApiClient();
    }

    protected synchronized void buildGoogleApiClient() {
        googleClient = new GoogleApiClient.Builder(this)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .addApi(ActivityRecognition.API)
                .build();
    }

    @Override
    protected void onStart() {
        super.onStart();
        googleClient.connect();
    }

    @Override
    protected void onStop() {
        super.onStop();
        googleClient.disconnect();
    }

    @Override
    protected void onResume() {
        super.onResume();
        LocalBroadcastManager.getInstance(this).registerReceiver(receiver,
                new IntentFilter(Utils.BROADCAST_ACTION));
    }

    @Override
    protected void onPause() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(receiver);
        super.onPause();
    }

    @Override
    public void onConnected(Bundle connectionHint) {
        Log.i(TAG, "Connected to GoogleApiClient");
    }

    @Override
    public void onConnectionFailed(ConnectionResult result) {
        Log.i(TAG, "Connection failed: ConnectionResult.getErrorCode() = " + result.getErrorCode());
    }

    @Override
    public void onConnectionSuspended(int cause) {
        Log.i(TAG, "Connection suspended");
        googleClient.connect();
    }

    public void requestActivityUpdatesButtonHandler(View view) {
        if (!googleClient.isConnected()) {
            Toast.makeText(this, getString(R.string.not_connected),
                    Toast.LENGTH_SHORT).show();
            return;
        }
        ActivityRecognition.ActivityRecognitionApi.requestActivityUpdates(
                googleClient,
                Utils.DETECTION_INTERVAL_IN_MILLISECONDS,
                getActivityDetectionPendingIntent()
        ).setResultCallback(this);
    }

    public void removeActivityUpdatesButtonHandler(View view) {
        if (!googleClient.isConnected()) {
            Toast.makeText(this, getString(R.string.not_connected), Toast.LENGTH_SHORT).show();
            return;
        }
        ActivityRecognition.ActivityRecognitionApi.removeActivityUpdates(
                googleClient,
                getActivityDetectionPendingIntent()
        ).setResultCallback(this);
    }

    public void onResult(Status status) {
        if (status.isSuccess()) {
            boolean requestingUpdates = !getUpdatesRequestedState();
            setUpdatesRequestedState(requestingUpdates);

            setButtonsEnabledState();

            Toast.makeText(
                    this,
                    getString(requestingUpdates ? R.string.activity_updates_added :
                            R.string.activity_updates_removed),
                    Toast.LENGTH_SHORT
            ).show();
        } else {
            Log.e(TAG, "Error adding or removing activity detection: " + status.getStatusMessage());
        }
    }

    private PendingIntent getActivityDetectionPendingIntent() {
        if (mActivityDetectionPendingIntent != null) {
            return mActivityDetectionPendingIntent;
        }
        Intent intent = new Intent(this, DetectedActivitiesIntentService.class);

        return PendingIntent.getService(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
    }

    private void setButtonsEnabledState() {
        if (getUpdatesRequestedState()) {
            startUpdating.setEnabled(false);
            stopUpdating.setEnabled(true);
        } else {
            startUpdating.setEnabled(true);
            stopUpdating.setEnabled(false);
        }
    }

    private SharedPreferences getSharedPreferencesInstance() {
        return getSharedPreferences(Utils.SHARED_PREFERENCES_NAME, MODE_PRIVATE);
    }

    private boolean getUpdatesRequestedState() {
        return getSharedPreferencesInstance()
                .getBoolean(Utils.ACTIVITY_UPDATES_REQUESTED_KEY, false);
    }

    private void setUpdatesRequestedState(boolean requestingUpdates) {
        getSharedPreferencesInstance()
                .edit()
                .putBoolean(Utils.ACTIVITY_UPDATES_REQUESTED_KEY, requestingUpdates)
                .commit();
    }

    public void onSaveInstanceState(Bundle savedInstanceState) {
        savedInstanceState.putSerializable(Utils.DETECTED_ACTIVITIES, activitiesDetected);
        super.onSaveInstanceState(savedInstanceState);
    }

    protected void updateDetectedActivitiesList(ArrayList<DetectedActivity> detectedActivities) {
        myAdapter.updateActivities(detectedActivities);
    }

    public class ActivityDetectionBroadcastReceiver extends BroadcastReceiver {
        protected static final String TAG = "activity-detection-response-receiver";

        @Override
        public void onReceive(Context context, Intent intent) {
            ArrayList<DetectedActivity> updatedActivities =
                    intent.getParcelableArrayListExtra(Utils.ACTIVITY_EXTRA);
            updateDetectedActivitiesList(updatedActivities);
        }
    }
}