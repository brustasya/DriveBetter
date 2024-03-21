package com.matttax.drivebetter.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color

private val DarkColorPalette = darkColorScheme(
    primary = TinkoffYellow,
    onPrimary = Color.Black,
    onSecondary = Color.Gray
)

private val LightColorPalette = lightColorScheme(
    primary = TinkoffYellow,
    secondary = TinkoffBlue,
    primaryContainer = Color.White,
    onPrimary = Color.Black,
    onSecondary = Color.Gray
)

@Composable
fun DriveBetterTheme(darkTheme: Boolean = isSystemInDarkTheme(), content: @Composable () -> Unit) {
    val colors = if (darkTheme) {
        DarkColorPalette
    } else {
        LightColorPalette
    }

    MaterialTheme(
        colorScheme = colors,
        typography = Typography,
        shapes = Shapes,
        content = content
    )
}