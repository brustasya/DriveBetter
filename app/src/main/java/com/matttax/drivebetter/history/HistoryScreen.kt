package com.matttax.drivebetter.history

import android.content.res.Configuration
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.style.TextDecoration
import androidx.compose.ui.unit.dp
import com.matttax.drivebetter.R
import com.matttax.drivebetter.ui.common.StarRatingBar
import com.matttax.drivebetter.ui.common.Title
import com.matttax.drivebetter.ui.utils.ColorUtils

@Composable
fun HistoryScreen(viewModel: RidesHistoryViewModel) {
    val driversRides by viewModel.driversRides.collectAsState()
    val passengersRides by viewModel.passengerRides.collectAsState()
    Column {
        Title(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            text = "History",
        )
        Text(
            modifier = Modifier.padding(
                horizontal = 15.dp,
                vertical = 2.dp
            ),
            text = "Driver"
        )
        LazyColumn(
            modifier = Modifier.padding(7.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            items(driversRides.size) {
                RideItem(
                    ride = driversRides[it],
                ) { }
            }
        }
        Spacer(Modifier.height(20.dp))
        Text(
            modifier = Modifier.padding(
                horizontal = 15.dp,
                vertical = 2.dp
            ),
            text = "Passenger"
        )
        LazyColumn(
            modifier = Modifier.padding(7.dp),
            verticalArrangement = Arrangement.spacedBy(8.dp),
        ) {
            items(passengersRides.size) {
                RideItem(
                    ride = passengersRides[it],
                ) { }
            }
        }
    }
}

@Composable
fun RideItem(
    ride: RideUiModel,
    onClick: (Int) -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(
                horizontal = 15.dp,
                vertical = 2.dp
            )
            .clickable { onClick(ride.id) },
        shape = MaterialTheme.shapes.small,
        elevation = CardDefaults.cardElevation(defaultElevation = 5.dp),
        colors = CardDefaults.cardColors(MaterialTheme.colorScheme.primaryContainer)
    ) {
        Row(
            modifier = Modifier.padding(5.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(
                modifier = Modifier.weight(0.7f),
                verticalArrangement = Arrangement.Center
            ) {
                Text(
                    text = ride.title,
                    style = MaterialTheme.typography.titleMedium,
                    color = MaterialTheme.colorScheme.onPrimary
                )
                Text(
                    text = ride.location,
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSecondary
                )
            }
            Box(
                modifier = Modifier.weight(0.3f),
                contentAlignment = Alignment.CenterEnd
            ) {
                if (ride.rating != null) {
                    Row(
                        modifier = Modifier.padding(5.dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = ride.rating.toString(),
                            style = MaterialTheme.typography.bodyMedium,
                        )
                        StarRatingBar(
                            rating = ride.rating / 10,
                            starSize = 30.dp,
                            starCount = 1
                        )
                    }
                } else {
                    IconButton(
                        onClick = { /*TODO*/ }
                    ) {
                        Icon(
                            painter = painterResource(id = R.drawable.ic_baseline_account_circle_24),
                            contentDescription = null
                        )
                    }
                }
            }
        }
    }
}
