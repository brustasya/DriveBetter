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
import androidx.compose.ui.unit.dp
import androidx.compose.ui.window.Dialog

@Composable
fun StringAccountField(
    title: String,
    data: String,
    onEdit: (String) -> Unit = { }
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
            text = data,
            style = MaterialTheme.typography.bodyMedium,
            color = MaterialTheme.colorScheme.onSecondary
        )
    }
    if (isEditing) {
        EditTextDialog(
            initialText = data,
            onYes = onEdit,
            onDismiss = { isEditing = false }
        )
    }
}

@Composable
fun EditTextDialog(
    initialText: String,
    onYes: (String) -> Unit,
    onDismiss: () -> Unit,
    modifier: Modifier = Modifier,
) {
    var currentText by rememberSaveable {
        mutableStateOf(initialText)
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
                TextInputField(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(5.dp),
                    initialText = initialText,
                    onChange = { currentText = it },
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
                            onYes(currentText)
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
fun TextInputField(
    modifier: Modifier,
    initialText: String,
    onDone: (String) -> Unit,
    onChange: (String) -> Unit
) {
    var text by rememberSaveable { mutableStateOf(initialText) }
    TextField(
        modifier = modifier,
        value = text,
        onValueChange = {
            text = it
            onChange(it)
        },
        singleLine = true,
        keyboardOptions = KeyboardOptions(imeAction = ImeAction.Done),
        keyboardActions = KeyboardActions(
            onDone = { onDone(text) }
        ),
        colors = TextFieldDefaults.colors(
            cursorColor = MaterialTheme.colorScheme.primary,
            focusedIndicatorColor = MaterialTheme.colorScheme.primary,
            unfocusedContainerColor = Color.Transparent,
            focusedContainerColor = Color.Transparent
        )
    )
}
