package com.matttax.drivebetter.drive.presentation.componenets

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.*
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.*
import com.matttax.drivebetter.R
import com.matttax.drivebetter.drive.presentation.DriveViewModel
import com.matttax.drivebetter.drive.presentation.DrivingState
import com.matttax.drivebetter.ui.theme.TinkoffYellow
import com.matttax.drivebetter.ui.theme.tinkoffMedium

@Composable
fun RideScreen(viewModel: DriveViewModel) {
    val dashboard by viewModel.dashboard.collectAsState()
    val gpsSignal by viewModel.gpsSignalStrengthPercentage.collectAsState()
    val drivingState by viewModel.drivingState.collectAsState()
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            modifier = Modifier
                .fillMaxWidth()
                .padding(vertical = 5.dp),
            textAlign = TextAlign.Center,
            text = "GPS strength: $gpsSignal%",
            style = MaterialTheme.typography.titleMedium
        )
        Box(
            modifier = Modifier.fillMaxSize(0.6f),
            contentAlignment = Alignment.Center
        ) {
            Surface(
                modifier = Modifier.fillMaxSize(0.8f),
                color = Color.Transparent,
                border = BorderStroke(15.dp, MaterialTheme.colorScheme.primary),
                shape = CircleShape
            ) {
                Column(
                    modifier = Modifier.fillMaxSize(),
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.SpaceEvenly
                ) {
                    SpeedView(
                        speed = dashboard.currentSpeed,
                        title = "",
                        size = 44
                    )
                    RideInfoView(
                        modifier = Modifier.fillMaxWidth(),
                        timeMs = dashboard.timeActiveMs,
                        distanceKm = dashboard.distanceKm
                    )
                }
            }
        }
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceEvenly,
        ) {
            SpeedView(
                speed = dashboard.averageSpeed,
                title = "Average",
                size = 36
            )
            Spacer(Modifier.width(25.dp))
            SpeedView(
                speed = dashboard.maxSpeed,
                title = "Max",
                size = 36
            )
        }
        Spacer(modifier = Modifier.weight(1f))
        when (drivingState) {
            DrivingState.INACTIVE -> {
                Button(
                    modifier = Modifier.fillMaxWidth(0.8f),
                    shape = RoundedCornerShape(15.dp),
                    onClick = viewModel::startDrive,
                    colors = ButtonDefaults.textButtonColors(TinkoffYellow)
                ) {
                    Text(
                        text = "Start ride",
                        color = Color.Black,
                        style = TextStyle(
                            fontFamily = tinkoffMedium,
                            fontWeight = FontWeight.Normal,
                            fontSize = 16.sp,
                        )
                    )
                }
            }
            else -> {
                Row(
                    modifier = Modifier
                        .fillMaxWidth(0.8f)
                        .padding(vertical = 5.dp),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    if (drivingState == DrivingState.STARTED) {
                        DrivingIconButton(
                            resId = R.drawable.ic_baseline_pause_24,
                            onClick = viewModel::pauseDrive
                        )
                    } else {
                        DrivingIconButton(
                            resId = R.drawable.ic_baseline_play_arrow_24,
                            onClick = viewModel::startDrive
                        )
                    }
                    DrivingIconButton(
                        resId = R.drawable.ic_baseline_stop_24,
                        onClick = viewModel::stopDrive
                    )
                }
            }
        }
    }
}
