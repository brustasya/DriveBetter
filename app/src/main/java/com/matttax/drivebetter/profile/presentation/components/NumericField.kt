package com.matttax.drivebetter.profile.presentation.components

import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog

@Composable
fun NumericAccountField(
    title: String,
    data: Int,
    onEdit: (Int) -> Unit = { }
) {
    var isEditing by rememberSaveable { mutableStateOf(false) }
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
            text = title,
            style = MaterialTheme.typography.titleMedium,
            color = MaterialTheme.colorScheme.onPrimary
        )
        Text(
            modifier = Modifier
                .weight(0.6f)
                .clickable {
                    isEditing = true
                },
            text = data.toString(),
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSecondary
        )
    }
    if (isEditing) {
        EditNumberDialog(
            initialValue = data,
            onYes = onEdit,
            onDismiss = { isEditing = false }
        )
    }
}

@Composable
fun EditNumberDialog(
    initialValue: Int,
    onYes: (Int) -> Unit,
    onDismiss: () -> Unit,
    modifier: Modifier = Modifier,
) {
    var currentValue by rememberSaveable {
        mutableStateOf(initialValue)
    }
    Dialog(
        onDismissRequest = onDismiss
    ) {
        Surface(
            shape = RoundedCornerShape(16.dp),
        ) {
            Column(
                modifier = modifier,
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                Spacer(modifier = Modifier.height(10.dp))
                Text(
                    modifier = Modifier.padding(
                        horizontal = 15.dp,
                        vertical = 5.dp
                    ),
                    text = "Edit",
                    color = MaterialTheme.colorScheme.onPrimary,
                    style = MaterialTheme.typography.titleLarge
                )
                NumberInputField(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(5.dp),
                    initialValue = initialValue,
                    onChange = { currentValue = it },
                    onDone = {
                        onYes(it)
                        onDismiss()
                    }
                )
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceEvenly
                ) {
                    Button(
                        onClick = onDismiss,
                        colors = ButtonDefaults.textButtonColors(Color.Transparent),
                    ) {
                        Text(
                            text = "Cancel",
                            color = MaterialTheme.colorScheme.onSecondary,
                            style = MaterialTheme.typography.titleMedium
                        )
                    }
                    Button(
                        onClick = {
                            onYes(currentValue)
                            onDismiss()
                        },
                        colors = ButtonDefaults.textButtonColors(Color.Transparent),
                    ) {
                        Text(
                            text = "Ok",
                            color = MaterialTheme.colorScheme.primary,
                            style = MaterialTheme.typography.titleMedium
                        )
                    }
                }
            }
        }
    }
}

@Composable
fun NumberInputField(
    modifier: Modifier,
    initialValue: Int,
    onDone: (Int) -> Unit,
    onChange: (Int) -> Unit
) {
    var value by rememberSaveable { mutableStateOf(initialValue) }
    TextField(
        modifier = modifier,
        value = value.toString(),
        onValueChange = {
            it.toIntOrNull()?.also { number ->
                value = number
                onChange(number)
            } ?: run {
                value = 0
            }
        },
        singleLine = true,
        keyboardOptions = KeyboardOptions(
            imeAction = ImeAction.Done,
            keyboardType = KeyboardType.Number
        ),
        keyboardActions = KeyboardActions(
            onDone = { onDone(value) }
        ),
        colors = TextFieldDefaults.colors(
            cursorColor = MaterialTheme.colorScheme.primary,
            focusedIndicatorColor = MaterialTheme.colorScheme.primary,
            unfocusedContainerColor = Color.Transparent,
            focusedContainerColor = Color.Transparent
        )
    )
}