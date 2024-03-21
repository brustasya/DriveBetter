package com.matttax.drivebetter.drive.presentation.componenets

import android.icu.text.DecimalFormat
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import com.matttax.drivebetter.ui.theme.tinkoffMedium

@Composable
fun SpeedView(
    speed: Double,
    title: String,
    size: Int
) {
    Column(
        verticalArrangement = Arrangement.Center,
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Text(
            text = title,
            style = TextStyle(
                fontFamily = tinkoffMedium,
                fontWeight = FontWeight.Normal,
                fontSize = (size / 2).sp
            ),
            color = Color.Gray
        )
        Text(
            text = DecimalFormat("#.##").format(speed),
            style = TextStyle(
                fontFamily = tinkoffMedium,
                fontWeight = FontWeight.Normal,
                fontSize = size.sp
            )
        )
        Text(
            text = "km/h",
            style = TextStyle(
                fontFamily = tinkoffMedium,
                fontWeight = FontWeight.Normal,
                fontSize = (size / 2).sp
            ),
            color = Color.Gray
        )
    }
}
