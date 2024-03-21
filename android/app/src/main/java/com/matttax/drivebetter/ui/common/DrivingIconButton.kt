package com.matttax.drivebetter.drive.presentation.componenets

import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.res.painterResource

@Composable
fun DrivingIconButton(resId: Int, onClick: () -> Unit) {
    Button(
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(MaterialTheme.colorScheme.primary)
    ) {
        Icon(
            painter = painterResource(resId),
            tint = MaterialTheme.colorScheme.onPrimary,
            contentDescription = null
        )
    }
}
