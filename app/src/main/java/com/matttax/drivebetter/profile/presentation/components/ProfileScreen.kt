package com.matttax.drivebetter.profile.presentation.components

import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog
import coil.compose.AsyncImage
import com.matttax.drivebetter.R
import com.matttax.drivebetter.profile.domain.Gender
import com.matttax.drivebetter.profile.domain.asString
import com.matttax.drivebetter.profile.presentation.ProfileViewModel
import com.matttax.drivebetter.ui.common.StarRatingBar
import com.matttax.drivebetter.ui.common.Title

@Composable
fun ProfileScreen(viewModel: ProfileViewModel) {
    val account by viewModel.account.collectAsState()
    val selectVideoLauncher = rememberLauncherForActivityResult(
        contract = ActivityResultContracts.GetContent(),
        onResult = { uri -> uri?.let(viewModel::onAvatarUpdated) }
    )
    Column(
        modifier = Modifier.verticalScroll(rememberScrollState()),
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Title(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            text = "Profile",
        )
        Card(
            modifier = Modifier.fillMaxWidth(0.8f),
            colors = CardDefaults.cardColors(
                containerColor = Color.Transparent
            )
        ) {
            AsyncImage(
                modifier = Modifier
                    .align(Alignment.CenterHorizontally)
                    .clip(CircleShape),
                model = account.avatarUri,
                placeholder = painterResource(R.drawable.ic_baseline_account_circle_24),
                contentDescription = null,
                contentScale = ContentScale.FillWidth
            )
        }
        Button(
            onClick = {
                selectVideoLauncher.launch("image/jpeg")
            }
        ) {
            Text("Change avatar")
        }
        Spacer(modifier = Modifier.height(20.dp))
        StringAccountField(
            title = "Name",
            data = account.name ?: "empty",
            onEdit = viewModel::onNameUpdated
        )
        StringAccountField(
            title = "City",
            data = account.city ?: "empty",
            onEdit = viewModel::onCityUpdated
        )
        NumericAccountField(
            title = "Age",
            data = account.age ?: -1,
            onEdit = viewModel::onAgeUpdated
        )
        StringAccountField(
            title = "Gender (M/F)",
            data = account.gender?.asString() ?: "unknown",
            onEdit = {
                when (it.trim().uppercase()) {
                    "M" -> viewModel.onGenderUpdated(Gender.MALE)
                    "F" -> viewModel.onGenderUpdated(Gender.FEMALE)
                }
            }
        )
        StringAccountField(
            title = "License",
            data = account.driversLicenseId ?: "empty",
            onEdit = viewModel::onLicenseUpdated
        )
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(
                    horizontal = 15.dp,
                    vertical = 7.dp
                ),
            horizontalArrangement = Arrangement.Center,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                modifier = Modifier.weight(0.4f),
                text = "Rating",
                style = MaterialTheme.typography.titleMedium,
                color = MaterialTheme.colorScheme.onPrimary
            )
            Text(
                modifier = Modifier.weight(0.6f),
                text = (account.rating?.toFloat() ?: 9.6f).toString(),
                style = MaterialTheme.typography.bodyMedium,
                color = MaterialTheme.colorScheme.onSecondary
            )
        }
    }
}
