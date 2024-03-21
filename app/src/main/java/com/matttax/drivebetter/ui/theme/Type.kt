package com.matttax.drivebetter.ui.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import com.matttax.drivebetter.R

val tinkoffRegular = FontFamily(
    Font(R.font.tinkoff_sans_regular)
)

val tinkoffMedium = FontFamily(
    Font(R.font.tinkoff_sans_medium)
)

val tinkoffBold = FontFamily(
    Font(R.font.tinkoff_sans_bold)
)

val Typography = Typography(
    titleLarge = TextStyle(
        fontFamily = tinkoffBold,
        fontSize = 28.sp,
    ),
    titleMedium = TextStyle(
        fontFamily = tinkoffBold,
        fontSize = 18.sp,
    ),
    titleSmall = TextStyle(
        fontFamily = tinkoffRegular,
        fontWeight = FontWeight.Thin,
        fontSize = 14.sp,
    ),
    bodyMedium = TextStyle(
        fontFamily = tinkoffMedium,
        fontWeight = FontWeight.Normal,
        fontSize = 16.sp,
    ),
)