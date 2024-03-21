package com.matttax.drivebetter.ui.navigation

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.res.vectorResource
import androidx.compose.ui.unit.dp
import androidx.navigation.NavController
import androidx.navigation.compose.currentBackStackEntryAsState
import com.matttax.drivebetter.ui.utils.ColorUtils
import com.matttax.drivebetter.R

enum class NavigationItems(
    val route: String,
    val title: String,
    val iconId: Int
) {
    RIDES(
        route = "rides",
        title = "Rides",
        iconId = R.drawable.ic_baseline_car_24
    ),
    DASHBOARD(
        route = "dashboard",
        title = "Dashboard",
        iconId = R.drawable.ic_baseline_dashboard_24
    ),
    PROFILE(
        route = "profile",
        title = "Profile",
        iconId = R.drawable.ic_baseline_account_circle_24
    )
}

@Composable
fun BottomNavigationBar(
    navController: NavController,
    modifier: Modifier = Modifier
) {
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = navBackStackEntry?.destination?.route
    Card(
        modifier = modifier.padding(horizontal = 7.dp),
        elevation = CardDefaults.cardElevation(15.dp)
    ) {
        NavigationBar(
            containerColor = Color.White
        ) {
            NavigationItems.values().forEach { item ->
                NavigationBarItem(
                    selected = currentRoute == item.route,
                    onClick = {
                        navController.navigate(item.route) {
                            popUpTo(navController.graph.startDestinationId)
                            launchSingleTop = true
                        }
                    },
                    label = { BottomItemText(item.title, currentRoute == item.route) },
                    alwaysShowLabel = true,
                    icon = { BottomIcon(ImageVector.vectorResource(item.iconId), currentRoute == item.route) },
                    colors = NavigationBarItemDefaults.colors(
                        indicatorColor = Color.White
                    )
                )
            }
        }
    }
}

@Composable
fun BottomIcon(iconVector: ImageVector, isSelected: Boolean) {
    Icon(
        imageVector = iconVector,
        tint = ColorUtils.getBottomColor(isSelected),
        contentDescription = null
    )
}

@Composable
fun BottomItemText(title: String, isSelected: Boolean) {
    Text(
        text = title,
        color = ColorUtils.getBottomColor(isSelected),
    )
}
