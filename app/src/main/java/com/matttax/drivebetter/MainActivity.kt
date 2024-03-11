package com.matttax.drivebetter

import android.Manifest
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Text
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.app.ActivityCompat
import com.matttax.drivebetter.drive.DriveViewModel
import com.matttax.drivebetter.location.LocationService
import com.matttax.drivebetter.network.model.Address
import com.matttax.drivebetter.ui.theme.DriveBetterTheme
import com.matttax.drivebetter.ui.theme.Purple700
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

@AndroidEntryPoint
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val viewModel by viewModels<DriveViewModel>()
        ActivityCompat.requestPermissions(
            this,
            arrayOf(
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_FINE_LOCATION,
            ),
            0
        )
        setContent {
            DriveBetterTheme {
                RideScreen(
                    speedFlow = flow {
                        emit(2.7)
                        delay(1800)
                        emit(1.1)
                        delay(900)
                        emit(1.3)
                        delay(900)
                        emit(0.9)
                        delay(2700)
                        emit(1.1)
                    },
                    isRidingFlow = flow { emit(true) },
                    addressFlow = viewModel.location,
                    onStateChange = {
                        Intent(applicationContext, LocationService::class.java).apply {
                            startService(this)
                        }
                    }
                )
            }
        }
    }
}

@Composable
fun RideScreen(
    speedFlow: Flow<Double>,
    isRidingFlow: Flow<Boolean>,
    addressFlow: Flow<Address?>,
    onStateChange: (Boolean) -> Unit
) {
    val speed by speedFlow.collectAsState(0.0)
    val address by addressFlow.collectAsState(null)
    val isRiding by isRidingFlow.collectAsState(false)
    Column(
        modifier = Modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            modifier = Modifier.padding(top = 20.dp),
            text = address?.short.toString(),
            fontSize = 18.sp,
            color = Purple700
        )
        Box(
            modifier = Modifier.fillMaxSize(0.6f),
            contentAlignment = Alignment.Center
        ) {
            SpeedView(speed = speed, title = "Current", size = 44)
        }
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceEvenly,
        ) {
            SpeedView(speed = 1.4, title = "Average", size = 36)
            Spacer(modifier = Modifier.width(25.dp))
            SpeedView(speed = 5.3, title = "Max", size = 36)
        }
        Spacer(modifier = Modifier.weight(1f))
        Button(
            modifier = Modifier.fillMaxWidth(0.8f),
            shape = RoundedCornerShape(15.dp),
            onClick = { onStateChange(!isRiding) },
            colors = ButtonDefaults.textButtonColors(Utils.getButtonColor(isRiding))
        ) {
            Text(
                text = Utils.getButtonText(isRiding),
                color = Color.White
            )
        }
    }
}

@Composable
fun SpeedView(speed: Double, title: String, size: Int) {
    Column(
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = title,
            fontSize = (size / 2).sp,
            color = Color.Gray
        )
        Text(
            text = "$speed",
            fontSize = size.sp
        )
        Text(
            text = "km/h",
            fontSize = (size / 2).sp,
            color = Color.Gray
        )
    }
}

object Utils {

    fun getButtonColor(isRiding: Boolean): Color {
        return if (isRiding) Color(0xFFD21404) else Color.Blue
    }

    fun getButtonTextColor(isRiding: Boolean): Color {
        return if (isRiding) Color.Red else Color.Blue
    }

    fun getButtonText(isRiding: Boolean): String {
        return if (isRiding) "Finish ride" else "Start ride"
    }

}
