package com.matttax.drivebetter.ui.utils

import androidx.compose.material3.MaterialTheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

object ColorUtils {

    @Composable
    fun getBottomColor(isSelected: Boolean): Color {
        return if (isSelected) {
            MaterialTheme.colorScheme.secondary
        } else MaterialTheme.colorScheme.onSecondary
    }

}
