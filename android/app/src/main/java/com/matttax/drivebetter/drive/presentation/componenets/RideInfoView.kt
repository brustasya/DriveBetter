package com.matttax.drivebetter.drive.presentation.componenets

import android.icu.text.DecimalFormat
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import com.matttax.drivebetter.ui.utils.ClockUtils

@Composable
fun RideInfoView(
    timeMs: Long,
    distanceKm: Double,
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier,
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = ClockUtils.getTimeFromMillis(timeMs),
            style = MaterialTheme.typography.titleSmall,
            color = MaterialTheme.colorScheme.onSecondary
        )
        Text(
            text = "${DecimalFormat("#.##").format(distanceKm)} km",
            style = MaterialTheme.typography.titleSmall,
            color = MaterialTheme.colorScheme.onSecondary
        )
    }
}
